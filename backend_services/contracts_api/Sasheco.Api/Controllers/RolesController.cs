using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;

namespace Sasheco.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin")]
public class RolesController : ControllerBase
{
    private readonly SashecoDbContext _context;
    private readonly Sasheco.Api.Services.ILocaleProvider _localeProvider;

    public RolesController(SashecoDbContext context, Sasheco.Api.Services.ILocaleProvider localeProvider)
    {
        _context = context;
        _localeProvider = localeProvider;
    }

    [HttpGet]
    public async Task<IActionResult> GetRoles(CancellationToken cancellationToken)
    {
        var roles = await _context.Roles
            .Include(r => r.RolePermissions)
            .ThenInclude(rp => rp.Permission)
            .Select(r => new
            {
                Id = r.Id,
                Name = r.Name,
                Permissions = r.RolePermissions.Select(rp => new 
                {
                    Id = rp.PermissionId,
                    Name = _localeProvider.IsArabic ? rp.Permission!.NameAr : rp.Permission!.NameEn,
                    Description = _localeProvider.IsArabic ? rp.Permission!.DescriptionAr : rp.Permission!.DescriptionEn
                })
            })
            .ToListAsync(cancellationToken);

        return Ok(roles);
    }

    [HttpPut("{id:guid}/permissions")]
    public async Task<IActionResult> UpdateRolePermissions(Guid id, [FromBody] List<Guid> permissionIds, CancellationToken cancellationToken)
    {
        var role = await _context.Roles
            .Include(r => r.RolePermissions)
            .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);

        if (role == null) return NotFound("Role not found");

        // Remove existing permissions
        _context.RolePermissions.RemoveRange(role.RolePermissions);

        // Add new permissions
        var newRolePermissions = permissionIds.Select(pid => new RolePermission
        {
            RoleId = id,
            PermissionId = pid
        });

        _context.RolePermissions.AddRange(newRolePermissions);
        await _context.SaveChangesAsync(cancellationToken);

        return NoContent();
    }
}
