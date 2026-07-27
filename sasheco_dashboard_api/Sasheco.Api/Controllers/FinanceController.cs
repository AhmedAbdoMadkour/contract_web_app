using MediatR;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Application.Features.Finance;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FinanceController : ControllerBase
{
    private readonly IMediator _mediator;

    public FinanceController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpPost("pay")]
    public async Task<IActionResult> ProcessPayment([FromBody] ProcessPaymentCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(new { message = result });
    }

    [HttpGet("report")]
    public IActionResult GetReport()
    {
        return Ok(new
        {
            totalRevenue = 2500000.00,
            totalExpenses = 1500000.00,
            netIncome = 1000000.00,
            currency = "USD",
            reportDate = DateTime.UtcNow
        });
    }

    [HttpGet("transactions")]
    public IActionResult GetTransactions()
    {
        return Ok(new[]
        {
            new { id = "TXN-001", description = "Advance Payment", amount = 250000.00, date = DateTime.UtcNow.AddDays(-10), type = "Income" },
            new { id = "TXN-002", description = "Material Purchase", amount = -50000.00, date = DateTime.UtcNow.AddDays(-5), type = "Expense" }
        });
    }
}
