using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
//using SnackSenseAPI.Models;  // Update namespace as needed
//using SnackSenseAPI.Data;

[ApiController]
[Route("[controller]")]
public class ScanController : ControllerBase {
    private readonly ApplicationDbContext _context;

    public ScanController(ApplicationDbContext context) {
        _context = context;
    }

    // GET /scan/user-scans
    [HttpGet("user-scans")]
    public async Task<IActionResult> GetUserScans() {
        var userId = "test-user-id"; // Replace with Firebase UID later
        var scans = await _context.Scans
            .Where(s => s.FirebaseUserId == userId)
            .OrderByDescending(s => s.Timestamp)
            .ToListAsync();

        return Ok(scans);
    }

    // GET /scan/user-scanImg/{id}
    [HttpGet("user-scanImg/{id}")]
    public async Task<IActionResult> GetScanImage(int id) {
        var scan = await _context.Scans.FindAsync(id);
        if (scan == null) return NotFound();

        return Ok(new { imageUrl = scan.ImageUrl });
    }

    // POST /scan/new-scan
    [HttpPost("new-scan")]
    public async Task<IActionResult> AddScan([FromBody] Scan scan) {
        scan.Timestamp = DateTime.UtcNow;
        scan.FirebaseUserId = "test-user-id"; // Replace later

        _context.Scans.Add(scan);
        await _context.SaveChangesAsync();
        return Ok(scan);
    }
}
