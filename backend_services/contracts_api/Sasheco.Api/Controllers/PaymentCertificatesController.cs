using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Enums;
using Sasheco.Infrastructure.Data;
using System.Security.Claims;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PaymentCertificatesController : ControllerBase
{
    private readonly SashecoDbContext _context;

    public PaymentCertificatesController(SashecoDbContext context)
    {
        _context = context;
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreatePaymentCertificateRequest request)
    {
        var contractExists = await _context.Contracts.AnyAsync(c => c.Id == request.ContractId);
        if (!contractExists)
        {
            return NotFound("Contract not found.");
        }

        var certificate = new PaymentCertificate
        {
            Id = Guid.NewGuid(),
            ContractId = request.ContractId,
            ReferenceNumber = request.ReferenceNumber,
            Description = request.Description,
            Notes = request.Notes,
            IssueDate = DateTime.UtcNow,
            Status = PaymentCertificateStatus.Draft,
            TotalAmount = 0
        };

        _context.PaymentCertificates.Add(certificate);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(Get), new { id = certificate.Id }, MapToDto(certificate));
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(Guid id)
    {
        var certificate = await _context.PaymentCertificates
            .Include(pc => pc.Items)
            .Include(pc => pc.Approvals)
            .FirstOrDefaultAsync(pc => pc.Id == id);

        if (certificate == null)
        {
            return NotFound();
        }

        return Ok(MapToDto(certificate));
    }

    [HttpGet("contract/{contractId}")]
    public async Task<IActionResult> ListByContract(Guid contractId)
    {
        var certificates = await _context.PaymentCertificates
            .Include(pc => pc.Items)
            .Include(pc => pc.Approvals)
            .Where(pc => pc.ContractId == contractId)
            .ToListAsync();

        return Ok(certificates.Select(MapToDto));
    }

    [HttpPut("{id}/items")]
    public async Task<IActionResult> UpdateItems(Guid id, [FromBody] UpdatePaymentCertificateItemsRequest request)
    {
        var certificate = await _context.PaymentCertificates
            .Include(pc => pc.Items)
            .FirstOrDefaultAsync(pc => pc.Id == id);

        if (certificate == null)
        {
            return NotFound();
        }

        if (certificate.Status != PaymentCertificateStatus.Draft && certificate.Status != PaymentCertificateStatus.Rejected)
        {
            return BadRequest("Can only update items when certificate is Draft or Rejected.");
        }

        _context.PaymentCertificateItems.RemoveRange(certificate.Items);
        
        decimal totalAmount = 0;
        foreach (var reqItem in request.Items)
        {
            var totalPrice = reqItem.Quantity * reqItem.UnitPrice;
            totalAmount += totalPrice;
            
            certificate.Items.Add(new PaymentCertificateItem
            {
                Id = Guid.NewGuid(),
                PaymentCertificateId = id,
                ContractItemId = reqItem.ContractItemId,
                Description = reqItem.Description,
                Quantity = reqItem.Quantity,
                UnitPrice = reqItem.UnitPrice,
                TotalPrice = totalPrice
            });
        }

        certificate.TotalAmount = totalAmount;
        await _context.SaveChangesAsync();

        return Ok(MapToDto(certificate));
    }

    [HttpPost("{id}/approve")]
    public async Task<IActionResult> Approve(Guid id, [FromBody] ApprovePaymentCertificateRequest request)
    {
        var certificate = await _context.PaymentCertificates
            .Include(pc => pc.Approvals)
            .FirstOrDefaultAsync(pc => pc.Id == id);

        if (certificate == null)
        {
            return NotFound();
        }

        var userIdString = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (!Guid.TryParse(userIdString, out Guid userId))
        {
            return Unauthorized();
        }

        var approval = new PaymentCertificateApproval
        {
            Id = Guid.NewGuid(),
            PaymentCertificateId = id,
            ApproverId = userId,
            Role = request.Role,
            IsApproved = request.IsApproved,
            Comments = request.Comments,
            ApprovalDate = DateTime.UtcNow
        };

        certificate.Approvals.Add(approval);

        if (!request.IsApproved)
        {
            certificate.Status = PaymentCertificateStatus.Rejected;
        }
        else
        {
            // Simple state machine simulation based on current status and role
            if (certificate.Status == PaymentCertificateStatus.Draft || certificate.Status == PaymentCertificateStatus.Rejected)
            {
                if (request.Role == ApprovalRole.SiteEngineer)
                {
                    certificate.Status = PaymentCertificateStatus.PendingEngineeringApproval;
                }
            }
            else if (certificate.Status == PaymentCertificateStatus.PendingEngineeringApproval && request.Role == ApprovalRole.ProjectManager)
            {
                certificate.Status = PaymentCertificateStatus.PendingFinanceApproval;
            }
            else if (certificate.Status == PaymentCertificateStatus.PendingFinanceApproval && request.Role == ApprovalRole.FinancialAnalyst)
            {
                certificate.Status = PaymentCertificateStatus.Approved;
            }
        }

        await _context.SaveChangesAsync();
        return Ok(MapToDto(certificate));
    }

    private static PaymentCertificateDto MapToDto(PaymentCertificate certificate)
    {
        return new PaymentCertificateDto(
            certificate.Id,
            certificate.ContractId,
            certificate.ReferenceNumber,
            certificate.IssueDate,
            certificate.Description,
            certificate.TotalAmount,
            certificate.Status,
            certificate.Notes,
            certificate.Items.Select(i => new PaymentCertificateItemDto(
                i.Id,
                i.ContractItemId,
                i.Description,
                i.Quantity,
                i.UnitPrice,
                i.TotalPrice
            )).ToList(),
            certificate.Approvals.Select(a => new PaymentCertificateApprovalDto(
                a.Id,
                a.ApproverId,
                a.Role,
                a.IsApproved,
                a.Comments,
                a.ApprovalDate
            )).ToList()
        );
    }
}
