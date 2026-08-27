using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Interfaces;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

public record AddContractItemRequest(decimal Price, int Quantity, string ItemCode, string ItemName);
public record UpdateContractItemRequest(decimal Price, int Quantity, string ItemCode, string ItemName);
public record AddContractTermRequest(string Title, string Content);
public record UpdateContractTermRequest(string Title, string Content);
public record UpdateContractTermsRequest(string TermsAndConditions);
public record UpdateContractFinancialsRequest(decimal AdvancePayment, string PaymentTerms);
public record ApproveContractRequest(string Comments);
public record UpdateContractStatusRequest(string Status);

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ContractsController : ControllerBase
{
    private readonly IRepository<Contract> _contractRepository;
    private readonly IRepository<ContractItem> _contractItemRepository;
    private readonly IRepository<ContractTerm> _contractTermRepository;
    private readonly SashecoDbContext _context;
    private readonly Sasheco.Application.Engineering.Services.IContractPdfGenerator _pdfGenerator;

    public ContractsController(
        IRepository<Contract> contractRepository,
        IRepository<ContractItem> contractItemRepository,
        IRepository<ContractTerm> contractTermRepository,
        SashecoDbContext context,
        Sasheco.Application.Engineering.Services.IContractPdfGenerator pdfGenerator)
    {
        _contractRepository = contractRepository;
        _contractItemRepository = contractItemRepository;
        _contractTermRepository = contractTermRepository;
        _context = context;
        _pdfGenerator = pdfGenerator;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllContracts()
    {
        var contracts = await _context.Contracts
            .Include(c => c.Project)
            .Include(c => c.Vendor)
            .ToListAsync();

        return Ok(contracts);
    }

    [HttpPost]
    [Authorize(Roles = "Engineering,Admin")]
    public async Task<IActionResult> CreateContract([FromBody] CreateContractRequest request)
    {
        var contract = new Contract
        {
            Id = Guid.NewGuid(),
            ProjectId = request.ProjectId,
            VendorId = request.VendorId,
            TermsAndConditions = request.TermsAndConditions,
            Status = ContractStatus.Draft
        };

        await _contractRepository.AddAsync(contract);

        var dto = new ContractSummaryDto(contract.Id, contract.ProjectId, contract.VendorId, contract.Status.ToString());
        return CreatedAtAction(nameof(GetContract), new { id = contract.Id }, dto);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetContract(Guid id)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        return Ok(new ContractSummaryDto(contract.Id, contract.ProjectId, contract.VendorId, contract.Status.ToString()));
    }

    [HttpPost("{id}/items")]
    [Authorize(Roles = "Engineering,Admin")]
    public async Task<IActionResult> AddContractItem(Guid id, [FromBody] AddContractItemRequest request)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        var item = new ContractItem
        {
            Id = Guid.NewGuid(),
            ContractId = id,
            Price = request.Price,
            Quantity = request.Quantity,
            ItemCode = request.ItemCode,
            ItemName = request.ItemName
        };

        await _contractItemRepository.AddAsync(item);
        return Ok(item);
    }

    [HttpPut("{id}/items/{itemId}")]
    [Authorize(Roles = "Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> UpdateContractItem(Guid id, Guid itemId, [FromBody] UpdateContractItemRequest request)
    {
        var item = await _contractItemRepository.GetByIdAsync(itemId);
        if (item == null || item.ContractId != id) return NotFound();

        item.Price = request.Price;
        item.Quantity = request.Quantity;
        item.ItemCode = request.ItemCode;
        item.ItemName = request.ItemName;

        await _contractItemRepository.UpdateAsync(item);
        return NoContent();
    }

    [HttpDelete("{id}/items/{itemId}")]
    [Authorize(Roles = "Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> DeleteContractItem(Guid id, Guid itemId)
    {
        var item = await _contractItemRepository.GetByIdAsync(itemId);
        if (item == null || item.ContractId != id) return NotFound();

        await _contractItemRepository.DeleteAsync(item);
        return NoContent();
    }

    [HttpPost("{id}/terms")]
    [Authorize(Roles = "Secretary,Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> AddContractTerm(Guid id, [FromBody] AddContractTermRequest request)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        var term = new ContractTerm
        {
            Id = Guid.NewGuid(),
            ContractId = id,
            Title = request.Title,
            Content = request.Content
        };

        await _contractTermRepository.AddAsync(term);
        return Ok(term);
    }

    [HttpPut("{id}/terms/{termId}")]
    [Authorize(Roles = "Secretary,Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> UpdateContractTerm(Guid id, Guid termId, [FromBody] UpdateContractTermRequest request)
    {
        var term = await _contractTermRepository.GetByIdAsync(termId);
        if (term == null || term.ContractId != id) return NotFound();

        term.Title = request.Title;
        term.Content = request.Content;

        await _contractTermRepository.UpdateAsync(term);
        return NoContent();
    }

    [HttpDelete("{id}/terms/{termId}")]
    [Authorize(Roles = "Secretary,Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> DeleteContractTerm(Guid id, Guid termId)
    {
        var term = await _contractTermRepository.GetByIdAsync(termId);
        if (term == null || term.ContractId != id) return NotFound();

        await _contractTermRepository.DeleteAsync(term);
        return NoContent();
    }

    [HttpPut("{id}/legacy-terms")]
    [Authorize(Roles = "Secretary,Admin")]
    public async Task<IActionResult> UpdateTerms(Guid id, [FromBody] UpdateContractTermsRequest request)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        contract.TermsAndConditions = request.TermsAndConditions;
        await _contractRepository.UpdateAsync(contract);
        
        return NoContent();
    }

    [HttpPut("{id}/financials")]
    [Authorize(Roles = "Financial,Admin")]
    public async Task<IActionResult> UpdateFinancials(Guid id, [FromBody] UpdateContractFinancialsRequest request)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        // Normally we would map these financials to a specific entity or property
        // For scaffolding purposes we simulate the update
        await _contractRepository.UpdateAsync(contract);
        
        return NoContent();
    }

    [HttpPost("{id}/approve")]
    [Authorize(Roles = "Management,Admin")]
    public async Task<IActionResult> ApproveContract(Guid id, [FromBody] ApproveContractRequest request)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        contract.Status = ContractStatus.Active;
        await _contractRepository.UpdateAsync(contract);
        
        return Ok(new { message = "Contract approved." });
    }

    [HttpPut("{id}/status")]
    public async Task<IActionResult> UpdateStatus(Guid id, [FromBody] UpdateContractStatusRequest request)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound();

        if (!Enum.TryParse<ContractStatus>(request.Status, true, out var status))
        {
            return BadRequest(new { message = "Invalid contract status." });
        }

        contract.Status = status;
        await _contractRepository.UpdateAsync(contract);
        
        return NoContent();
    }

    [HttpGet("{id}/export-pdf")]
    [AllowAnonymous] // Might want to restrict this depending on auth setup for file downloads
    public async Task<IActionResult> ExportPdf(Guid id)
    {
        var contract = await _context.Contracts
            .Include(c => c.Project)
            .Include(c => c.Vendor)
            .Include(c => c.Items)
            .Include(c => c.Terms)
            .FirstOrDefaultAsync(c => c.Id == id);

        if (contract == null) return NotFound();

        try
        {
            var pdfBytes = _pdfGenerator.GeneratePdf(contract);
            return File(pdfBytes, "application/pdf", $"Contract_{contract.Id.ToString().Substring(0, 8)}.pdf");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error generating PDF: {ex.Message}");
        }
    }

    [HttpPost("{id}/drawings")]
    [Authorize(Roles = "Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> UploadDrawing(Guid id, IFormFile file)
    {
        var contract = await _contractRepository.GetByIdAsync(id);
        if (contract == null) return NotFound("Contract not found");

        if (file == null || file.Length == 0)
            return BadRequest("No file uploaded");

        // Simple mock save logic (in reality you'd upload to blob storage or save to disk)
        // For demonstration, we'll pretend it's saved and generate a mock URL.
        var fileUrl = $"/uploads/drawings/{Guid.NewGuid()}_{file.FileName}";
        
        var drawing = new DrawingAttachment
        {
            Id = Guid.NewGuid(),
            ContractId = id,
            FileName = file.FileName,
            FileUrl = fileUrl,
            UploadedAt = DateTimeOffset.UtcNow
        };

        _context.DrawingAttachments.Add(drawing);
        await _context.SaveChangesAsync();

        return Ok(drawing);
    }

    [HttpDelete("{id}/drawings/{drawingId}")]
    [Authorize(Roles = "Engineering,ProjectManager,Admin")]
    public async Task<IActionResult> DeleteDrawing(Guid id, Guid drawingId)
    {
        var drawing = await _context.DrawingAttachments.FirstOrDefaultAsync(d => d.Id == drawingId && d.ContractId == id);
        if (drawing == null) return NotFound();

        _context.DrawingAttachments.Remove(drawing);
        await _context.SaveChangesAsync();
        
        return NoContent();
    }
}
