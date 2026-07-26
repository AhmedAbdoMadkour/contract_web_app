namespace Sasheco.Application.Finance.DTOs
{
    public class TransactionDTO
    {
        public Guid Id { get; set; }
        public string Description { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }
        public string Type { get; set; } = string.Empty; // "Income" or "Expense"
    }
}
