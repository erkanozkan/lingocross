using LingoCross.Domain.Enums;

namespace LingoCross.Application.Results.Dtos;

/// <summary>
/// Bir oyun sonucunun gönderimi (öğrenci, oyun sonunda). <see cref="Items"/> opsiyoneldir
/// (F7.5): doluysa kelime-bazlı kırılım kaydedilir ve toplam/doğru sayıları item listesinden
/// türetilir; null/boş ise eski davranış korunur (istemciden gelen sayılar kullanılır).
/// </summary>
public record SubmitResultRequest(
    int DurationMs,
    int TotalItems,
    int CorrectItems,
    IReadOnlyList<SubmitResultItem>? Items = null);

/// <summary>Sonuç gönderiminde tek bir kelime-bazlı kalem (F7.5).</summary>
public record SubmitResultItem(
    int Ordinal,
    string Term,
    string ExpectedAnswer,
    string? StudentAnswer,
    bool IsCorrect);

/// <summary>
/// Bir oyun sonucunun tam görünümü (oturum + ders/oyun özetiyle). ListMine ve submit/share
/// yanıtlarında kullanılır.
/// </summary>
public record GameResultDto(
    Guid Id,
    Guid SessionId,
    Guid GameId,
    GameType GameType,
    Guid? LessonId,
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
