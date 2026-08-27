using Sasheco.Contract.Application.Interfaces;

namespace Sasheco.Contract.Infrastructure.Services;

public class LocalStorageService : ILocalStorageService
{
    private readonly string _basePath;

    public LocalStorageService()
    {
        // Store files in a local directory named "uploads" in the API's working directory
        _basePath = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
        if (!Directory.Exists(_basePath))
        {
            Directory.CreateDirectory(_basePath);
        }
    }

    public async Task<string> SaveFileAsync(Stream fileStream, string fileName, string folderName)
    {
        var folderPath = Path.Combine(_basePath, folderName);
        if (!Directory.Exists(folderPath))
        {
            Directory.CreateDirectory(folderPath);
        }

        var uniqueFileName = $"{Guid.NewGuid()}_{Path.GetFileName(fileName)}";
        var filePath = Path.Combine(folderPath, uniqueFileName);

        using (var fileStreamOutput = new FileStream(filePath, FileMode.Create))
        {
            await fileStream.CopyToAsync(fileStreamOutput);
        }

        // Return a relative URL path (assuming serving static files from "uploads")
        return $"/uploads/{folderName}/{uniqueFileName}";
    }
}
