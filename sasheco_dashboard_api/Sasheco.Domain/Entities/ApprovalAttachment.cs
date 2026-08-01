namespace Sasheco.Domain.Entities;

public class ApprovalAttachment
{
    public Guid Id { get; set; }
    public Guid ApprovalId { get; set; }
    public Approval? Approval { get; set; }

    public string FileName { get; set; } = string.Empty;
    public string FilePath { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
}
