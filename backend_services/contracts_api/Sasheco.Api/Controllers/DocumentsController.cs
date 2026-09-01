using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Features.Documents;
using Sasheco.Application.Interfaces;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using System.Text;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/")]
public class DocumentsController : ControllerBase
{
    private readonly IMediator _mediator;
    private readonly SashecoDbContext _context;
    private readonly IVariableBindingService _variableBindingService;
    private readonly IPdfGenerationService _pdfGenerationService;

    public DocumentsController(
        IMediator mediator,
        SashecoDbContext context,
        IVariableBindingService variableBindingService,
        IPdfGenerationService pdfGenerationService)
    {
        _mediator = mediator;
        _context = context;
        _variableBindingService = variableBindingService;
        _pdfGenerationService = pdfGenerationService;
    }

    [HttpPost("documents")]
    public async Task<IActionResult> UploadDocument([FromBody] UploadDocumentCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(result);
    }

    [HttpGet("templates")]
    public async Task<IActionResult> GetTemplates()
    {
        var templates = await _context.DocumentTemplates
            .Include(t => t.Clauses)
            .OrderBy(t => t.Name)
            .ToListAsync();
        return Ok(templates);
    }

    [HttpGet("templates/{id}")]
    public async Task<IActionResult> GetTemplate(Guid id)
    {
        var template = await _context.DocumentTemplates
            .Include(t => t.Clauses)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (template == null) return NotFound();

        return Ok(template);
    }

    [HttpPost("documents/preview")]
    public async Task<IActionResult> PreviewDocument([FromBody] DocumentGenerationRequest request)
    {
        var template = await _context.DocumentTemplates
            .Include(t => t.Clauses)
            .FirstOrDefaultAsync(t => t.Id == request.TemplateId);

        if (template == null) return NotFound("Template not found.");

        var contract = await _context.Contracts
            .Include(c => c.Project)
            .Include(c => c.Vendor)
            .Include(c => c.Items)
            .FirstOrDefaultAsync(c => c.Id == request.ContractId);

        if (contract == null) return NotFound("Contract not found.");

        var sb = new StringBuilder();
        foreach (var clause in template.Clauses.OrderBy(c => c.OrderIndex))
        {
            var boundContent = _variableBindingService.BindVariables(clause.Content, new { Contract = contract, Project = contract.Project, Vendor = contract.Vendor });
            sb.AppendLine(clause.Title);
            sb.AppendLine(boundContent);
            sb.AppendLine();
        }

        return Ok(new { PreviewText = sb.ToString() });
    }

    [HttpPost("documents/generate-pdf")]
    public async Task<IActionResult> GeneratePdf([FromBody] DocumentGenerationRequest request)
    {
        var template = await _context.DocumentTemplates
            .Include(t => t.Clauses)
            .FirstOrDefaultAsync(t => t.Id == request.TemplateId);

        if (template == null) return NotFound("Template not found.");

        var contract = await _context.Contracts
            .Include(c => c.Project)
            .Include(c => c.Vendor)
            .Include(c => c.Items)
            .FirstOrDefaultAsync(c => c.Id == request.ContractId);

        if (contract == null) return NotFound("Contract not found.");

        var sb = new StringBuilder();
        foreach (var clause in template.Clauses.OrderBy(c => c.OrderIndex))
        {
            var boundContent = _variableBindingService.BindVariables(clause.Content, new { Contract = contract, Project = contract.Project, Vendor = contract.Vendor });
            sb.AppendLine(clause.Title);
            sb.AppendLine(boundContent);
            sb.AppendLine();
        }

        var pdfBytes = _pdfGenerationService.GeneratePdf(sb.ToString(), template.Name);
        return File(pdfBytes, "application/pdf", $"{template.Name}.pdf");
    }
}

public class DocumentGenerationRequest
{
    public Guid TemplateId { get; set; }
    public Guid ContractId { get; set; }
}
