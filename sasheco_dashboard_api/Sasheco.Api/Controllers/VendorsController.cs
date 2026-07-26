using MediatR;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.Features.Vendors;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class VendorsController : ControllerBase
{
    private readonly IMediator _mediator;

    public VendorsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet]
    public async Task<IActionResult> GetVendors()
    {
        var result = await _mediator.Send(new GetVendorsQuery());
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> CreateVendor([FromBody] CreateVendorCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(new { message = result });
    }
}
