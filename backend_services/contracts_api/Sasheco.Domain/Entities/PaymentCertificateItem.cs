namespace Sasheco.Domain.Entities;

public class PaymentCertificateItem
{
    public Guid Id { get; set; }
    
    public Guid PaymentCertificateId { get; set; }
    public PaymentCertificate? PaymentCertificate { get; set; }
    
    public Guid ContractItemId { get; set; }
    public ContractItem? ContractItem { get; set; }
    
    public string Description { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice { get; set; }
}
