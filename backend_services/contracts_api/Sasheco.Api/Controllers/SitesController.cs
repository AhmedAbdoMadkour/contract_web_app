using MediatR;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.Features.Sites;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SitesController : ControllerBase
{
    private readonly IMediator _mediator;

    public SitesController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet]
    public async Task<IActionResult> GetSites()
    {
        var result = await _mediator.Send(new GetSitesQuery());
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> CreateSite([FromBody] CreateSiteCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(new { message = result });
    }
}
