using LingoCross.Domain.Enums;

namespace LingoCross.Application.Teachers.Dtos;

/// <summary>
/// Öğretmen takip panelinde bir öğrencinin özet satırı. Sayılar/ortalama/son aktivite yalnızca
/// öğrencinin bu öğretmenle <b>paylaştığı</b> (shared_with_teacher=true) sonuçlar üzerinden hesaplanır.
/// </summary>
public record StudentSummaryDto(
    Guid StudentId,
    string DisplayName,
    int SharedResultsCount,
    int? AverageScore,
    DateTime? LastActivityAt);

/// <summary>
/// Öğretmen profili istatistik kartları (F7). Sınıf/öğrenci sayıları anlık durumu, haftalık
/// sayılar son 7 günü (UtcNow-7g) yansıtır. <see cref="WeeklyAssignedCount"/> bu hafta yapılan
/// atamalardan beklenen (öğrenci × ödev) tamamlama sayısı; <see cref="WeeklyCompletedCount"/> bu
/// hafta fiilen tamamlanan distinct (öğrenci, oyun) sayısıdır. <see cref="CompletionRate"/> 0–100
/// arası yuvarlanmış orandır (beklenen 0 ise 0).
/// </summary>
public record TeacherStatsDto(
    int ClassCount,
    int StudentCount,
    int WeeklyAssignedCount,
    int WeeklyCompletedCount,
    int CompletionRate);

/// <summary>
/// Öğretmenin bir öğrencisinin paylaştığı tek bir sonucun görünümü (ders/oyun özetiyle).
/// Yalnızca shared_with_teacher=true sonuçlar bu DTO'ya dönüşür.
/// </summary>
public record SharedResultDto(
    Guid ResultId,
    string LessonTitle,
    GameType GameType,
    int Score,
    int DurationMs,
    int TotalItems,
    int CorrectItems,
    DateTime? SharedAt,
    DateTime CreatedAt);

/// <summary>
/// Öğretmenin, bir öğrencinin paylaştığı tek bir sonucun kelime-bazlı detayı (F7.5). Yalnızca
/// öğrencinin bu öğretmenle paylaştığı (shared_with_teacher=true) sonuçlar bu DTO'ya dönüşür;
/// aksi 404. <see cref="Items"/> sonucun kelime kırılımıdır (Ordinal sırasında); eski sonuçlarda
/// boş liste döner.
/// </summary>
public record StudentResultDetailDto(
    Guid ResultId,
    string StudentDisplayName,
    string LessonTitle,
    GameType GameType,
    int Score,
    int DurationMs,
    int TotalItems,
    int CorrectItems,
    DateTime? SharedAt,
    DateTime CreatedAt,
    IReadOnlyList<ResultItemDto> Items);

/// <summary>Sonuç detayında tek bir kelime-bazlı kalem (F7.5).</summary>
public record ResultItemDto(
    int Ordinal,
    string Term,
    string ExpectedAnswer,
    string? StudentAnswer,
    bool IsCorrect);
