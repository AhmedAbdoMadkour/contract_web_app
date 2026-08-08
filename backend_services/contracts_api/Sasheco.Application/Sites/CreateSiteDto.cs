using System.ComponentModel.DataAnnotations;

namespace Sasheco.Application.Sites;

public class CreateSiteDto
{
    [Required]
    [MaxLength(100)]
    public string NameEn { get; set; } = string.Empty;
    public string NameAr { get; set; } = string.Empty;

    [MaxLength(500)]
    public string DescriptionEn { get; set; } = string.Empty;
    public string DescriptionAr { get; set; } = string.Empty;

    [MaxLength(200)]
    public string LocationEn { get; set; } = string.Empty;
    public string LocationAr { get; set; } = string.Empty;
}
