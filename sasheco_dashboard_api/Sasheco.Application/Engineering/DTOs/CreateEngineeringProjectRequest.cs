namespace Sasheco.Application.Engineering.DTOs;

public class CreateEngineeringProjectRequest
{
    public string NameEn { get; set; } = string.Empty;
    public string NameAr { get; set; } = string.Empty;
    public string DescriptionEn { get; set; } = string.Empty;
    public string DescriptionAr { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
}
