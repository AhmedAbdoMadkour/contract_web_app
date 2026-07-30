using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Sasheco.Domain.Entities;
using Sasheco.Domain.Interfaces;

namespace Sasheco.Api.Controllers;

public record CreateVendorRequest(string VendorCode, string Name, string RegistrationNumber, string TaxNumber);

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class VendorsController : ControllerBase
{
    private readonly IRepository<Vendor> _vendorRepository;

    public VendorsController(IRepository<Vendor> vendorRepository)
    {
        _vendorRepository = vendorRepository;
    }

    [HttpGet]
    public async Task<IActionResult> GetVendors()
    {
        var vendors = await _vendorRepository.GetAllAsync();
        return Ok(vendors);
    }

    [HttpPost]
    public async Task<IActionResult> CreateVendor([FromBody] CreateVendorRequest request)
    {
        var vendor = new Vendor
        {
            Id = Guid.NewGuid(),
            VendorCode = request.VendorCode,
            NameEn = request.Name,
            NameAr = request.Name, // Fallback for now
            RegistrationNumber = request.RegistrationNumber,
            TaxNumber = request.TaxNumber
        };

        await _vendorRepository.AddAsync(vendor);
        return CreatedAtAction(nameof(GetVendors), new { id = vendor.Id }, vendor);
    }
}
