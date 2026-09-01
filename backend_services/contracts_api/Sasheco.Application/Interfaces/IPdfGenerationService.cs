namespace Sasheco.Application.Interfaces;

public interface IPdfGenerationService
{
    byte[] GeneratePdf(string content, string title = "Document");
}
