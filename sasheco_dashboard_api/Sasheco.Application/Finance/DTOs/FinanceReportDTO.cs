namespace Sasheco.Application.Finance.DTOs
{
    public class FinanceReportDTO
    {
        public decimal TotalRevenue { get; set; }
        public decimal TotalExpenses { get; set; }
        public decimal NetIncome { get; set; }
        public string Currency { get; set; } = "USD";
        public DateTime ReportDate { get; set; }
    }
}
