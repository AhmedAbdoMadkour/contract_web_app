namespace Sasheco.Domain.Entities;

public class FinanceMilestone
{
    public Guid Id { get; set; }
    public Guid ProjectId { get; set; }
    public string Title { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public DateTime TargetDate { get; set; }
    public string Status { get; set; } = string.Empty; // Pending, Paid
}
