namespace Sasheco.Domain.Entities;

public class ApprovalHistory
{
    public Guid Id { get; set; }
    public Guid ApprovalId { get; set; }
    public Approval? Approval { get; set; }
    
    public Guid UserId { get; set; }
    public User? User { get; set; }

    public string ActionTaken { get; set; } = string.Empty; // e.g., "Created", "Approved", "Rejected", "RequestedInfo"
    public string Comments { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}
