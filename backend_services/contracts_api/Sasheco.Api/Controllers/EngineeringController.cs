using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Engineering.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using FluentValidation;
using ClosedXML.Excel;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class EngineeringController : ControllerBase
{
    private readonly SashecoDbContext _context;
    private readonly IValidator<CreateEngineeringProjectRequest> _createValidator;
    private readonly IValidator<UpdateProjectStatusRequest> _updateStatusValidator;
    private readonly Sasheco.Api.Services.ILocaleProvider _localeProvider;

    public EngineeringController(
        SashecoDbContext context,
        IValidator<CreateEngineeringProjectRequest> createValidator,
        IValidator<UpdateProjectStatusRequest> updateStatusValidator,
        Sasheco.Api.Services.ILocaleProvider localeProvider)
    {
        _context = context;
        _createValidator = createValidator;
        _updateStatusValidator = updateStatusValidator;
        _localeProvider = localeProvider;
    }

    [HttpGet("projects")]
    [Authorize(Roles = "Admin,ProjectManager,Auditor")]
    public async Task<IActionResult> GetProjects(CancellationToken cancellationToken)
    {
        var projects = await _context.Projects
            .Select(p => new
            {
                Id = p.Id,
                ProjectCode = p.ProjectCode,
                Name = _localeProvider.IsArabic ? p.NameAr : p.NameEn,
                Description = _localeProvider.IsArabic ? p.DescriptionAr : p.DescriptionEn,
                Status = p.Status,
                StartDate = p.StartDate
            })
            .ToListAsync(cancellationToken);

        return Ok(projects);
    }

    [HttpGet("projects/{id:guid}")]
    [Authorize(Roles = "Admin,ProjectManager,Auditor")]
    public async Task<IActionResult> GetProject(Guid id, CancellationToken cancellationToken)
    {
        var project = await _context.Projects
            .Where(p => p.Id == id)
            .Select(p => new
            {
                Id = p.Id,
                ProjectCode = p.ProjectCode,
                Name = _localeProvider.IsArabic ? p.NameAr : p.NameEn,
                Description = _localeProvider.IsArabic ? p.DescriptionAr : p.DescriptionEn,
                Status = p.Status,
                StartDate = p.StartDate
            })
            .FirstOrDefaultAsync(cancellationToken);

        if (project == null) return NotFound();

        return Ok(project);
    }

    [HttpGet("projects/{id:guid}/contracts")]
    [Authorize(Roles = "Admin,ProjectManager,Auditor,FinancialAnalyst")]
    public async Task<IActionResult> GetProjectContracts(Guid id, CancellationToken cancellationToken)
    {
        var projectExists = await _context.Projects.AnyAsync(p => p.Id == id, cancellationToken);
        if (!projectExists) return NotFound("Project not found.");

        var contracts = await _context.Contracts
            .Include(c => c.Items)
            .Include(c => c.Terms)
            .Include(c => c.DrawingAttachments)
            .Include(c => c.Vendor)
            .Where(c => c.ProjectId == id)
            .Select(c => new
            {
                Id = c.Id,
                VendorName = _localeProvider.IsArabic ? c.Vendor!.NameAr : c.Vendor!.NameEn,
                Status = c.Status.ToString(),
                Items = c.Items.Select(i => new
                {
                    Id = i.Id,
                    ItemCode = i.ItemCode,
                    ItemName = i.ItemName,
                    Quantity = i.Quantity,
                    Price = i.Price
                }),
                Terms = c.Terms.Select(t => new 
                {
                    Id = t.Id,
                    Title = t.Title,
                    Content = t.Content
                }),
                Drawings = c.DrawingAttachments.Select(d => new
                {
                    Id = d.Id,
                    FileName = d.FileName,
                    FileUrl = d.FileUrl
                })
            })
            .ToListAsync(cancellationToken);

        return Ok(contracts);
    }

    [HttpPost("projects")]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<IActionResult> CreateProject([FromBody] CreateEngineeringProjectRequest request, CancellationToken cancellationToken)
    {
        var validationResult = await _createValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        var project = new Project
        {
            Id = Guid.NewGuid(),
            ProjectCode = $"PRJ-{DateTime.UtcNow.Year}-{new Random().Next(1000, 9999)}",
            NameEn = request.NameEn,
            NameAr = request.NameAr,
            DescriptionEn = request.DescriptionEn,
            DescriptionAr = request.DescriptionAr,
            Status = "Planning",
            StartDate = request.StartDate ?? DateTime.UtcNow
        };

        _context.Projects.Add(project);
        await _context.SaveChangesAsync(cancellationToken);

        return CreatedAtAction(nameof(GetProject), new { id = project.Id }, project);
    }

    [HttpPut("projects/{id:guid}/status")]
    [Authorize(Roles = "Admin,ProjectManager")]
    public async Task<IActionResult> UpdateStatus(Guid id, [FromBody] UpdateProjectStatusRequest request, CancellationToken cancellationToken)
    {
        var validationResult = await _updateStatusValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        var project = await _context.Projects.FindAsync(new object[] { id }, cancellationToken);
        if (project == null) return NotFound();

        project.Status = request.Status;
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }

    [HttpPost("{contractId:guid}/items/bulk")]
    [Authorize(Roles = "Admin,Engineering,ProjectManager")]
    public async Task<IActionResult> AddItemsBulkAsync(Guid contractId, IFormFile file, CancellationToken cancellationToken)
    {
        if (file == null || file.Length == 0) return BadRequest("File is required.");
        
        var contract = await _context.Contracts.FindAsync(new object[] { contractId }, cancellationToken);
        if (contract == null) return NotFound("Contract not found.");

        using var stream = file.OpenReadStream();
        using var workbook = new XLWorkbook(stream);
        var worksheet = workbook.Worksheets.FirstOrDefault();
        if (worksheet == null) return BadRequest("No worksheet found.");

        var rows = worksheet.RowsUsed().Skip(1); // skip header
        var items = new List<ContractItem>();

        foreach (var row in rows)
        {
            var itemCode = row.Cell(1).GetString();
            var itemName = row.Cell(2).GetString();
            var quantityStr = row.Cell(3).GetString();
            var priceStr = row.Cell(4).GetString();

            if (string.IsNullOrWhiteSpace(itemName)) continue;

            if (int.TryParse(quantityStr, out int quantity) && decimal.TryParse(priceStr, out decimal price))
            {
                items.Add(new ContractItem
                {
                    Id = Guid.NewGuid(),
                    ContractId = contractId,
                    ItemCode = itemCode,
                    ItemName = itemName,
                    Quantity = quantity,
                    Price = price
                });
            }
        }

        if (items.Any())
        {
            await _context.ContractItems.AddRangeAsync(items, cancellationToken);
            await _context.SaveChangesAsync(cancellationToken);
        }

        return Ok(new { message = $"Added {items.Count} items." });
    }

    [HttpPut("{contractId:guid}/submit")]
    [Authorize(Roles = "Admin,Engineering,ProjectManager")]
    public async Task<IActionResult> SubmitContract(Guid contractId, [FromBody] SubmitContractRequest request, CancellationToken cancellationToken)
    {
        var contract = await _context.Contracts.FindAsync(new object[] { contractId }, cancellationToken);
        if (contract == null) return NotFound("Contract not found.");

        contract.PaymentTerms = request.PaymentTerms ?? string.Empty;
        contract.Status = ContractStatus.PendingSecretary;
        
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}

public record SubmitContractRequest(string PaymentTerms);
