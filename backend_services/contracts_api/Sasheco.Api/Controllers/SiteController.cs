using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Sasheco.Application.Sites;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using FluentValidation;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class SiteController : ControllerBase
{
    private readonly ILogger<SiteController> _logger;
    private readonly SashecoDbContext _context;
    private readonly IValidator<CreateSiteDto> _createValidator;
    private readonly IValidator<UpdateSiteDto> _updateValidator;
    private readonly IValidator<UpdateSiteLocationDto> _updateLocationValidator;

    public SiteController(
        ILogger<SiteController> logger, 
        SashecoDbContext context,
        IValidator<CreateSiteDto> createValidator,
        IValidator<UpdateSiteDto> updateValidator,
        IValidator<UpdateSiteLocationDto> updateLocationValidator)
    {
        _logger = logger;
        _context = context;
        _createValidator = createValidator;
        _updateValidator = updateValidator;
        _updateLocationValidator = updateLocationValidator;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll(CancellationToken cancellationToken)
    {
        var sites = await _context.Sites
            .Select(s => new SiteDto
            {
                Id = s.Id,
                NameEn = s.NameEn,
                NameAr = s.NameAr,
                DescriptionEn = s.DescriptionEn,
                DescriptionAr = s.DescriptionAr,
                LocationEn = s.LocationEn,
                LocationAr = s.LocationAr,
                CreatedAt = s.CreatedAt,
                UpdatedAt = s.UpdatedAt
            })
            .ToListAsync(cancellationToken);

        return Ok(sites);
    }

    [HttpGet("dashboard")]
    public async Task<IActionResult> GetDashboard(CancellationToken cancellationToken)
    {
        var project = await _context.Projects
            .Include(p => p.Contracts)
                .ThenInclude(c => c.Items)
            .FirstOrDefaultAsync(cancellationToken);

        if (project == null)
        {
            return Ok(new
            {
                projectCode = "N/A",
                projectNameEn = "No Projects",
                projectNameAr = "لا يوجد مشاريع",
                totalContracts = 0,
                totalAddenda = 0,
                activeValue = "$0",
                contracts = new object[] {}
            });
        }

        var totalContracts = project.Contracts.Count;
        var activeValue = project.Contracts.SelectMany(c => c.Items).Sum(i => i.Price * i.Quantity);

        return Ok(new
        {
            projectCode = project.ProjectCode,
            projectNameEn = project.NameEn,
            projectNameAr = project.NameAr,
            totalContracts = totalContracts,
            totalAddenda = 0, // Mock for now if Addenda is not in the schema
            activeValue = $"${activeValue:N2}",
            contracts = project.Contracts.Select(c => new 
            { 
                id = c.Id,
                status = c.Status,
                totalAmount = c.Items.Sum(i => i.Price * i.Quantity)
            })
        });
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id, CancellationToken cancellationToken)
    {
        var site = await _context.Sites
            .Where(s => s.Id == id)
            .Select(s => new SiteDto
            {
                Id = s.Id,
                NameEn = s.NameEn,
                NameAr = s.NameAr,
                DescriptionEn = s.DescriptionEn,
                DescriptionAr = s.DescriptionAr,
                LocationEn = s.LocationEn,
                LocationAr = s.LocationAr,
                CreatedAt = s.CreatedAt,
                UpdatedAt = s.UpdatedAt
            })
            .FirstOrDefaultAsync(cancellationToken);

        if (site == null) return NotFound();

        return Ok(site);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateSiteDto createSiteDto, CancellationToken cancellationToken)
    {
        var validationResult = await _createValidator.ValidateAsync(createSiteDto, cancellationToken);
        if (!validationResult.IsValid) return BadRequest(validationResult.Errors);

        var site = new Site
        {
            Id = Guid.NewGuid(),
            NameEn = createSiteDto.NameEn,
            NameAr = createSiteDto.NameAr,
            DescriptionEn = createSiteDto.DescriptionEn,
            DescriptionAr = createSiteDto.DescriptionAr,
            LocationEn = createSiteDto.LocationEn,
            LocationAr = createSiteDto.LocationAr,
            CreatedAt = DateTime.UtcNow
        };

        _context.Sites.Add(site);
        await _context.SaveChangesAsync(cancellationToken);

        var dto = new SiteDto
        {
            Id = site.Id,
            NameEn = site.NameEn,
            NameAr = site.NameAr,
            DescriptionEn = site.DescriptionEn,
            DescriptionAr = site.DescriptionAr,
            LocationEn = site.LocationEn,
            LocationAr = site.LocationAr,
            CreatedAt = site.CreatedAt
        };

        return CreatedAtAction(nameof(GetById), new { id = site.Id }, dto);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(Guid id, [FromBody] UpdateSiteDto updateSiteDto, CancellationToken cancellationToken)
    {
        var validationResult = await _updateValidator.ValidateAsync(updateSiteDto, cancellationToken);
        if (!validationResult.IsValid) return BadRequest(validationResult.Errors);

        var site = await _context.Sites.FirstOrDefaultAsync(s => s.Id == id, cancellationToken);
        if (site == null) return NotFound();

        site.NameEn = updateSiteDto.NameEn;
        site.NameAr = updateSiteDto.NameAr;
        site.DescriptionEn = updateSiteDto.DescriptionEn;
        site.DescriptionAr = updateSiteDto.DescriptionAr;
        site.LocationEn = updateSiteDto.LocationEn;
        site.LocationAr = updateSiteDto.LocationAr;
        site.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return NoContent();
    }

    [HttpPut("{id:guid}/location")]
    public async Task<IActionResult> UpdateLocation(Guid id, [FromBody] UpdateSiteLocationDto request, CancellationToken cancellationToken)
    {
        var validationResult = await _updateLocationValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid) return BadRequest(validationResult.Errors);

        var site = await _context.Sites.FirstOrDefaultAsync(s => s.Id == id, cancellationToken);
        if (site == null) return NotFound();

        site.LocationEn = request.LocationEn;
        site.LocationAr = request.LocationAr;
        site.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync(cancellationToken);
        return NoContent();
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id, CancellationToken cancellationToken)
    {
        var site = await _context.Sites.FirstOrDefaultAsync(s => s.Id == id, cancellationToken);
        if (site == null) return NotFound();

        _context.Sites.Remove(site);
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}
