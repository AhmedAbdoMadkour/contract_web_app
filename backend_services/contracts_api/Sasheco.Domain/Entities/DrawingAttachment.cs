namespace Sasheco.Domain.Entities;

public class DrawingAttachment
{
    public Guid Id { get; set; }
    public Guid ContractId { get; set; }
    public Contract? Contract { get; set; }

    public string FileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public DateTimeOffset UploadedAt { get; set; }
}
