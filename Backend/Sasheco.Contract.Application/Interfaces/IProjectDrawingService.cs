using Sasheco.Contract.Domain.Entities;

namespace Sasheco.Contract.Application.Interfaces;

public interface IProjectDrawingService
{
    Task<ProjectDrawing> UploadDrawingAsync(Guid contractId, Stream fileStream, string fileName);
}
