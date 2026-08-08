using System;
using System.Text.Json.Serialization;

namespace Sasheco.Application.UserManagement.DTOs
{
    public class CreateUserDTO
    {
        [JsonPropertyName("email")]
        public string Email { get; set; } = string.Empty;
        [JsonPropertyName("password")]
        public string Password { get; set; } = string.Empty;
        [JsonPropertyName("firstName")]
        public string FirstName { get; set; } = string.Empty;
        [JsonPropertyName("lastName")]
        public string LastName { get; set; } = string.Empty;
        [JsonPropertyName("role")]
        public string Role { get; set; } = string.Empty;
        [JsonPropertyName("avatarBase64")]
        public string? AvatarBase64 { get; set; }
    }
}
