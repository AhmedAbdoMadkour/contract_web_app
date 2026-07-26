using MediatR;

namespace Sasheco.Application.Features.Dashboard;

public record DashboardDto(int TotalProjects, int PendingApprovals, int TotalVendors, List<string> RecentActivity);
public record GetDashboardSummaryQuery : IRequest<DashboardDto>;

public class GetDashboardSummaryHandler : IRequestHandler<GetDashboardSummaryQuery, DashboardDto>
{
    public Task<DashboardDto> Handle(GetDashboardSummaryQuery request, CancellationToken cancellationToken)
    {
        return Task.FromResult(new DashboardDto(42, 7, 15, new List<string> { "Project Alpha Approved", "Vendor Beta Added" }));
    }
}
