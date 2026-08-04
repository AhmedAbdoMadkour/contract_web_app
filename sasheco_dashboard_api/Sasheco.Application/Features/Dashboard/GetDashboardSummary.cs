using MediatR;

namespace Sasheco.Application.Features.Dashboard;

public record ChartPointDto(string Label, double Value);
public record DashboardDto(
    int TotalUsers,
    int PendingApprovals,
    double Revenue,
    int ActiveProjects,
    List<ChartPointDto> UserGrowthChart,
    List<ChartPointDto> RevenueChart
);

public record GetDashboardSummaryQuery : IRequest<DashboardDto>;

public class GetDashboardSummaryHandler : IRequestHandler<GetDashboardSummaryQuery, DashboardDto>
{
    public Task<DashboardDto> Handle(GetDashboardSummaryQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new DashboardDto(
            0, 0, 0, 0, new List<ChartPointDto>(), new List<ChartPointDto>()
        ));
    }
}
