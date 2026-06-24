using LingoCross.Application.Results;
using LingoCross.Application.Results.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Oyun sonuçları (M5, öğrenci tarafı): sonuç gönderimi, öğretmenle paylaşım ve öğrencinin
/// geçmişi. Sahiplik kuralları servis katmanında uygulanır (aksi 404). Öğretmen takip
/// görünümü M6 kapsamındadır.
/// </summary>
[ApiController]
[Authorize(Roles = "Student")]
public class ResultsController : ControllerBase
{
    private readonly IResultService _resultService;

    public ResultsController(IResultService resultService)
    {
        _resultService = resultService;
    }

    /// <summary>
    /// Bir oyun oturumu için sonuç gönderir (süre + başarı). Skor hesaplanır, oturum tamamlanır.
    /// Oturum başına tek sonuç; tekrar gönderimde mevcut sonuç döner.
    /// </summary>
    [HttpPost("api/game-sessions/{sessionId:guid}/result")]
    public async Task<ActionResult<GameResultDto>> SubmitResult(
        Guid sessionId, [FromBody] SubmitResultRequest request, CancellationToken ct)
    {
        var result = await _resultService.SubmitResultAsync(sessionId, request, ct);
        return Ok(result);
    }

    /// <summary>Bir sonucu öğretmenle paylaşır.</summary>
    [HttpPost("api/results/{resultId:guid}/share")]
    public async Task<ActionResult<GameResultDto>> Share(Guid resultId, CancellationToken ct)
    {
        var result = await _resultService.ShareWithTeacherAsync(resultId, ct);
        return Ok(result);
    }

    /// <summary>Geçerli öğrencinin geçmiş sonuçları.</summary>
    [HttpGet("api/results/me")]
    public async Task<ActionResult<IReadOnlyList<GameResultDto>>> ListMine(CancellationToken ct)
    {
        var results = await _resultService.ListMineAsync(ct);
        return Ok(results);
    }
}
