using Microsoft.EntityFrameworkCore;
using Sasheco.Domain.Entities;

namespace Sasheco.Infrastructure.Data;

public class SashecoDbContext : DbContext
{
    public SashecoDbContext(DbContextOptions<SashecoDbContext> options) : base(options) { }

    public DbSet<User> Users { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<Permission> Permissions { get; set; }
    public DbSet<RolePermission> RolePermissions { get; set; }
    public DbSet<Vendor> Vendors { get; set; }
    public DbSet<Project> Projects { get; set; }
    public DbSet<Contract> Contracts { get; set; }
    public DbSet<ContractItem> ContractItems { get; set; }
    public DbSet<DrawingAttachment> DrawingAttachments { get; set; }
    public DbSet<Approval> Approvals { get; set; }
    public DbSet<FinanceTransaction> FinanceTransactions { get; set; }
    public DbSet<FinanceMilestone> FinanceMilestones { get; set; }
    public DbSet<EngineeringProject> EngineeringProjects { get; set; }
    public DbSet<SecretaryTask> SecretaryTasks { get; set; }
    public DbSet<SecretaryInboxItem> SecretaryInboxItems { get; set; }
    public DbSet<SecretaryDocument> SecretaryDocuments { get; set; }
    public DbSet<Site> Sites { get; set; }
    public DbSet<Translation> Translations { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.Entity<RolePermission>()
            .HasKey(rp => new { rp.RoleId, rp.PermissionId });
            
        modelBuilder.Entity<RolePermission>()
            .HasOne(rp => rp.Role)
            .WithMany(r => r.RolePermissions)
            .HasForeignKey(rp => rp.RoleId);
            
        modelBuilder.Entity<RolePermission>()
            .HasOne(rp => rp.Permission)
            .WithMany()
            .HasForeignKey(rp => rp.PermissionId);

        var adminRoleId = Guid.Parse("11111111-1111-1111-1111-111111111111");
        modelBuilder.Entity<Role>().HasData(new Role 
        { 
            Id = adminRoleId, 
            Name = "Admin" 
        });

        modelBuilder.Entity<User>().HasData(new User 
        { 
            Id = Guid.Parse("22222222-2222-2222-2222-222222222222"), 
            EmployeeNumber = "EMP001",
            Name = "admin", 
            FirstName = "System",
            LastName = "Admin",
            Email = "admin@sasheco.com",
            Position = "Administrator",
            PasswordHash = "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje", // Hash for "password"
            RoleId = adminRoleId,
            IsActive = true,
            CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
        });

        var permissions = new List<Permission>
        {
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333331"), Name = "ViewSites", Description = "View Sites" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333332"), Name = "ManageSites", Description = "Manage Sites" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333333"), Name = "ViewEngineering", Description = "View Engineering" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333334"), Name = "ManageEngineering", Description = "Manage Engineering" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333335"), Name = "ViewUsers", Description = "View Users" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333336"), Name = "ManageUsers", Description = "Manage Users" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333337"), Name = "ViewApprovals", Description = "View Approvals" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333338"), Name = "ManageApprovals", Description = "Manage Approvals" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333339"), Name = "ViewFinance", Description = "View Finance" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333340"), Name = "ManageFinance", Description = "Manage Finance" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333341"), Name = "ViewVendors", Description = "View Vendors" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333342"), Name = "ManageVendors", Description = "Manage Vendors" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333343"), Name = "ViewSecretary", Description = "View Secretary" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333344"), Name = "ManageSecretary", Description = "Manage Secretary" }
        };

        modelBuilder.Entity<Permission>().HasData(permissions);

        var rolePermissions = permissions.Select(p => new RolePermission
        {
            RoleId = adminRoleId,
            PermissionId = p.Id
        });

        modelBuilder.Entity<RolePermission>().HasData(rolePermissions);
    }
}
