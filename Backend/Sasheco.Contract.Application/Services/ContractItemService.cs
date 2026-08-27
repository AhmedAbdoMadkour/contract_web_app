using System.Globalization;
using CsvHelper;
using CsvHelper.Configuration;
using ExcelDataReader;
using Sasheco.Contract.Application.Interfaces;
using Sasheco.Contract.Domain.Entities;
using Sasheco.Contract.Domain.Interfaces;

namespace Sasheco.Contract.Application.Services;

public class ContractItemService : IContractItemService
{
    private readonly IContractItemRepository _repository;

    public ContractItemService(IContractItemRepository repository)
    {
        _repository = repository;
    }

    public async Task<ContractItem> AddItemAsync(Guid contractId, ContractItem item)
    {
        item.ContractId = contractId;
        item.TotalPrice = item.Quantity * item.UnitPrice;
        return await _repository.AddAsync(item);
    }

    public async Task<IEnumerable<ContractItem>> AddItemsBulkAsync(Guid contractId, Stream fileStream, string fileName)
    {
        var items = new List<ContractItem>();
        var ext = Path.GetExtension(fileName).ToLower();

        if (ext == ".csv")
        {
            using var reader = new StreamReader(fileStream);
            using var csv = new CsvReader(reader, new CsvConfiguration(CultureInfo.InvariantCulture) { HasHeaderRecord = true });
            
            var records = csv.GetRecords<ContractItemCsvRecord>().ToList();
            foreach (var record in records)
            {
                items.Add(new ContractItem
                {
                    ContractId = contractId,
                    Description = record.Description,
                    Quantity = record.Quantity,
                    UnitPrice = record.UnitPrice,
                    TotalPrice = record.Quantity * record.UnitPrice
                });
            }
        }
        else if (ext == ".xls" || ext == ".xlsx")
        {
            System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);
            using var reader = ExcelReaderFactory.CreateReader(fileStream);
            var result = reader.AsDataSet(new ExcelDataSetConfiguration()
            {
                ConfigureDataTable = (_) => new ExcelDataTableConfiguration()
                {
                    UseHeaderRow = true
                }
            });

            var table = result.Tables[0];
            foreach (System.Data.DataRow row in table.Rows)
            {
                if (row.ItemArray.All(x => x is DBNull || string.IsNullOrWhiteSpace(x?.ToString())))
                    continue;

                var desc = row["Description"]?.ToString() ?? "";
                var qtyStr = row["Quantity"]?.ToString();
                var priceStr = row["UnitPrice"]?.ToString();

                decimal.TryParse(qtyStr, out decimal qty);
                decimal.TryParse(priceStr, out decimal price);

                items.Add(new ContractItem
                {
                    ContractId = contractId,
                    Description = desc,
                    Quantity = qty,
                    UnitPrice = price,
                    TotalPrice = qty * price
                });
            }
        }
        else
        {
            throw new ArgumentException("Unsupported file type");
        }

        return await _repository.AddRangeAsync(items);
    }

    private class ContractItemCsvRecord
    {
        public string Description { get; set; } = string.Empty;
        public decimal Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }
}
