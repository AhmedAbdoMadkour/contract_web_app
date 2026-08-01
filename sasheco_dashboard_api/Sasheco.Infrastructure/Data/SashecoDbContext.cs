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
    public DbSet<ApprovalHistory> ApprovalHistories { get; set; }
    public DbSet<ApprovalAttachment> ApprovalAttachments { get; set; }
    public DbSet<FinanceTransaction> FinanceTransactions { get; set; }
    public DbSet<FinanceMilestone> FinanceMilestones { get; set; }
    public DbSet<SecretaryTask> SecretaryTasks { get; set; }
    public DbSet<SecretaryInboxItem> SecretaryInboxItems { get; set; }
    public DbSet<SecretaryDocument> SecretaryDocuments { get; set; }
    public DbSet<Site> Sites { get; set; }

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

        modelBuilder.Entity<ApprovalHistory>()
            .HasOne(ah => ah.Approval)
            .WithMany(a => a.History)
            .HasForeignKey(ah => ah.ApprovalId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<ApprovalAttachment>()
            .HasOne(aa => aa.Approval)
            .WithMany(a => a.Attachments)
            .HasForeignKey(aa => aa.ApprovalId)
            .OnDelete(DeleteBehavior.Cascade);

        modelBuilder.Entity<ContractItem>()
            .Property(ci => ci.Price)
            .HasPrecision(18, 2);

        modelBuilder.Entity<FinanceTransaction>()
            .Property(ft => ft.Amount)
            .HasPrecision(18, 2);

        modelBuilder.Entity<FinanceMilestone>()
            .Property(fm => fm.Amount)
            .HasPrecision(18, 2);

        var adminRoleId = Guid.Parse("11111111-1111-1111-1111-111111111111");
        var projectManagerRoleId = Guid.Parse("11111111-1111-1111-1111-111111111112");
        var financeRoleId = Guid.Parse("11111111-1111-1111-1111-111111111113");
        var auditorRoleId = Guid.Parse("11111111-1111-1111-1111-111111111114");

        modelBuilder.Entity<Role>().HasData(
            new Role { Id = adminRoleId, Name = "Admin" },
            new Role { Id = projectManagerRoleId, Name = "ProjectManager" },
            new Role { Id = financeRoleId, Name = "FinancialAnalyst" },
            new Role { Id = auditorRoleId, Name = "Auditor" }
        );

        modelBuilder.Entity<User>().HasData(new User 
        { 
            Id = Guid.Parse("22222222-2222-2222-2222-222222222222"), 
            EmployeeNumber = "EMP001",
            Name = "admin", 
            FirstName = "System",
            LastName = "Admin",
            Email = "admin@sasheco.com",
            PositionEn = "Administrator",
            PositionAr = "مسؤول",
            PasswordHash = "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje", // Hash for "password"
            RoleId = adminRoleId,
            IsActive = true,
            CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
        },
        new User 
        { 
            Id = Guid.Parse("22222222-2222-2222-2222-222222222223"), 
            EmployeeNumber = "ENG001",
            Name = "engineer", 
            FirstName = "Project",
            LastName = "Engineer",
            Email = "engineer@sasheco.com",
            PositionEn = "Project Manager",
            PositionAr = "مدير مشروع",
            PasswordHash = "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje", // Hash for "password"
            RoleId = projectManagerRoleId,
            IsActive = true,
            CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
        },
        new User 
        { 
            Id = Guid.Parse("22222222-2222-2222-2222-222222222224"), 
            EmployeeNumber = "FIN001",
            Name = "finance", 
            FirstName = "Financial",
            LastName = "Analyst",
            Email = "finance@sasheco.com",
            PositionEn = "Financial Analyst",
            PositionAr = "محلل مالي",
            PasswordHash = "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje", // Hash for "password"
            RoleId = financeRoleId,
            IsActive = true,
            CreatedAt = new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc)
        });

        var permissions = new List<Permission>
        {
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333331"), NameEn = "ViewSites", NameAr = "عرض المواقع", DescriptionEn = "View Sites", DescriptionAr = "عرض المواقع" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333332"), NameEn = "ManageSites", NameAr = "إدارة المواقع", DescriptionEn = "Manage Sites", DescriptionAr = "إدارة المواقع" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333333"), NameEn = "ViewEngineering", NameAr = "عرض الهندسة", DescriptionEn = "View Engineering", DescriptionAr = "عرض الهندسة" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333334"), NameEn = "ManageEngineering", NameAr = "إدارة الهندسة", DescriptionEn = "Manage Engineering", DescriptionAr = "إدارة الهندسة" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333335"), NameEn = "ViewUsers", NameAr = "عرض المستخدمين", DescriptionEn = "View Users", DescriptionAr = "عرض المستخدمين" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333336"), NameEn = "ManageUsers", NameAr = "إدارة المستخدمين", DescriptionEn = "Manage Users", DescriptionAr = "إدارة المستخدمين" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333337"), NameEn = "ViewApprovals", NameAr = "عرض الموافقات", DescriptionEn = "View Approvals", DescriptionAr = "عرض الموافقات" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333338"), NameEn = "ManageApprovals", NameAr = "إدارة الموافقات", DescriptionEn = "Manage Approvals", DescriptionAr = "إدارة الموافقات" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333339"), NameEn = "ViewFinance", NameAr = "عرض المالية", DescriptionEn = "View Finance", DescriptionAr = "عرض المالية" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333340"), NameEn = "ManageFinance", NameAr = "إدارة المالية", DescriptionEn = "Manage Finance", DescriptionAr = "إدارة المالية" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333341"), NameEn = "ViewVendors", NameAr = "عرض الموردين", DescriptionEn = "View Vendors", DescriptionAr = "عرض الموردين" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333342"), NameEn = "ManageVendors", NameAr = "إدارة الموردين", DescriptionEn = "Manage Vendors", DescriptionAr = "إدارة الموردين" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333343"), NameEn = "ViewSecretary", NameAr = "عرض السكرتارية", DescriptionEn = "View Secretary", DescriptionAr = "عرض السكرتارية" },
            new Permission { Id = Guid.Parse("33333333-3333-3333-3333-333333333344"), NameEn = "ManageSecretary", NameAr = "إدارة السكرتارية", DescriptionEn = "Manage Secretary", DescriptionAr = "إدارة السكرتارية" }
        };

        modelBuilder.Entity<Permission>().HasData(permissions);

        // Admin gets all permissions
        var adminRolePermissions = permissions.Select(p => new RolePermission
        {
            RoleId = adminRoleId,
            PermissionId = p.Id
        }).ToList();

        // Project Manager gets Engineering and Sites
        var pmPermissions = permissions.Where(p => p.NameEn.Contains("Engineering") || p.NameEn.Contains("Sites") || p.NameEn.Contains("Vendor") || p.NameEn.Contains("Approval"))
            .Select(p => new RolePermission
            {
                RoleId = projectManagerRoleId,
                PermissionId = p.Id
            }).ToList();

        // Finance gets Finance
        var financePermissions = permissions.Where(p => p.NameEn.Contains("Finance") || p.NameEn.Contains("Vendor") || p.NameEn.Contains("Approval"))
            .Select(p => new RolePermission
            {
                RoleId = financeRoleId,
                PermissionId = p.Id
            }).ToList();

        // Auditor gets View-only access everywhere
        var auditorPermissions = permissions.Where(p => p.NameEn.StartsWith("View"))
            .Select(p => new RolePermission
            {
                RoleId = auditorRoleId,
                PermissionId = p.Id
            }).ToList();

        var allRolePermissions = new List<RolePermission>();
        allRolePermissions.AddRange(adminRolePermissions);
        allRolePermissions.AddRange(pmPermissions);
        allRolePermissions.AddRange(financePermissions);
        allRolePermissions.AddRange(auditorPermissions);

        modelBuilder.Entity<RolePermission>().HasData(allRolePermissions);
    }
}
