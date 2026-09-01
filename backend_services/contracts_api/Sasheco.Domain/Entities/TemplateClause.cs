namespace Sasheco.Domain.Entities;

public class TemplateClause
{
    public Guid Id { get; set; }
    
    public Guid DocumentTemplateId { get; set; }
    public DocumentTemplate? DocumentTemplate { get; set; }
    
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty; // Supports {Placeholders}
    
    public int OrderIndex { get; set; }
}
