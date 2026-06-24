using LingoCross.Domain.Enums;

namespace LingoCross.Application.Results.Dtos;

/// <summary>Bir oyun sonucunun gönderimi (öğrenci, oyun sonunda).</summary>
public record SubmitResultRequest(
    int DurationMs,
    int TotalItems,
    int CorrectItems);

/// <summary>
/// Bir oyun sonucunun tam görünümü (oturum + ders/oyun özetiyle). ListMine ve submit/share
/// yanıtlarında kullanılır.
/// </summary>
public record GameResultDto(
    Guid Id,
    Guid SessionId,
    Guid GameId,
    GameType GameType,
    Guid LessonId,
    string LessonTitle,
    int DurationMs,
    int TotalItems,
    int CorrectItems,
    int Score,
    bool SharedWithTeacher,
    DateTime? SharedAt,
    DateTime CreatedAt);

/// <summary>
/// Öğrenci profil istatistikleri (F3.1). Yalnızca tamamlanmış oyun sonuçlarından türetilen iki
/// gerçek metrik içerir; günlük seri / haftalık hedef / rozet bu fazda yoktur (mobil placeholder).
/// </summary>
public record StudentStatsDto(
    /// <summary>Öğrencinin tamamlanmış oyun sonucu sayısı.</summary>
    int GamesPlayed,
    /// <summary>Bu sonuçların ortalama başarı puanı (0–100, AwayFromZero yuvarlanır); sonuç yoksa 0.</summary>
    int AverageAccuracy);
