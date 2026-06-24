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
