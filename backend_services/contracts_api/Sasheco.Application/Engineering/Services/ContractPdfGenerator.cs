using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using Sasheco.Domain.Entities;

namespace Sasheco.Application.Engineering.Services;

public interface IContractPdfGenerator
{
    byte[] GeneratePdf(Contract contract);
}

public class ContractPdfGenerator : IContractPdfGenerator
{
    public byte[] GeneratePdf(Contract contract)
    {
        QuestPDF.Settings.License = LicenseType.Community;

        var document = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(2, Unit.Centimetre);
                page.PageColor(Colors.White);
                page.DefaultTextStyle(x => x.FontSize(11).FontFamily(Fonts.Arial));

                page.Header().Element(ComposeHeader);
                page.Content().Element(x => ComposeContent(x, contract));
                page.Footer().Element(ComposeFooter);
            });
        });

        return document.GeneratePdf();
    }

    private void ComposeHeader(IContainer container)
    {
        container.Row(row =>
        {
            row.RelativeItem().Column(column =>
            {
                column.Item().Text("SASHECO").FontSize(24).SemiBold().FontColor(Colors.Blue.Darken2);
                column.Item().Text("Contract Export Document").FontSize(14).FontColor(Colors.Grey.Medium);
            });
            row.ConstantItem(100).AlignRight().Text($"Date: {DateTime.Now:yyyy-MM-dd}");
        });
    }

    private void ComposeContent(IContainer container, Contract contract)
    {
        container.PaddingVertical(1, Unit.Centimetre).Column(column =>
        {
            column.Spacing(20);

            column.Item().Text($"Project: {contract.Project?.NameEn ?? contract.Project?.NameAr}").FontSize(16).SemiBold();
            column.Item().Text($"Vendor: {contract.Vendor?.NameEn ?? contract.Vendor?.NameAr}").FontSize(14);
            column.Item().Text($"Status: {contract.Status}").FontSize(12);

            column.Item().LineHorizontal(1).LineColor(Colors.Grey.Lighten2);

            column.Item().Text("Contract Items & Pricing").FontSize(14).SemiBold();
            column.Item().Element(x => ComposeTable(x, contract.Items.ToList()));

            var total = contract.Items.Sum(x => x.Price * x.Quantity);
            column.Item().AlignRight().Text($"Total: ${total:N2}").FontSize(14).Bold();

            column.Item().LineHorizontal(1).LineColor(Colors.Grey.Lighten2);

            column.Item().Text("Terms & Conditions").FontSize(14).SemiBold();
            foreach (var term in contract.Terms)
            {
                column.Item().PaddingBottom(5).Column(t => 
                {
                    t.Item().Text(term.Title).SemiBold();
                    t.Item().Text(term.Content).FontColor(Colors.Grey.Darken2);
                });
            }
        });
    }

    private void ComposeTable(IContainer container, List<ContractItem> items)
    {
        container.Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.RelativeColumn(3);
                columns.RelativeColumn(1);
                columns.RelativeColumn(2);
                columns.RelativeColumn(2);
            });

            table.Header(header =>
            {
                header.Cell().Element(CellStyle).Text("Item Name");
                header.Cell().Element(CellStyle).AlignRight().Text("Qty");
                header.Cell().Element(CellStyle).AlignRight().Text("Unit Price");
                header.Cell().Element(CellStyle).AlignRight().Text("Total");

                static IContainer CellStyle(IContainer container)
                {
                    return container.DefaultTextStyle(x => x.SemiBold()).PaddingVertical(5).BorderBottom(1).BorderColor(Colors.Black);
                }
            });

            foreach (var item in items)
            {
                table.Cell().Element(CellStyle).Text(item.ItemName);
                table.Cell().Element(CellStyle).AlignRight().Text(item.Quantity.ToString());
                table.Cell().Element(CellStyle).AlignRight().Text($"${item.Price:N2}");
                table.Cell().Element(CellStyle).AlignRight().Text($"${(item.Price * item.Quantity):N2}");

                static IContainer CellStyle(IContainer container)
                {
                    return container.BorderBottom(1).BorderColor(Colors.Grey.Lighten2).PaddingVertical(5);
                }
            }
        });
    }

    private void ComposeFooter(IContainer container)
    {
        container.AlignCenter().Text(x =>
        {
            x.Span("Page ");
            x.CurrentPageNumber();
            x.Span(" of ");
            x.TotalPages();
        });
    }
}
