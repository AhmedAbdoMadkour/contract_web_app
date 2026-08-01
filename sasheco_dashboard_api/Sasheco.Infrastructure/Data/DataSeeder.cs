using Sasheco.Domain.Entities;
using Sasheco.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Sasheco.Infrastructure.Data;

public static class DataSeeder
{
    public static async Task SeedAsync(IServiceProvider serviceProvider)
    {
        using var scope = serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<SashecoDbContext>();
        
        await context.Database.MigrateAsync();

        if (!await context.Sites.AnyAsync())
        {
            var site1 = new Site { Id = Guid.NewGuid(), NameEn = "Downtown Complex", LocationEn = "City Center", CreatedAt = DateTime.UtcNow };
            var site2 = new Site { Id = Guid.NewGuid(), NameEn = "Northside Highway", LocationEn = "North District", CreatedAt = DateTime.UtcNow };
            context.Sites.AddRange(site1, site2);
            await context.SaveChangesAsync();
        }

        if (!await context.Vendors.AnyAsync())
        {
            context.Vendors.AddRange(
                new Vendor { Id = Guid.NewGuid(), NameEn = "Acme Construction Supplies", Status = "Active", Email = "contact@acme.com", CreatedAt = DateTime.UtcNow },
                new Vendor { Id = Guid.NewGuid(), NameEn = "Global Tech Logistics", Status = "Inactive", Email = "info@globaltech.com", CreatedAt = DateTime.UtcNow }
            );
            await context.SaveChangesAsync();
        }

        if (!context.Projects.Any())
        {
            context.Projects.AddRange(
                new Project { Id = Guid.NewGuid(), ProjectCode = "PRJ-2024-001", NameEn = "Office Building A", NameAr = "مبنى مكاتب أ", DescriptionEn = "Construction of new office building", DescriptionAr = "بناء مبنى مكاتب جديد", Status = "In Progress", StartDate = DateTime.UtcNow.AddDays(-30) },
                new Project { Id = Guid.NewGuid(), ProjectCode = "PRJ-2024-002", NameEn = "Residential Complex", NameAr = "مجمع سكني", DescriptionEn = "Phase 1 of residential complex", DescriptionAr = "المرحلة الأولى من المجمع السكني", Status = "Planning", StartDate = DateTime.UtcNow.AddDays(15) },
                new Project { Id = Guid.NewGuid(), ProjectCode = "PRJ-2024-003", NameEn = "Highway Maintenance", NameAr = "صيانة الطريق السريع", DescriptionEn = "Annual highway maintenance contract", DescriptionAr = "عقد صيانة الطريق السريع السنوي", Status = "Completed", StartDate = DateTime.UtcNow.AddMonths(-6) }
            );
            await context.SaveChangesAsync();
        }

        if (!await context.Approvals.AnyAsync())
        {
            context.Approvals.AddRange(
                new Approval { Id = Guid.NewGuid(), TitleEn = "Bridge Budget Approval", TitleAr = "موافقة ميزانية الجسر", Status = "Pending", CreatedAt = DateTime.UtcNow },
                new Approval { Id = Guid.NewGuid(), TitleEn = "Tower Blueprint Review", TitleAr = "مراجعة مخطط البرج", Status = "Pending", CreatedAt = DateTime.UtcNow.AddDays(-1) },
                new Approval { Id = Guid.NewGuid(), TitleEn = "Site Safety Audit", TitleAr = "تدقيق سلامة الموقع", Status = "Approved", CreatedAt = DateTime.UtcNow.AddDays(-5) }
            );
            await context.SaveChangesAsync();
        }

        if (!await context.FinanceTransactions.AnyAsync())
        {
            context.FinanceTransactions.AddRange(
                new FinanceTransaction { Id = Guid.NewGuid(), Description = "Q1 Funding Allocation", Amount = 1250000.00m, Type = "Income", Date = DateTime.UtcNow.AddDays(-20) },
                new FinanceTransaction { Id = Guid.NewGuid(), Description = "Equipment Purchase", Amount = 45000.00m, Type = "Expense", Date = DateTime.UtcNow.AddDays(-5) },
                new FinanceTransaction { Id = Guid.NewGuid(), Description = "Subcontractor Payment", Amount = 15000.00m, Type = "Expense", Date = DateTime.UtcNow.AddDays(-2) }
            );
            await context.SaveChangesAsync();
        }
    }
}
