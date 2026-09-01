using Sasheco.Domain.Enums;

namespace Sasheco.Domain.Entities;

public class PaymentCertificateApproval
{
    public Guid Id { get; set; }
    
    public Guid PaymentCertificateId { get; set; }
    public PaymentCertificate? PaymentCertificate { get; set; }
    
    public Guid ApproverId { get; set; }
    public User? Approver { get; set; }
    
    public ApprovalRole Role { get; set; }
    public bool? IsApproved { get; set; }
    public string Comments { get; set; } = string.Empty;
    public DateTime ApprovalDate { get; set; } = DateTime.UtcNow;
}
