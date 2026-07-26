namespace Sasheco.Application.Finance.DTOs;

public class FinanceMilestoneDto
{
    public Guid Id { get; set; }
    public Guid ProjectId { get; set; }
    public string Title { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public DateTime TargetDate { get; set; }
    public string Status { get; set; } = string.Empty;
}
