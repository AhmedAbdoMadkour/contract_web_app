$code = @"
using System;
using Microsoft.Data.Sqlite;

class Program
{
    static void Main()
    {
        try
        {
            using var connection = new SqliteConnection("Data Source=sasheco.db");
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = "SELECT count(*) FROM Users";
            var count = command.ExecuteScalar();
            Console.WriteLine($"Users count: {count}");
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
        }
    }
}
"@
Set-Content -Path "TestDb.cs" -Value $code
dotnet build
dotnet run
