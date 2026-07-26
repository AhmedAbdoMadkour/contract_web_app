using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Approvals.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Sasheco.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ApprovalController : ControllerBase
    {
        private readonly SashecoDbContext _context;

        public ApprovalController(SashecoDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ApprovalDto>>> GetApprovals(CancellationToken cancellationToken)
        {
            var approvals = await _context.Approvals
                .Select(a => new ApprovalDto
                {
                    Id = a.Id,
                    Title = a.Title,
                    Description = a.Description,
                    Status = a.Status,
                    RequestedBy = a.RequestedBy,
                    CreatedAt = a.CreatedAt,
                    UpdatedAt = a.UpdatedAt
                })
                .ToListAsync(cancellationToken);
            
            return Ok(approvals);
        }

        [HttpGet("{id:guid}")]
        public async Task<ActionResult<ApprovalDto>> GetApproval(Guid id, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals
                .Where(a => a.Id == id)
                .Select(a => new ApprovalDto
                {
                    Id = a.Id,
                    Title = a.Title,
                    Description = a.Description,
                    Status = a.Status,
                    RequestedBy = a.RequestedBy,
                    CreatedAt = a.CreatedAt,
                    UpdatedAt = a.UpdatedAt
                })
                .FirstOrDefaultAsync(cancellationToken);

            if (approval == null) return NotFound();

            return Ok(approval);
        }

        [HttpPost]
        public async Task<ActionResult<ApprovalDto>> CreateApproval([FromBody] CreateApprovalDto createDto, CancellationToken cancellationToken)
        {
            var approval = new Approval
            {
                Id = Guid.NewGuid(),
                Title = createDto.Title,
                Description = createDto.Description,
                Status = "Pending",
                RequestedBy = createDto.RequestedBy,
                CreatedAt = DateTime.UtcNow
            };

            _context.Approvals.Add(approval);
            await _context.SaveChangesAsync(cancellationToken);

            var dto = new ApprovalDto
            {
                Id = approval.Id,
                Title = approval.Title,
                Description = approval.Description,
                Status = approval.Status,
                RequestedBy = approval.RequestedBy,
                CreatedAt = approval.CreatedAt
            };

            return CreatedAtAction(nameof(GetApproval), new { id = approval.Id }, dto);
        }

        [HttpPost("{id:guid}/approve")]
        public async Task<ActionResult<ApprovalDto>> Approve(Guid id, [FromForm] IFormFile? attachment, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            if (approval.Status != "Pending")
            {
                return BadRequest("Only pending approvals can be approved.");
            }

            approval.Status = "Approved";
            approval.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync(cancellationToken);

            return Ok(new ApprovalDto
            {
                Id = approval.Id,
                Title = approval.Title,
                Description = approval.Description,
                Status = approval.Status,
                RequestedBy = approval.RequestedBy,
                CreatedAt = approval.CreatedAt,
                UpdatedAt = approval.UpdatedAt
            });
        }

        [HttpPost("{id:guid}/reject")]
        public async Task<ActionResult<ApprovalDto>> Reject(Guid id, [FromForm] IFormFile? attachment, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            if (approval.Status != "Pending")
            {
                return BadRequest("Only pending approvals can be rejected.");
            }

            approval.Status = "Rejected";
            approval.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync(cancellationToken);

            return Ok(new ApprovalDto
            {
                Id = approval.Id,
                Title = approval.Title,
                Description = approval.Description,
                Status = approval.Status,
                RequestedBy = approval.RequestedBy,
                CreatedAt = approval.CreatedAt,
                UpdatedAt = approval.UpdatedAt
            });
        }
        
        [HttpDelete("{id:guid}")]
        public async Task<IActionResult> DeleteApproval(Guid id, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            _context.Approvals.Remove(approval);
            await _context.SaveChangesAsync(cancellationToken);

            return NoContent();
        }
        [HttpPut("{id:guid}/status")]
        public async Task<IActionResult> UpdateStatus(Guid id, [FromBody] string newStatus, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            var validTransitions = new Dictionary<string, string[]>
            {
                { "Pending", new[] { "UnderReview", "Approved", "Rejected" } },
                { "UnderReview", new[] { "Approved", "Rejected", "NeedMoreInfo" } },
                { "NeedMoreInfo", new[] { "UnderReview", "Rejected" } },
                { "Approved", new[] { "Completed" } },
                { "Rejected", new[] { "Closed" } },
                { "Completed", new string[] { } },
                { "Closed", new string[] { } }
            };

            if (!validTransitions.ContainsKey(approval.Status) || !validTransitions[approval.Status].Contains(newStatus))
            {
                return BadRequest($"Invalid state transition from {approval.Status} to {newStatus}.");
            }

            approval.Status = newStatus;
            approval.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync(cancellationToken);
            return NoContent();
        }
    }
}
