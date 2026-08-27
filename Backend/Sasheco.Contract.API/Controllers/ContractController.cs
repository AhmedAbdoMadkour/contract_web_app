using Microsoft.AspNetCore.Mvc;
using Sasheco.Contract.Application.Interfaces;
using Sasheco.Contract.Domain.Entities;

namespace Sasheco.Contract.API.Controllers;

[ApiController]
[Route("api/contracts")]
public class ContractController : ControllerBase
{
    private readonly IContractItemService _itemService;
    private readonly IProjectDrawingService _drawingService;

    public ContractController(IContractItemService itemService, IProjectDrawingService drawingService)
    {
        _itemService = itemService;
        _drawingService = drawingService;
    }

    [HttpPost("{id}/items")]
    public async Task<IActionResult> AddItem(Guid id, [FromBody] ContractItemDto dto)
    {
        var item = new ContractItem
        {
            Description = dto.Description,
            Quantity = dto.Quantity,
            UnitPrice = dto.UnitPrice
        };

        var result = await _itemService.AddItemAsync(id, item);
        return Ok(result);
    }

    [HttpPost("{id}/items/bulk")]
    public async Task<IActionResult> AddItemsBulk(Guid id, IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest("File is empty or null.");

        using var stream = file.OpenReadStream();
        var result = await _itemService.AddItemsBulkAsync(id, stream, file.FileName);
        
        return Ok(result);
    }

    [HttpPost("{id}/drawings")]
    public async Task<IActionResult> UploadDrawing(Guid id, IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest("File is empty or null.");

        using var stream = file.OpenReadStream();
        var result = await _drawingService.UploadDrawingAsync(id, stream, file.FileName);

        return Ok(result);
    }
}

public class ContractItemDto
{
    public string Description { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}
