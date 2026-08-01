namespace Sasheco.Domain.Entities;

public class Project
{
    public Guid Id { get; set; }
    public string ProjectCode { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
    public string NameAr { get; set; } = string.Empty;
    public string DescriptionEn { get; set; } = string.Empty;
    public string DescriptionAr { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }

    public ICollection<Contract> Contracts { get; set; } = new List<Contract>();
}
