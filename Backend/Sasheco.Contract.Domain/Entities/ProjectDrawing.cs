namespace Sasheco.Contract.Domain.Entities;

public class ProjectDrawing
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string FileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public DateTime UploadDate { get; set; } = DateTime.UtcNow;
    public Guid ContractId { get; set; }
}
