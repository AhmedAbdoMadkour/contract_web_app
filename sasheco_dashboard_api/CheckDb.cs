using System;
using Microsoft.Data.SqlClient;

class Program
{
    static void Main()
    {
        string connectionString = "Server=localhost;Database=SashecoDb;User Id=SA;Password=Sasheco_Super_Secret_Password_2026!;TrustServerCertificate=True;";
        using (var conn = new SqlConnection(connectionString))
        {
            conn.Open();
            using (var cmd = new SqlCommand("SELECT Name, Email, LEN(AvatarBase64) as B64Len FROM Users ORDER BY CreatedAt DESC", conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    string name = reader["Name"]?.ToString() ?? "";
                    string email = reader["Email"]?.ToString() ?? "";
                    string len = reader.IsDBNull(2) ? "NULL" : reader[2].ToString();
                    Console.WriteLine($"Name: {name}, Email: {email}, AvatarLength: {len}");
                }
            }
        }
    }
}
