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
using System.Security.Claims;

namespace Sasheco.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ApprovalController : ControllerBase
    {
        private readonly SashecoDbContext _context;
        private readonly Sasheco.Api.Services.ILocaleProvider _localeProvider;

        public ApprovalController(SashecoDbContext context, Sasheco.Api.Services.ILocaleProvider localeProvider)
        {
            _context = context;
            _localeProvider = localeProvider;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ApprovalDto>>> GetApprovals(CancellationToken cancellationToken)
        {
            var approvals = await _context.Approvals
                .Select(a => new ApprovalDto
                {
                    Id = a.Id,
                    Title = _localeProvider.IsArabic ? a.TitleAr : a.TitleEn,
                    Description = _localeProvider.IsArabic ? a.DescriptionAr : a.DescriptionEn,
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
                    Title = _localeProvider.IsArabic ? a.TitleAr : a.TitleEn,
                    Description = _localeProvider.IsArabic ? a.DescriptionAr : a.DescriptionEn,
                    Status = a.Status,
                    RequestedBy = a.RequestedBy,
                    CreatedAt = a.CreatedAt,
                    UpdatedAt = a.UpdatedAt
                })
                .FirstOrDefaultAsync(cancellationToken);

            if (approval == null) return NotFound();

            return Ok(approval);
        }

        [HttpGet("{id:guid}/history")]
        public async Task<IActionResult> GetApprovalHistory(Guid id, CancellationToken cancellationToken)
        {
            var history = await _context.ApprovalHistories
                .Include(h => h.User)
                .Where(h => h.ApprovalId == id)
                .OrderByDescending(h => h.Timestamp)
                .Select(h => new 
                {
                    Id = h.Id,
                    ActionTaken = h.ActionTaken,
                    Comments = h.Comments,
                    Timestamp = h.Timestamp,
                    UserName = h.User!.Name
                })
                .ToListAsync(cancellationToken);

            return Ok(history);
        }

        [HttpPost]
        public async Task<ActionResult<ApprovalDto>> CreateApproval([FromBody] CreateApprovalDto createDto, CancellationToken cancellationToken)
        {
            var approval = new Approval
            {
                Id = Guid.NewGuid(),
                TitleEn = createDto.Title,
                TitleAr = createDto.Title,
                DescriptionEn = createDto.Description,
                DescriptionAr = createDto.Description,
                Status = "Draft", // Always start in Draft
                RequestedBy = createDto.RequestedBy,
                CreatedAt = DateTime.UtcNow
            };

            _context.Approvals.Add(approval);

            var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (Guid.TryParse(userIdString, out Guid userId))
            {
                _context.ApprovalHistories.Add(new ApprovalHistory
                {
                    Id = Guid.NewGuid(),
                    ApprovalId = approval.Id,
                    UserId = userId,
                    ActionTaken = "Created",
                    Comments = "Approval request created as Draft.",
                    Timestamp = DateTime.UtcNow
                });
            }

            await _context.SaveChangesAsync(cancellationToken);

            var dto = new ApprovalDto
            {
                Id = approval.Id,
                Title = _localeProvider.IsArabic ? approval.TitleAr : approval.TitleEn,
                Description = _localeProvider.IsArabic ? approval.DescriptionAr : approval.DescriptionEn,
                Status = approval.Status,
                RequestedBy = approval.RequestedBy,
                CreatedAt = approval.CreatedAt
            };

            return CreatedAtAction(nameof(GetApproval), new { id = approval.Id }, dto);
        }

        [HttpPost("{id:guid}/approve")]
        [Authorize(Roles = "Admin,ProjectManager,FinancialAnalyst")]
        public async Task<ActionResult<ApprovalDto>> Approve(Guid id, [FromForm] IFormFile? attachment, [FromForm] string? comments, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            if (approval.Status != "UnderReview" && approval.Status != "Pending")
            {
                return BadRequest("Only Pending or UnderReview approvals can be approved.");
            }

            approval.Status = "Approved";
            approval.UpdatedAt = DateTime.UtcNow;

            var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (Guid.TryParse(userIdString, out Guid userId))
            {
                _context.ApprovalHistories.Add(new ApprovalHistory
                {
                    Id = Guid.NewGuid(),
                    ApprovalId = approval.Id,
                    UserId = userId,
                    ActionTaken = "Approved",
                    Comments = comments ?? "Approved with no comments.",
                    Timestamp = DateTime.UtcNow
                });
            }

            await _context.SaveChangesAsync(cancellationToken);

            return Ok(new ApprovalDto
            {
                Id = approval.Id,
                Title = _localeProvider.IsArabic ? approval.TitleAr : approval.TitleEn,
                Description = _localeProvider.IsArabic ? approval.DescriptionAr : approval.DescriptionEn,
                Status = approval.Status,
                RequestedBy = approval.RequestedBy,
                CreatedAt = approval.CreatedAt,
                UpdatedAt = approval.UpdatedAt
            });
        }

        [HttpPost("{id:guid}/reject")]
        [Authorize(Roles = "Admin,ProjectManager,FinancialAnalyst")]
        public async Task<ActionResult<ApprovalDto>> Reject(Guid id, [FromForm] IFormFile? attachment, [FromForm] string? comments, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            if (approval.Status != "UnderReview" && approval.Status != "Pending")
            {
                return BadRequest("Only Pending or UnderReview approvals can be rejected.");
            }

            approval.Status = "Rejected";
            approval.UpdatedAt = DateTime.UtcNow;

            var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (Guid.TryParse(userIdString, out Guid userId))
            {
                _context.ApprovalHistories.Add(new ApprovalHistory
                {
                    Id = Guid.NewGuid(),
                    ApprovalId = approval.Id,
                    UserId = userId,
                    ActionTaken = "Rejected",
                    Comments = comments ?? "Rejected without a reason.",
                    Timestamp = DateTime.UtcNow
                });
            }

            await _context.SaveChangesAsync(cancellationToken);

            return Ok(new ApprovalDto
            {
                Id = approval.Id,
                Title = _localeProvider.IsArabic ? approval.TitleAr : approval.TitleEn,
                Description = _localeProvider.IsArabic ? approval.DescriptionAr : approval.DescriptionEn,
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
        public async Task<IActionResult> UpdateStatus(Guid id, [FromBody] string newStatus, [FromQuery] string? comments, CancellationToken cancellationToken)
        {
            var approval = await _context.Approvals.FindAsync(new object[] { id }, cancellationToken);
            if (approval == null) return NotFound();

            var validTransitions = new Dictionary<string, string[]>
            {
                { "Draft", new[] { "Pending" } },
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

            var userIdString = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (Guid.TryParse(userIdString, out Guid userId))
            {
                _context.ApprovalHistories.Add(new ApprovalHistory
                {
                    Id = Guid.NewGuid(),
                    ApprovalId = approval.Id,
                    UserId = userId,
                    ActionTaken = $"Status changed to {newStatus}",
                    Comments = comments ?? $"Moved from {approval.Status} to {newStatus}.",
                    Timestamp = DateTime.UtcNow
                });
            }

            await _context.SaveChangesAsync(cancellationToken);
            return NoContent();
        }
    }
}
