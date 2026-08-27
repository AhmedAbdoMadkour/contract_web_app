namespace Sasheco.Domain.Entities;

public class ContractItem
{
    public Guid Id { get; set; }
    public Guid ContractId { get; set; }
    public Contract? Contract { get; set; }

    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public string ItemCode { get; set; } = string.Empty;
    public string ItemName { get; set; } = string.Empty;

    public decimal Total => Quantity * Price;
}
