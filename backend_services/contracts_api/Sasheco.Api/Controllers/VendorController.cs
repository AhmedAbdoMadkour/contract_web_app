using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Sasheco.Application.Vendors.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/vendor")]
[Authorize]
public class VendorController : ControllerBase
{
    private readonly ILogger<VendorController> _logger;
    private readonly SashecoDbContext _context;

    public VendorController(ILogger<VendorController> logger, SashecoDbContext context)
    {
        _logger = logger;
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<VendorDto>>> GetVendors([FromQuery] int page = 1, [FromQuery] int pageSize = 10, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Getting vendors");
        
        var language = Request.Headers["Accept-Language"].ToString();
        bool isArabic = language.StartsWith("ar");
        
        var vendors = await _context.Vendors
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(v => new VendorDto
            {
                Id = v.Id,
                Name = isArabic && !string.IsNullOrEmpty(v.NameAr) ? v.NameAr : v.NameEn,
                ContactPerson = isArabic && !string.IsNullOrEmpty(v.ContactPersonAr) ? v.ContactPersonAr : v.ContactPersonEn,
                Email = v.Email,
                Phone = v.Phone,
                Status = v.Status,
                CreatedAt = v.CreatedAt
            })
            .ToListAsync(cancellationToken);

        return Ok(vendors);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<VendorDto>> GetVendor(Guid id, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Getting vendor {Id}", id);
        
        var language = Request.Headers["Accept-Language"].ToString();
        bool isArabic = language.StartsWith("ar");
        
        var vendor = await _context.Vendors
            .Where(v => v.Id == id)
            .Select(v => new VendorDto
            {
                Id = v.Id,
                Name = isArabic && !string.IsNullOrEmpty(v.NameAr) ? v.NameAr : v.NameEn,
                ContactPerson = isArabic && !string.IsNullOrEmpty(v.ContactPersonAr) ? v.ContactPersonAr : v.ContactPersonEn,
                Email = v.Email,
                Phone = v.Phone,
                Status = v.Status,
                CreatedAt = v.CreatedAt
            })
            .FirstOrDefaultAsync(cancellationToken);

        if (vendor == null) return NotFound();

        return Ok(vendor);
    }

    [HttpPost]
    public async Task<ActionResult<VendorDto>> CreateVendor([FromBody] CreateVendorDto request, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Creating vendor {Name}", request.NameEn);
        
        var vendor = new Vendor
        {
            Id = Guid.NewGuid(),
            NameEn = request.NameEn,
            NameAr = request.NameAr,
            ContactPersonEn = request.ContactPersonEn,
            ContactPersonAr = request.ContactPersonAr,
            Email = request.Email,
            Phone = request.Phone,
            Status = "Active",
            CreatedAt = DateTime.UtcNow
        };

        _context.Vendors.Add(vendor);
        await _context.SaveChangesAsync(cancellationToken);

        var language = Request.Headers["Accept-Language"].ToString();
        bool isArabic = language.StartsWith("ar");
        
        var dto = new VendorDto
        {
            Id = vendor.Id,
            Name = isArabic && !string.IsNullOrEmpty(vendor.NameAr) ? vendor.NameAr : vendor.NameEn,
            ContactPerson = isArabic && !string.IsNullOrEmpty(vendor.ContactPersonAr) ? vendor.ContactPersonAr : vendor.ContactPersonEn,
            Email = vendor.Email,
            Phone = vendor.Phone,
            Status = vendor.Status,
            CreatedAt = vendor.CreatedAt
        };

        return CreatedAtAction(nameof(GetVendor), new { id = vendor.Id }, dto);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateVendor(Guid id, [FromBody] UpdateVendorDto request, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Updating vendor {Id}", id);
        
        var vendor = await _context.Vendors.FindAsync(new object[] { id }, cancellationToken);
        if (vendor == null) return NotFound();

        if (!string.IsNullOrEmpty(request.NameEn)) vendor.NameEn = request.NameEn;
        if (!string.IsNullOrEmpty(request.NameAr)) vendor.NameAr = request.NameAr;
        if (!string.IsNullOrEmpty(request.ContactPersonEn)) vendor.ContactPersonEn = request.ContactPersonEn;
        if (!string.IsNullOrEmpty(request.ContactPersonAr)) vendor.ContactPersonAr = request.ContactPersonAr;
        if (!string.IsNullOrEmpty(request.Email)) vendor.Email = request.Email;
        if (!string.IsNullOrEmpty(request.Phone)) vendor.Phone = request.Phone;
        if (!string.IsNullOrEmpty(request.Status)) vendor.Status = request.Status;
        
        await _context.SaveChangesAsync(cancellationToken);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteVendor(Guid id, CancellationToken cancellationToken)
    {
        _logger.LogInformation("Deleting vendor {Id}", id);
        
        var vendor = await _context.Vendors.FindAsync(new object[] { id }, cancellationToken);
        if (vendor == null) return NotFound();

        _context.Vendors.Remove(vendor);
        await _context.SaveChangesAsync(cancellationToken);
        
        return NoContent();
    }
}
