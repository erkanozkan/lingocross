namespace LingoCross.Application.Lessons.Dtos;

/// <summary>Ders oluşturma isteği. Diller verilmezse en→tr varsayılır.</summary>
public record CreateLessonRequest(
    string Title,
    string? Description,
    string? SourceLanguage,
    string? TargetLanguage);

/// <summary>Ders güncelleme isteği (yayımlama durumu ayrı uçtan yönetilir).</summary>
public record UpdateLessonRequest(
    string Title,
    string? Description,
    string? SourceLanguage,
    string? TargetLanguage);

public record LessonDto(
    Guid Id,
    Guid TeacherId,
    string Title,
    string? Description,
    string SourceLanguage,
    string TargetLanguage,
    bool IsPublished,
    int WordCount,
    DateTime CreatedAt,
    DateTime UpdatedAt);
