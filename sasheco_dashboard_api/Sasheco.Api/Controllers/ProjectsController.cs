using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Interfaces;

namespace Sasheco.Api.Controllers;

public record CreateProjectRequest(string ProjectCode, string Name);

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProjectsController : ControllerBase
{
    private readonly IRepository<Project> _projectRepository;

    public ProjectsController(IRepository<Project> projectRepository)
    {
        _projectRepository = projectRepository;
    }

    [HttpGet]
    public async Task<IActionResult> GetProjects()
    {
        var projects = await _projectRepository.GetAllAsync();
        return Ok(projects);
    }

    [HttpPost]
    public async Task<IActionResult> CreateProject([FromBody] CreateProjectRequest request)
    {
        var project = new Project
        {
            Id = Guid.NewGuid(),
            ProjectCode = request.ProjectCode,
            NameEn = request.Name,
            NameAr = request.Name // Fallback for now
        };

        await _projectRepository.AddAsync(project);
        return CreatedAtAction(nameof(GetProjects), new { id = project.Id }, project);
    }
}
