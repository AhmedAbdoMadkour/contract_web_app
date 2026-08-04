using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Application.Features.Finance;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FinanceController : ControllerBase
{
    private readonly IMediator _mediator;
    private readonly SashecoDbContext _context;

    public FinanceController(IMediator mediator, SashecoDbContext context)
    {
        _mediator = mediator;
        _context = context;
    }

    [HttpPost("pay")]
    public async Task<IActionResult> ProcessPayment([FromBody] ProcessPaymentCommand command)
    {
        var result = await _mediator.Send(command);
        return Ok(new { message = result });
    }

    [HttpGet("report")]
    public async Task<IActionResult> GetReport(CancellationToken cancellationToken)
    {
        var income = await _context.FinanceTransactions
            .Where(t => t.Type == "Income")
            .SumAsync(t => t.Amount, cancellationToken);
            
        var expenses = await _context.FinanceTransactions
            .Where(t => t.Type == "Expense")
            .SumAsync(t => t.Amount, cancellationToken);

        return Ok(new
        {
            totalRevenue = income,
            totalExpenses = expenses,
            netIncome = income - expenses,
            currency = "USD",
            reportDate = DateTime.UtcNow
        });
    }

    [HttpGet("transactions")]
    public async Task<IActionResult> GetTransactions(CancellationToken cancellationToken)
    {
        var transactions = await _context.FinanceTransactions
            .OrderByDescending(t => t.Date)
            .Take(50)
            .Select(t => new {
                id = t.Id.ToString(),
                description = t.Description,
                amount = t.Amount,
                date = t.Date,
                type = t.Type
            })
            .ToListAsync(cancellationToken);

        return Ok(transactions);
    }
}
