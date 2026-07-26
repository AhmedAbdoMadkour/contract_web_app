using MediatR;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.Features.Contracts;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ContractsController : ControllerBase
{
    private readonly IMediator _mediator;

    public ContractsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpPost("{id}/approve")]
    public async Task<IActionResult> ApproveContract(string id)
    {
        var result = await _mediator.Send(new ApproveContractCommand(id));
        return Ok(new { message = result });
    }

    [HttpPost("{id}/reject")]
    public async Task<IActionResult> RejectContract(string id)
    {
        var result = await _mediator.Send(new RejectContractCommand(id));
        return Ok(new { message = result });
    }
}
