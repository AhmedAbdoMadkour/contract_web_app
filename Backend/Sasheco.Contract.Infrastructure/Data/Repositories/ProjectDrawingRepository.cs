using Sasheco.Contract.Domain.Entities;
using Sasheco.Contract.Domain.Interfaces;

namespace Sasheco.Contract.Infrastructure.Data.Repositories;

public class ProjectDrawingRepository : IProjectDrawingRepository
{
    private readonly ApplicationDbContext _context;

    public ProjectDrawingRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<ProjectDrawing> AddAsync(ProjectDrawing drawing)
    {
        _context.ProjectDrawings.Add(drawing);
        await _context.SaveChangesAsync();
        return drawing;
    }
}
