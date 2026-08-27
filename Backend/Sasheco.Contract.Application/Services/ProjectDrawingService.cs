using Sasheco.Contract.Application.Interfaces;
using Sasheco.Contract.Domain.Entities;
using Sasheco.Contract.Domain.Interfaces;

namespace Sasheco.Contract.Application.Services;

public class ProjectDrawingService : IProjectDrawingService
{
    private readonly IProjectDrawingRepository _repository;
    private readonly ILocalStorageService _storageService;

    public ProjectDrawingService(IProjectDrawingRepository repository, ILocalStorageService storageService)
    {
        _repository = repository;
        _storageService = storageService;
    }

    public async Task<ProjectDrawing> UploadDrawingAsync(Guid contractId, Stream fileStream, string fileName)
    {
        var fileUrl = await _storageService.SaveFileAsync(fileStream, fileName, "drawings");

        var drawing = new ProjectDrawing
        {
            ContractId = contractId,
            FileName = fileName,
            FileUrl = fileUrl,
            UploadDate = DateTime.UtcNow
        };

        return await _repository.AddAsync(drawing);
    }
}
