namespace Sasheco.Contract.Application.Interfaces;

public interface ILocalStorageService
{
    Task<string> SaveFileAsync(Stream fileStream, string fileName, string folderName);
}
