using LingoCross.Application.Games;
using LingoCross.Application.Games.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Kelime eşleştirme oyunları ve oturumları. Erişim/sahiplik kuralları servis katmanında
/// uygulanır (aksi 403/404). Sonuç/paylaşım (game_results) M5 kapsamındadır.
/// </summary>
[ApiController]
[Authorize]
public class GamesController : ControllerBase
{
    private readonly IGameService _gameService;

    public GamesController(IGameService gameService)
    {
        _gameService = gameService;
    }

    /// <summary>
    /// Dersin oyunlarını döndürür; öğretmen için WordMatching oyunu yoksa üretilip eklenir.
    /// Öğretmen kendi dersi, öğrenci enrolled+published ders için erişebilir.
    /// </summary>
    [HttpGet("api/lessons/{lessonId:guid}/games")]
    public async Task<ActionResult<IReadOnlyList<GameDto>>> ListForLesson(Guid lessonId, CancellationToken ct)
    {
        var games = await _gameService.ListOrCreateForLessonAsync(lessonId, ct);
        return Ok(games);
    }

    /// <summary>
    /// Öğrenci, bir oyun için yeni bir oturum başlatır. Üretilmiş kelime eşleştirme içeriğiyle döner.
    /// </summary>
    [Authorize(Roles = "Student")]
    [HttpPost("api/games/{gameId:guid}/sessions")]
    public async Task<ActionResult<StartGameSessionResponse>> StartSession(Guid gameId, CancellationToken ct)
    {
        var response = await _gameService.StartSessionAsync(gameId, ct);
        return CreatedAtAction(nameof(GetSession), new { sessionId = response.Session.Id }, response);
    }

    /// <summary>Bir oyun oturumunun durumu (yalnızca sahibi öğrenci).</summary>
    [Authorize(Roles = "Student")]
    [HttpGet("api/game-sessions/{sessionId:guid}")]
    public async Task<ActionResult<GameSessionDto>> GetSession(Guid sessionId, CancellationToken ct)
    {
        var session = await _gameService.GetSessionAsync(sessionId, ct);
        return Ok(session);
    }
}
