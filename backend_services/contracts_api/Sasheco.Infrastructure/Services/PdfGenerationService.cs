using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using Sasheco.Application.Interfaces;

namespace Sasheco.Infrastructure.Services;

public class PdfGenerationService : IPdfGenerationService
{
    static PdfGenerationService()
    {
        QuestPDF.Settings.License = LicenseType.Community;
    }

    public byte[] GeneratePdf(string content, string title = "Document")
    {
        var document = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(2, Unit.Centimetre);
                page.PageColor(Colors.White);
                page.DefaultTextStyle(x => x.FontSize(12).FontFamily(Fonts.Arial));
                
                page.ContentFromRightToLeft();

                page.Header().Element(ComposeHeader);
                page.Content().Element(x => ComposeContent(x, title, content));
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
                column.Item().Text("SASHECO").FontSize(20).SemiBold().FontColor(Colors.Blue.Darken2);
                column.Item().Text("Engineering & Contracting").FontSize(14).FontColor(Colors.Grey.Medium);
            });

            row.ConstantItem(100).AlignRight().Text("Mock Logo").FontSize(16).Bold();
        });
    }

    private void ComposeContent(IContainer container, string title, string content)
    {
        container.PaddingVertical(1, Unit.Centimetre).Column(column =>
        {
            column.Spacing(20);
            
            column.Item().AlignCenter().Text(title).FontSize(18).SemiBold();

            // The content might have multiple lines, split by newlines for better rendering
            var paragraphs = content.Split('\n', StringSplitOptions.RemoveEmptyEntries);
            foreach (var paragraph in paragraphs)
            {
                column.Item().Text(paragraph).FontSize(12).LineHeight(1.5f);
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
