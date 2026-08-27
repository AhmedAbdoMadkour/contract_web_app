using System;

namespace Sasheco.Domain.Entities;

public class TemplateItem
{
    public Guid Id { get; set; }
    public Guid ContractTemplateId { get; set; }
    public string Type { get; set; } = string.Empty; // Preamble, Legal Condition, Clause
    public string Name { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;

    public ContractTemplate Template { get; set; } = null!;
}
