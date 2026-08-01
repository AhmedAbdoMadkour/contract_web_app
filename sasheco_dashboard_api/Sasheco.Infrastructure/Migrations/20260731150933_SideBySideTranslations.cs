using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sasheco.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SideBySideTranslations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Translations");

            migrationBuilder.RenameColumn(
                name: "Position",
                table: "Users",
                newName: "PositionEn");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Permissions",
                newName: "NameEn");

            migrationBuilder.RenameColumn(
                name: "Description",
                table: "Permissions",
                newName: "NameAr");

            migrationBuilder.RenameColumn(
                name: "Title",
                table: "Approvals",
                newName: "TitleEn");

            migrationBuilder.RenameColumn(
                name: "Description",
                table: "Approvals",
                newName: "TitleAr");

            migrationBuilder.AddColumn<string>(
                name: "PositionAr",
                table: "Users",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionAr",
                table: "Permissions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionEn",
                table: "Permissions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionAr",
                table: "Approvals",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionEn",
                table: "Approvals",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333331"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض المواقع", "View Sites", "عرض المواقع" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333332"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة المواقع", "Manage Sites", "إدارة المواقع" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333333"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض الهندسة", "View Engineering", "عرض الهندسة" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333334"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة الهندسة", "Manage Engineering", "إدارة الهندسة" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333335"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض المستخدمين", "View Users", "عرض المستخدمين" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333336"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة المستخدمين", "Manage Users", "إدارة المستخدمين" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333337"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض الموافقات", "View Approvals", "عرض الموافقات" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333338"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة الموافقات", "Manage Approvals", "إدارة الموافقات" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333339"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض المالية", "View Finance", "عرض المالية" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333340"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة المالية", "Manage Finance", "إدارة المالية" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333341"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض الموردين", "View Vendors", "عرض الموردين" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333342"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة الموردين", "Manage Vendors", "إدارة الموردين" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333343"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "عرض السكرتارية", "View Secretary", "عرض السكرتارية" });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333344"),
                columns: new[] { "DescriptionAr", "DescriptionEn", "NameAr" },
                values: new object[] { "إدارة السكرتارية", "Manage Secretary", "إدارة السكرتارية" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: new Guid("22222222-2222-2222-2222-222222222222"),
                column: "PositionAr",
                value: "مسؤول");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PositionAr",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "DescriptionAr",
                table: "Permissions");

            migrationBuilder.DropColumn(
                name: "DescriptionEn",
                table: "Permissions");

            migrationBuilder.DropColumn(
                name: "DescriptionAr",
                table: "Approvals");

            migrationBuilder.DropColumn(
                name: "DescriptionEn",
                table: "Approvals");

            migrationBuilder.RenameColumn(
                name: "PositionEn",
                table: "Users",
                newName: "Position");

            migrationBuilder.RenameColumn(
                name: "NameEn",
                table: "Permissions",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "NameAr",
                table: "Permissions",
                newName: "Description");

            migrationBuilder.RenameColumn(
                name: "TitleEn",
                table: "Approvals",
                newName: "Title");

            migrationBuilder.RenameColumn(
                name: "TitleAr",
                table: "Approvals",
                newName: "Description");

            migrationBuilder.CreateTable(
                name: "Translations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EntityId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EntityType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FieldName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Locale = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Translations", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333331"),
                column: "Description",
                value: "View Sites");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333332"),
                column: "Description",
                value: "Manage Sites");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333333"),
                column: "Description",
                value: "View Engineering");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333334"),
                column: "Description",
                value: "Manage Engineering");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333335"),
                column: "Description",
                value: "View Users");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333336"),
                column: "Description",
                value: "Manage Users");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333337"),
                column: "Description",
                value: "View Approvals");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333338"),
                column: "Description",
                value: "Manage Approvals");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333339"),
                column: "Description",
                value: "View Finance");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333340"),
                column: "Description",
                value: "Manage Finance");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333341"),
                column: "Description",
                value: "View Vendors");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333342"),
                column: "Description",
                value: "Manage Vendors");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333343"),
                column: "Description",
                value: "View Secretary");

            migrationBuilder.UpdateData(
                table: "Permissions",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333344"),
                column: "Description",
                value: "Manage Secretary");
        }
    }
}
