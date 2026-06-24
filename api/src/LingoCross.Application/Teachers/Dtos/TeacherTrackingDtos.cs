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
