using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/contract-templates")]
[Authorize]
public class ContractTemplatesController : ControllerBase
{
    private readonly SashecoDbContext _context;

    public ContractTemplatesController(SashecoDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetTemplates()
    {
        var templates = await _context.ContractTemplates
            .Include(t => t.Items)
            .ToListAsync();

        return Ok(templates);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetTemplate(Guid id)
    {
        var template = await _context.ContractTemplates
            .Include(t => t.Items)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (template == null) return NotFound();

        return Ok(template);
    }

    [HttpPost]
    [Authorize(Roles = "Secretary,Admin")]
    public async Task<IActionResult> CreateTemplate([FromBody] ContractTemplate request)
    {
        request.Id = Guid.NewGuid();
        request.CreatedAt = DateTime.UtcNow;

        if (request.Items != null)
        {
            foreach (var item in request.Items)
            {
                item.Id = Guid.NewGuid();
                item.ContractTemplateId = request.Id;
            }
        }

        _context.ContractTemplates.Add(request);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetTemplate), new { id = request.Id }, request);
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "Secretary,Admin")]
    public async Task<IActionResult> UpdateTemplate(Guid id, [FromBody] ContractTemplate request)
    {
        var existing = await _context.ContractTemplates
            .Include(t => t.Items)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (existing == null) return NotFound();

        existing.Title = request.Title;
        existing.Status = request.Status;

        _context.TemplateItems.RemoveRange(existing.Items);

        if (request.Items != null)
        {
            foreach (var item in request.Items)
            {
                item.Id = Guid.NewGuid();
                item.ContractTemplateId = existing.Id;
                existing.Items.Add(item);
            }
        }

        await _context.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "Secretary,Admin")]
    public async Task<IActionResult> DeleteTemplate(Guid id)
    {
        var template = await _context.ContractTemplates.FindAsync(id);
        if (template == null) return NotFound();

        _context.ContractTemplates.Remove(template);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
