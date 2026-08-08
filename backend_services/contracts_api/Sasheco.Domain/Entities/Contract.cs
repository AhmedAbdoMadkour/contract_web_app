namespace Sasheco.Domain.Entities;

public enum ContractStatus
{
    Draft,
    Active,
    Completed,
    Terminated
}

public class Contract
{
    public Guid Id { get; set; }
    public Guid ProjectId { get; set; }
    public Project? Project { get; set; }
    
    public Guid VendorId { get; set; }
    public Vendor? Vendor { get; set; }
    
    public ContractStatus Status { get; set; }
    public string TermsAndConditions { get; set; } = string.Empty;

    public ICollection<ContractItem> Items { get; set; } = new List<ContractItem>();
    public ICollection<ContractTerm> Terms { get; set; } = new List<ContractTerm>();
    public ICollection<DrawingAttachment> DrawingAttachments { get; set; } = new List<DrawingAttachment>();
}
