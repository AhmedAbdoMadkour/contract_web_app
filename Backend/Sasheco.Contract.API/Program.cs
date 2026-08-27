using Microsoft.EntityFrameworkCore;
using Sasheco.Contract.Application.Interfaces;
using Sasheco.Contract.Application.Services;
using Sasheco.Contract.Domain.Interfaces;
using Sasheco.Contract.Infrastructure.Data;
using Sasheco.Contract.Infrastructure.Data.Repositories;
using Sasheco.Contract.Infrastructure.Services;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddOpenApi();

// Setup DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection") ?? "Server=(localdb)\\mssqllocaldb;Database=SashecoDb;Trusted_Connection=True;"));

// Setup Dependency Injection
builder.Services.AddScoped<IContractItemRepository, ContractItemRepository>();
builder.Services.AddScoped<IProjectDrawingRepository, ProjectDrawingRepository>();
builder.Services.AddScoped<IContractItemService, ContractItemService>();
builder.Services.AddScoped<IProjectDrawingService, ProjectDrawingService>();
builder.Services.AddSingleton<ILocalStorageService, LocalStorageService>();

var app = builder.Build();

// Ensure the local storage directory exists for serving static files
var uploadsPath = Path.Combine(Directory.GetCurrentDirectory(), "uploads");
if (!Directory.Exists(uploadsPath))
{
    Directory.CreateDirectory(uploadsPath);
}

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(uploadsPath),
    RequestPath = "/uploads"
});

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.MapControllers();
app.Run();
