using System;
public class Test {
    public static void Main() {
        bool result = BCrypt.Net.BCrypt.Verify("password", "$2a$11$O3zVCihyy0MSym1gcrABCuoez8HBLdos8JD7XxlAuxdOMxamf3wje");
        Console.WriteLine(result);
    }
}
