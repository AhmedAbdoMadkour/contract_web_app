using Sasheco.Contract.Domain.Entities;

namespace Sasheco.Contract.Domain.Interfaces;

public interface IProjectDrawingRepository
{
    Task<ProjectDrawing> AddAsync(ProjectDrawing drawing);
}
