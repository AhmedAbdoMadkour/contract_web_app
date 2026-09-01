using Sasheco.Domain.Enums;

namespace Sasheco.Domain.Entities;

public class PaymentCertificate
{
    public Guid Id { get; set; }
    
    public Guid ContractId { get; set; }
    public Contract? Contract { get; set; }
    
    public string ReferenceNumber { get; set; } = string.Empty;
    public DateTime IssueDate { get; set; } = DateTime.UtcNow;
    
    public string Description { get; set; } = string.Empty;
    public decimal TotalAmount { get; set; }
    
    public PaymentCertificateStatus Status { get; set; } = PaymentCertificateStatus.Draft;
    
    public string Notes { get; set; } = string.Empty;

    public ICollection<PaymentCertificateItem> Items { get; set; } = new List<PaymentCertificateItem>();
    public ICollection<PaymentCertificateApproval> Approvals { get; set; } = new List<PaymentCertificateApproval>();
}
