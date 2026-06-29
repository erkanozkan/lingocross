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

/// <summary>
/// Öğrenci paneli "Gelişim Özeti" için zengin istatistik (F3.1+). Tüm metrikler yalnızca geçerli
/// öğrencinin tamamlanmış oyun sonuçlarından (game_results) türetilir; salt-okur. Hiç sonuç yoksa
/// sayısal alanlar 0, <see cref="AccuracyTrendDelta"/> null döner.
/// </summary>
public record StudentProgressDto(
    /// <summary>Tamamlanmış oyun sonucu sayısı.</summary>
    int GamesPlayed,
    /// <summary>Tüm sonuçların ortalama başarı puanı (0–100, AwayFromZero yuvarlanır); sonuç yoksa 0.</summary>
    int AverageAccuracy,
    /// <summary>
    /// Son 7 gün ortalama doğruluk − önceki 7 gün (gün 14..7) ortalama doğruluk. Negatif olabilir.
    /// Önceki 7 günlük pencerede hiç sonuç yoksa null (kıyaslanacak veri yok).
    /// </summary>
    int? AccuracyTrendDelta,
    /// <summary>Son 7 gündeki sonuçların toplam süresi, dakika (DurationMs toplamı / 60000, aşağı yuvarlanır).</summary>
    int WeeklyMinutes,
    /// <summary>Sabit haftalık çalışma hedefi (dakika). İleride kullanıcı-ayarına taşınabilir.</summary>
    int WeeklyGoalMinutes,
    /// <summary>Bugüne (UTC) kadar, en az bir tamamlanmış sonucu olan ardışık gün sayısı. Hiç sonuç yoksa 0.</summary>
    int StreakDays);
