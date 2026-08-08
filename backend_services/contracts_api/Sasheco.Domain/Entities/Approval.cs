namespace Sasheco.Domain.Entities;

public class Approval
{
    public Guid Id { get; set; }
    public string TitleEn { get; set; } = string.Empty;
    public string TitleAr { get; set; } = string.Empty;
    public string DescriptionEn { get; set; } = string.Empty;
    public string DescriptionAr { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string RequestedBy { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    // Navigation Properties
    public ICollection<ApprovalHistory> History { get; set; } = new List<ApprovalHistory>();
    public ICollection<ApprovalAttachment> Attachments { get; set; } = new List<ApprovalAttachment>();
}
