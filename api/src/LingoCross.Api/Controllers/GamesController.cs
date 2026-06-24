using LingoCross.Application.Games;
using LingoCross.Application.Games.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Kelime eşleştirme oyunları (bulmacalar) ve oturumları. F2.2: öğretmen oyunu oluşturup yayımlar,
/// yayımlanan oyun Active eşleşmeli öğrencilerine atanmış sayılır. Erişim/sahiplik kuralları servis
/// katmanında uygulanır (aksi 403/404). Sonuç/paylaşım (game_results) M5 kapsamındadır.
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
    /// Öğretmen, kendi dersinde bir oyun (bulmaca) oluşturur ve yayımlar. Ders en az 4 çevirili
    /// kelime içermeli; MVP'de yalnız WordMatching desteklenir. İdempotent: aynı ders+tür için
    /// mevcut oyun yeniden yayımlanır.
    /// </summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost("api/lessons/{lessonId:guid}/games")]
    public async Task<ActionResult<GameDto>> CreateForLesson(Guid lessonId, [FromBody] CreateGameRequest request, CancellationToken ct)
    {
        var game = await _gameService.CreateForLessonAsync(lessonId, request, ct);
        return CreatedAtAction(nameof(ListForLesson), new { lessonId }, game);
    }

    /// <summary>Ders sahibinin o derse ait oyunlarını listeler (salt-okunur, otomatik üretim yok).</summary>
    [Authorize(Roles = "Teacher")]
    [HttpGet("api/lessons/{lessonId:guid}/games")]
    public async Task<ActionResult<IReadOnlyList<GameDto>>> ListForLesson(Guid lessonId, CancellationToken ct)
    {
        var games = await _gameService.ListForLessonAsync(lessonId, ct);
        return Ok(games);
    }

    /// <summary>
    /// F3.2 "Bulmacalarım": öğretmenin tüm derslerindeki bulmacaları (yeniden → eskiye) listeler;
    /// her biri için atanan aktif öğrenci sayısı ve tamamlanan çözüm sayısıyla.
    /// </summary>
    [Authorize(Roles = "Teacher")]
    [HttpGet("api/teachers/me/games")]
    public async Task<ActionResult<IReadOnlyList<TeacherPuzzleDto>>> ListMyPuzzles(CancellationToken ct)
    {
        var puzzles = await _gameService.ListMyPuzzlesAsync(ct);
        return Ok(puzzles);
    }

    /// <summary>
    /// F3.2 "Paylaş": bir bulmacayı idempotent olarak (yeniden) yayımlar. Yalnız ders sahibi öğretmen;
    /// başkasının oyunu → 404. Güncel oyun bilgisini döner.
    /// </summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost("api/games/{id:guid}/share")]
    public async Task<ActionResult<GameDto>> Share(Guid id, CancellationToken ct)
    {
        var game = await _gameService.ShareAsync(id, ct);
        return Ok(game);
    }

    /// <summary>
    /// Öğrenciye atanmış (Active eşleşmeli öğretmenlerin yayımlanmış derslerindeki yayımlanmış)
    /// bulmacaları döndürür.
    /// </summary>
    [Authorize(Roles = "Student")]
    [HttpGet("api/games/assigned")]
    public async Task<ActionResult<IReadOnlyList<AssignedGameDto>>> ListAssigned(CancellationToken ct)
    {
        var games = await _gameService.ListAssignedForStudentAsync(ct);
        return Ok(games);
    }

    /// <summary>
    /// Öğrenci, bir oyun için yeni bir oturum başlatır. Oyun yayımlanmış ve ders erişilebilir olmalı.
    /// Üretilmiş kelime eşleştirme içeriğiyle döner.
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

    /// <summary>
    /// F4.3: Bir oyunun atandığı sınıfları SET semantiğiyle günceller (gönderilen liste nihaidir).
    /// Yalnız ders sahibi öğretmen; oyun/sınıf sahibi değilse 404. Nihai atanmış sınıf kimlikleri döner.
    /// </summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost("api/games/{gameId:guid}/assignments")]
    public async Task<ActionResult<GameAssignmentsDto>> SetAssignments(Guid gameId, [FromBody] SetGameAssignmentsRequest request, CancellationToken ct)
    {
        var dto = await _gameService.SetAssignmentsAsync(gameId, request, ct);
        return Ok(dto);
    }

    /// <summary>F4.3: Bir oyunun atandığı sınıf kimliklerini döndürür. Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpGet("api/games/{gameId:guid}/assignments")]
    public async Task<ActionResult<GameAssignmentsDto>> GetAssignments(Guid gameId, CancellationToken ct)
    {
        var dto = await _gameService.GetAssignmentsAsync(gameId, ct);
        return Ok(dto);
    }
}
