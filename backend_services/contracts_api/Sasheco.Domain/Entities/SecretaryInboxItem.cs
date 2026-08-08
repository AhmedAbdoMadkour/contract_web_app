namespace Sasheco.Domain.Entities;

public class SecretaryInboxItem
{
    public Guid Id { get; set; }
    public string Sender { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public bool IsRead { get; set; }
    public DateTime ReceivedAt { get; set; }
}
