using System;

namespace Sasheco.Application.Dashboard.DTOs
{
    public class DashboardMetricsResponse
    {
        public int TotalUsers { get; set; }
        public int PendingApprovals { get; set; }
        public decimal Revenue { get; set; }
        public int ActiveProjects { get; set; }
    }
}
