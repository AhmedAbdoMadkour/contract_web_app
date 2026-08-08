using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

public record ChartPointDto(string Label, double Value);
public record DashboardDto(
    int TotalUsers,
    int PendingApprovals,
    double Revenue,
    int ActiveProjects,
    List<ChartPointDto> UserGrowthChart,
    List<ChartPointDto> RevenueChart
);

[ApiController]
[Route("api/[controller]")]
public class DashboardController : ControllerBase
{
    private readonly SashecoDbContext _context;

    public DashboardController(SashecoDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetDashboard(CancellationToken cancellationToken)
    {
        var totalUsers = await _context.Users.CountAsync(cancellationToken);
        
        var pendingApprovals = await _context.Approvals
            .Where(a => a.Status == "Pending")
            .CountAsync(cancellationToken);

        var revenue = await _context.FinanceTransactions
            .Where(t => t.Type == "Income")
            .SumAsync(t => t.Amount, cancellationToken);

        var activeProjects = await _context.Projects
            .Where(p => p.Status == "Active")
            .CountAsync(cancellationToken);
        
        var userGrowth = new List<ChartPointDto>
        {
            new ChartPointDto("Day 1", 10),
            new ChartPointDto("Day 2", 20),
            new ChartPointDto("Day 3", 15),
            new ChartPointDto("Day 4", 30),
            new ChartPointDto("Day 5", 40),
            new ChartPointDto("Day 6", 35)
        };

        var revenueChart = new List<ChartPointDto>
        {
            new ChartPointDto("Q1", 8),
            new ChartPointDto("Q2", 10),
            new ChartPointDto("Q3", 14),
            new ChartPointDto("Q4", 12)
        };

        var dto = new DashboardDto(
            totalUsers,
            pendingApprovals,
            (double)revenue,
            activeProjects,
            userGrowth,
            revenueChart
        );

        return Ok(dto);
    }
}
