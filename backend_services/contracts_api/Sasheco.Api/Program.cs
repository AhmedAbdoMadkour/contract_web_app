using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Sasheco.Infrastructure.Data;
using Sasheco.Api.Middleware;
using System.Text;
using FluentValidation;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<Sasheco.Api.Services.ILocaleProvider, Sasheco.Api.Services.LocaleProvider>();
builder.Services.AddScoped(typeof(Sasheco.Domain.Interfaces.IRepository<>), typeof(Sasheco.Infrastructure.Repositories.Repository<>));
builder.Services.AddScoped<Sasheco.Domain.Interfaces.IUserRepository, Sasheco.Infrastructure.Repositories.UserRepository>();
builder.Services.AddScoped<Sasheco.Application.Interfaces.IJwtService, Sasheco.Infrastructure.Services.JwtService>();
builder.Services.AddScoped<Sasheco.Application.Engineering.Services.IContractPdfGenerator, Sasheco.Application.Engineering.Services.ContractPdfGenerator>();
builder.Services.AddScoped<Sasheco.Application.Interfaces.IVariableBindingService, Sasheco.Infrastructure.Services.VariableBindingService>();
builder.Services.AddScoped<Sasheco.Application.Interfaces.IPdfGenerationService, Sasheco.Infrastructure.Services.PdfGenerationService>();
// Configure Validation
builder.Services.AddValidatorsFromAssemblyContaining<Sasheco.Application.Auth.Validators.LoginRequestValidator>();

// Configure MediatR
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Sasheco.Application.Auth.Validators.LoginRequestValidator).Assembly));

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        var allowedOrigins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>() ?? new[] { "http://localhost:3000", "http://localhost:5000", "https://localhost:5001" };
        policy.SetIsOriginAllowed(origin => true)
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

// Configure EF Core DbContext
builder.Services.AddDbContext<SashecoDbContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
                           ?? "Server=localhost,1433;Database=SashecoDb;User Id=SA;Password=Sasheco_Super_Secret_Password_2026!;TrustServerCertificate=True";
    options.UseSqlServer(connectionString);
});

// Configure JWT Authentication
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["SecretKey"] ?? "sasheco_super_secret_default_key_2026_xyz";

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"] ?? "SashecoApi",
        ValidAudience = jwtSettings["Audience"] ?? "SashecoUsers",
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey))
    };
});

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("RequireAdminRole", policy => policy.RequireRole("Admin"));
    options.AddPolicy("RequireUserRole", policy => policy.RequireRole("User", "Admin"));
});
var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<SashecoDbContext>();
    await dbContext.Database.MigrateAsync();
    await Sasheco.Infrastructure.Data.DataSeeder.SeedAsync(app.Services);
}

// Configure the HTTP request pipeline.
app.UseMiddleware<ExceptionHandlingMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFrontend");

// app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
