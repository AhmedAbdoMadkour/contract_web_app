using System;
using System.Collections.Generic;

namespace Sasheco.Domain.Entities;

public class ContractTemplate
{
    public Guid Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Status { get; set; } = "Draft"; // Draft, Active
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<TemplateItem> Items { get; set; } = new List<TemplateItem>();
}
