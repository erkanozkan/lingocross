using LingoCross.Application.Results;
using LingoCross.Application.Results.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Öğrenci tarafı profil uçları (F3.1). Sahiplik kuralları servis katmanında uygulanır;
/// öğrenci yalnızca kendi verisine erişir.
/// </summary>
[ApiController]
[Authorize(Roles = "Student")]
[Route("api/students")]
public class StudentsController : ControllerBase
{
    private readonly IResultService _resultService;

    public StudentsController(IResultService resultService)
    {
        _resultService = resultService;
    }

    /// <summary>
    /// Geçerli öğrencinin profil istatistikleri: tamamlanmış oyun sayısı ve ortalama başarı puanı.
    /// </summary>
    [HttpGet("me/stats")]
    public async Task<ActionResult<StudentStatsDto>> GetMyStats(CancellationToken ct)
    {
        var stats = await _resultService.GetMyStatsAsync(ct);
        return Ok(stats);
    }

    /// <summary>
    /// Geçerli öğrencinin "Gelişim Özeti" zengin istatistiği: oynanan oyun, ortalama doğruluk,
    /// 7 günlük doğruluk trendi, haftalık dakika/hedef ve günlük seri (streak).
    /// </summary>
    [HttpGet("me/progress")]
    public async Task<ActionResult<StudentProgressDto>> GetMyProgress(CancellationToken ct)
    {
        var progress = await _resultService.GetMyProgressAsync(ct);
        return Ok(progress);
    }
}
