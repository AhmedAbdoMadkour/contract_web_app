using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sasheco.Infrastructure.Data.Migrations
{
    /// <inheritdoc />
    public partial class BilingualFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Vendors",
                newName: "NameEn");

            migrationBuilder.RenameColumn(
                name: "ContactPerson",
                table: "Vendors",
                newName: "NameAr");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Sites",
                newName: "NameEn");

            migrationBuilder.RenameColumn(
                name: "Location",
                table: "Sites",
                newName: "NameAr");

            migrationBuilder.RenameColumn(
                name: "Description",
                table: "Sites",
                newName: "LocationEn");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Projects",
                newName: "NameEn");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "EngineeringProjects",
                newName: "NameEn");

            migrationBuilder.RenameColumn(
                name: "Description",
                table: "EngineeringProjects",
                newName: "NameAr");

            migrationBuilder.AddColumn<string>(
                name: "ContactPersonAr",
                table: "Vendors",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ContactPersonEn",
                table: "Vendors",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionAr",
                table: "Sites",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionEn",
                table: "Sites",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "LocationAr",
                table: "Sites",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "NameAr",
                table: "Projects",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionAr",
                table: "EngineeringProjects",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DescriptionEn",
                table: "EngineeringProjects",
                type: "TEXT",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ContactPersonAr",
                table: "Vendors");

            migrationBuilder.DropColumn(
                name: "ContactPersonEn",
                table: "Vendors");

            migrationBuilder.DropColumn(
                name: "DescriptionAr",
                table: "Sites");

            migrationBuilder.DropColumn(
                name: "DescriptionEn",
                table: "Sites");

            migrationBuilder.DropColumn(
                name: "LocationAr",
                table: "Sites");

            migrationBuilder.DropColumn(
                name: "NameAr",
                table: "Projects");

            migrationBuilder.DropColumn(
                name: "DescriptionAr",
                table: "EngineeringProjects");

            migrationBuilder.DropColumn(
                name: "DescriptionEn",
                table: "EngineeringProjects");

            migrationBuilder.RenameColumn(
                name: "NameEn",
                table: "Vendors",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "NameAr",
                table: "Vendors",
                newName: "ContactPerson");

            migrationBuilder.RenameColumn(
                name: "NameEn",
                table: "Sites",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "NameAr",
                table: "Sites",
                newName: "Location");

            migrationBuilder.RenameColumn(
                name: "LocationEn",
                table: "Sites",
                newName: "Description");

            migrationBuilder.RenameColumn(
                name: "NameEn",
                table: "Projects",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "NameEn",
                table: "EngineeringProjects",
                newName: "Name");

            migrationBuilder.RenameColumn(
                name: "NameAr",
                table: "EngineeringProjects",
                newName: "Description");
        }
    }
}
