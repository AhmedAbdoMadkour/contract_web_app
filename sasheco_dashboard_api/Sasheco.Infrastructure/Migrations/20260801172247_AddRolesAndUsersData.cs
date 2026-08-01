using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Sasheco.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddRolesAndUsersData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { new Guid("11111111-1111-1111-1111-111111111112"), "ProjectManager" },
                    { new Guid("11111111-1111-1111-1111-111111111113"), "FinancialAnalyst" },
                    { new Guid("11111111-1111-1111-1111-111111111114"), "Auditor" }
                });

            migrationBuilder.InsertData(
                table: "RolePermissions",
                columns: new[] { "PermissionId", "RoleId" },
                values: new object[,]
                {
                    { new Guid("33333333-3333-3333-3333-333333333331"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333332"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333333"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333334"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333337"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333338"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333341"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333342"), new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("33333333-3333-3333-3333-333333333337"), new Guid("11111111-1111-1111-1111-111111111113") },
                    { new Guid("33333333-3333-3333-3333-333333333338"), new Guid("11111111-1111-1111-1111-111111111113") },
                    { new Guid("33333333-3333-3333-3333-333333333339"), new Guid("11111111-1111-1111-1111-111111111113") },
                    { new Guid("33333333-3333-3333-3333-333333333340"), new Guid("11111111-1111-1111-1111-111111111113") },
                    { new Guid("33333333-3333-3333-3333-333333333341"), new Guid("11111111-1111-1111-1111-111111111113") },
                    { new Guid("33333333-3333-3333-3333-333333333342"), new Guid("11111111-1111-1111-1111-111111111113") },
                    { new Guid("33333333-3333-3333-3333-333333333331"), new Guid("11111111-1111-1111-1111-111111111114") },
                    { new Guid("33333333-3333-3333-3333-333333333333"), new Guid("11111111-1111-1111-1111-111111111114") },
                    { new Guid("33333333-3333-3333-3333-333333333335"), new Guid("11111111-1111-1111-1111-111111111114") },
                    { new Guid("33333333-3333-3333-3333-333333333337"), new Guid("11111111-1111-1111-1111-111111111114") },
                    { new Guid("33333333-3333-3333-3333-333333333339"), new Guid("11111111-1111-1111-1111-111111111114") },
                    { new Guid("33333333-3333-3333-3333-333333333341"), new Guid("11111111-1111-1111-1111-111111111114") },
                    { new Guid("33333333-3333-3333-3333-333333333343"), new Guid("11111111-1111-1111-1111-111111111114") }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "Email", "EmployeeNumber", "FirstName", "IsActive", "LastName", "Name", "PasswordHash", "PositionAr", "PositionEn", "RoleId" },
                values: new object[,]
                {
                    { new Guid("22222222-2222-2222-2222-222222222223"), new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "engineer@sasheco.com", "ENG001", "Project", true, "Engineer", "engineer", "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje", "مدير مشروع", "Project Manager", new Guid("11111111-1111-1111-1111-111111111112") },
                    { new Guid("22222222-2222-2222-2222-222222222224"), new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "finance@sasheco.com", "FIN001", "Financial", true, "Analyst", "finance", "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje", "محلل مالي", "Financial Analyst", new Guid("11111111-1111-1111-1111-111111111113") }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333331"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333332"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333333"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333334"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333337"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333338"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333341"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333342"), new Guid("11111111-1111-1111-1111-111111111112") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333337"), new Guid("11111111-1111-1111-1111-111111111113") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333338"), new Guid("11111111-1111-1111-1111-111111111113") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333339"), new Guid("11111111-1111-1111-1111-111111111113") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333340"), new Guid("11111111-1111-1111-1111-111111111113") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333341"), new Guid("11111111-1111-1111-1111-111111111113") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333342"), new Guid("11111111-1111-1111-1111-111111111113") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333331"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333333"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333335"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333337"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333339"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333341"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "RolePermissions",
                keyColumns: new[] { "PermissionId", "RoleId" },
                keyValues: new object[] { new Guid("33333333-3333-3333-3333-333333333343"), new Guid("11111111-1111-1111-1111-111111111114") });

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("22222222-2222-2222-2222-222222222223"));

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("22222222-2222-2222-2222-222222222224"));

            migrationBuilder.DeleteData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("11111111-1111-1111-1111-111111111112"));

            migrationBuilder.DeleteData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("11111111-1111-1111-1111-111111111113"));

            migrationBuilder.DeleteData(
                table: "Roles",
                keyColumn: "Id",
                keyValue: new Guid("11111111-1111-1111-1111-111111111114"));
        }
    }
}
