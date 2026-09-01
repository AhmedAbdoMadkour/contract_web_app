namespace Sasheco.Domain.Entities;

public class DocumentTemplate
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty; // e.g., "Contract", "Letter"
    
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    public ICollection<TemplateClause> Clauses { get; set; } = new List<TemplateClause>();
}
