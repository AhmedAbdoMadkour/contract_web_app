using MediatR;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.Features.Documents;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DocumentsController : ControllerBase
{
    private readonly IMediator _mediator;

    public DocumentsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpPost]
    public async Task<IActionResult> UploadDocument([FromBody] UploadDocumentCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(result);
    }
}
