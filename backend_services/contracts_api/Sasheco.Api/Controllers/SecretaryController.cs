using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Secretary.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class SecretaryController : ControllerBase
{
    private readonly SashecoDbContext _context;

    public SecretaryController(SashecoDbContext context)
    {
        _context = context;
    }

    [HttpGet("inbox")]
    public async Task<ActionResult<IEnumerable<SecretaryInboxItemDto>>> GetInbox(CancellationToken cancellationToken)
    {
        var inbox = await _context.SecretaryInboxItems
            .Select(i => new SecretaryInboxItemDto
            {
                Id = i.Id,
                Sender = i.Sender,
                Subject = i.Subject,
                Content = i.Content,
                IsRead = i.IsRead,
                ReceivedAt = i.ReceivedAt
            })
            .ToListAsync(cancellationToken);

        return Ok(inbox);
    }

    [HttpGet("tasks")]
    public async Task<ActionResult<IEnumerable<SecretaryTaskDto>>> GetTasks(CancellationToken cancellationToken)
    {
        var tasks = await _context.SecretaryTasks
            .Select(t => new SecretaryTaskDto
            {
                Id = t.Id,
                Title = t.Title,
                Description = t.Description,
                Status = t.Status,
                CreatedAt = t.CreatedAt,
                DueDate = t.DueDate
            })
            .ToListAsync(cancellationToken);

        return Ok(tasks);
    }

    [HttpPost("tasks")]
    public async Task<ActionResult<SecretaryTaskDto>> CreateTask([FromBody] CreateSecretaryTaskRequest request, CancellationToken cancellationToken)
    {
        var task = new SecretaryTask
        {
            Id = Guid.NewGuid(),
            Title = request.Title,
            Description = request.Description,
            Status = "Pending",
            CreatedAt = DateTime.UtcNow,
            DueDate = request.DueDate
        };

        _context.SecretaryTasks.Add(task);
        await _context.SaveChangesAsync(cancellationToken);

        var dto = new SecretaryTaskDto
        {
            Id = task.Id,
            Title = task.Title,
            Description = task.Description,
            Status = task.Status,
            CreatedAt = task.CreatedAt,
            DueDate = task.DueDate
        };

        return CreatedAtAction(nameof(GetTasks), new { id = dto.Id }, dto);
    }

    [HttpPut("tasks/{id}/complete")]
    public async Task<IActionResult> CompleteTask(Guid id, CancellationToken cancellationToken)
    {
        var task = await _context.SecretaryTasks.FindAsync(new object[] { id }, cancellationToken);
        if (task == null) return NotFound();

        task.Status = "Completed";
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }

    [HttpPost("documents/upload")]
    public async Task<ActionResult<SecretaryDocumentDto>> UploadDocument([FromForm] IFormFile file, CancellationToken cancellationToken)
    {
        if (file == null || file.Length == 0)
            return BadRequest("No file uploaded.");

        var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads");
        if (!Directory.Exists(uploadsFolder))
            Directory.CreateDirectory(uploadsFolder);

        var filePath = Path.Combine(uploadsFolder, file.FileName);

        using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream, cancellationToken);
        }

        var document = new SecretaryDocument
        {
            Id = Guid.NewGuid(),
            FileName = file.FileName,
            FilePath = filePath,
            SizeBytes = file.Length,
            UploadedBy = User.Identity?.Name ?? "Unknown",
            UploadedAt = DateTime.UtcNow
        };

        _context.SecretaryDocuments.Add(document);
        await _context.SaveChangesAsync(cancellationToken);

        return Ok(new SecretaryDocumentDto
        {
            Id = document.Id,
            FileName = document.FileName,
            FilePath = document.FilePath,
            SizeBytes = document.SizeBytes,
            UploadedBy = document.UploadedBy,
            UploadedAt = document.UploadedAt
        });
    }
}
