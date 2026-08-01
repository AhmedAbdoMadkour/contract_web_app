using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Engineering.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using FluentValidation;

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
                    Description = _localeProvider.IsArabic ? i.DescriptionAr : i.DescriptionEn,
                    Quantity = i.Quantity,
                    Price = i.Price
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
}
