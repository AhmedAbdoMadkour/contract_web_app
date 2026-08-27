using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Sasheco.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateEngineeringWorkflow : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DescriptionEn",
                table: "ContractItems",
                newName: "ItemName");

            migrationBuilder.RenameColumn(
                name: "DescriptionAr",
                table: "ContractItems",
                newName: "ItemCode");

            migrationBuilder.AddColumn<string>(
                name: "PaymentTerms",
                table: "Contracts",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PaymentTerms",
                table: "Contracts");

            migrationBuilder.RenameColumn(
                name: "ItemName",
                table: "ContractItems",
                newName: "DescriptionEn");

            migrationBuilder.RenameColumn(
                name: "ItemCode",
                table: "ContractItems",
                newName: "DescriptionAr");
        }
    }
}
