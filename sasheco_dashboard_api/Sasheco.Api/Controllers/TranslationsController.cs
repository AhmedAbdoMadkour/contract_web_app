using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Policy = "RequireAdminRole")]
public class TranslationsController : ControllerBase
{
    private readonly SashecoDbContext _context;

    public TranslationsController(SashecoDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Translation>>> GetTranslations()
    {
        return await _context.Translations.ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Translation>> GetTranslation(int id)
    {
        var translation = await _context.Translations.FindAsync(id);

        if (translation == null)
        {
            return NotFound();
        }

        return translation;
    }

    [HttpPost]
    public async Task<ActionResult<Translation>> CreateTranslation(Translation translation)
    {
        _context.Translations.Add(translation);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetTranslation), new { id = translation.Id }, translation);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateTranslation(int id, Translation translation)
    {
        if (id != translation.Id)
        {
            return BadRequest();
        }

        _context.Entry(translation).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!TranslationExists(id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTranslation(int id)
    {
        var translation = await _context.Translations.FindAsync(id);
        if (translation == null)
        {
            return NotFound();
        }

        _context.Translations.Remove(translation);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool TranslationExists(int id)
    {
        return _context.Translations.Any(e => e.Id == id);
    }
}
