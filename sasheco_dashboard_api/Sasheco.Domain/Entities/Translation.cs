using System;

namespace Sasheco.Domain.Entities;

public class Translation
{
    public int Id { get; set; }
    public string EntityType { get; set; } = string.Empty;
    public string EntityId { get; set; } = string.Empty;
    public string Locale { get; set; } = string.Empty;
    public string FieldName { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
}
