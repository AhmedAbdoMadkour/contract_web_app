using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Interfaces;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

public record AddContractItemRequest(decimal Price, int Quantity, string DescriptionEn, string DescriptionAr);
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
    private readonly SashecoDbContext _context;

    public ContractsController(
        IRepository<Contract> contractRepository,
        IRepository<ContractItem> contractItemRepository,
        SashecoDbContext context)
    {
        _contractRepository = contractRepository;
        _contractItemRepository = contractItemRepository;
        _context = context;
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
            DescriptionEn = request.DescriptionEn,
            DescriptionAr = request.DescriptionAr
        };

        await _contractItemRepository.AddAsync(item);
        return Ok(item);
    }

    [HttpPut("{id}/terms")]
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
}
