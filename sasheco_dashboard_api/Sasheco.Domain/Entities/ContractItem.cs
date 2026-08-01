namespace Sasheco.Domain.Entities;

public class ContractItem
{
    public Guid Id { get; set; }
    public Guid ContractId { get; set; }
    public Contract? Contract { get; set; }

    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public string DescriptionEn { get; set; } = string.Empty;
    public string DescriptionAr { get; set; } = string.Empty;
}
