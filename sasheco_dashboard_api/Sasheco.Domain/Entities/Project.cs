namespace Sasheco.Domain.Entities;

public class Project
{
    public Guid Id { get; set; }
    public string ProjectCode { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
    public string NameAr { get; set; } = string.Empty;

    public ICollection<Contract> Contracts { get; set; } = new List<Contract>();
}
