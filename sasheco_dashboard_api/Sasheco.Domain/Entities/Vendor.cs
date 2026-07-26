namespace Sasheco.Domain.Entities;

public class Vendor
{
    public Guid Id { get; set; }
    public string VendorCode { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
    public string NameAr { get; set; } = string.Empty;
    public string RegistrationNumber { get; set; } = string.Empty;
    public string TaxNumber { get; set; } = string.Empty;
    public string ContactPersonEn { get; set; } = string.Empty;
    public string ContactPersonAr { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    
    public ICollection<Contract> Contracts { get; set; } = new List<Contract>();
}
