using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Engineering.DTOs;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using FluentValidation;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class EngineeringController : ControllerBase
{
    private readonly SashecoDbContext _context;
    private readonly IValidator<CreateEngineeringProjectRequest> _createValidator;
    private readonly IValidator<UpdateProjectStatusRequest> _updateStatusValidator;

    public EngineeringController(
        SashecoDbContext context,
        IValidator<CreateEngineeringProjectRequest> createValidator,
        IValidator<UpdateProjectStatusRequest> updateStatusValidator)
    {
        _context = context;
        _createValidator = createValidator;
        _updateStatusValidator = updateStatusValidator;
    }

    [HttpGet("projects")]
    public async Task<IActionResult> GetProjects(CancellationToken cancellationToken)
    {
        var projects = await _context.EngineeringProjects
            .Select(p => new EngineeringProjectDto
            {
                Id = p.Id,
                NameEn = p.NameEn,
                NameAr = p.NameAr,
                DescriptionEn = p.DescriptionEn,
                DescriptionAr = p.DescriptionAr,
                Status = p.Status,
                StartDate = p.StartDate
            })
            .ToListAsync(cancellationToken);

        return Ok(projects);
    }

    [HttpGet("projects/{id:guid}")]
    public async Task<IActionResult> GetProject(Guid id, CancellationToken cancellationToken)
    {
        var project = await _context.EngineeringProjects
            .Where(p => p.Id == id)
            .Select(p => new EngineeringProjectDto
            {
                Id = p.Id,
                NameEn = p.NameEn,
                NameAr = p.NameAr,
                DescriptionEn = p.DescriptionEn,
                DescriptionAr = p.DescriptionAr,
                Status = p.Status,
                StartDate = p.StartDate
            })
            .FirstOrDefaultAsync(cancellationToken);

        if (project == null) return NotFound();

        return Ok(project);
    }

    [HttpPost("projects")]
    public async Task<IActionResult> CreateProject([FromBody] CreateEngineeringProjectRequest request, CancellationToken cancellationToken)
    {
        var validationResult = await _createValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        var project = new EngineeringProject
        {
            Id = Guid.NewGuid(),
            NameEn = request.NameEn,
            NameAr = request.NameAr,
            DescriptionEn = request.DescriptionEn,
            DescriptionAr = request.DescriptionAr,
            Status = "Planned",
            StartDate = request.StartDate
        };

        _context.EngineeringProjects.Add(project);
        await _context.SaveChangesAsync(cancellationToken);

        var dto = new EngineeringProjectDto
        {
            Id = project.Id,
            NameEn = project.NameEn,
            NameAr = project.NameAr,
            DescriptionEn = project.DescriptionEn,
            DescriptionAr = project.DescriptionAr,
            Status = project.Status,
            StartDate = project.StartDate
        };

        return CreatedAtAction(nameof(GetProject), new { id = project.Id }, dto);
    }

    [HttpPut("projects/{id:guid}/status")]
    public async Task<IActionResult> UpdateStatus(Guid id, [FromBody] UpdateProjectStatusRequest request, CancellationToken cancellationToken)
    {
        var validationResult = await _updateStatusValidator.ValidateAsync(request, cancellationToken);
        if (!validationResult.IsValid)
        {
            return BadRequest(validationResult.Errors);
        }

        var project = await _context.EngineeringProjects
            .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);

        if (project == null) return NotFound();

        project.Status = request.Status;
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}
