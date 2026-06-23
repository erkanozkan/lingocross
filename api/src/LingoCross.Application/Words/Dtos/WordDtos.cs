using LingoCross.Domain.Enums;

namespace LingoCross.Application.Words.Dtos;

/// <summary>Bir kelimenin çeviri/eşanlam yükü ile birlikte eklenmesi.</summary>
public record AddWordRequest(
    string Term,
    int? SortOrder,
    WordSource? Source,
    IReadOnlyList<TranslationPayload> Translations,
    IReadOnlyList<string>? Synonyms);

/// <summary>Bir kelimenin tüm alanlarının (çeviri/eşanlam dahil) yerine konması.</summary>
public record UpdateWordRequest(
    string Term,
    int? SortOrder,
    WordSource? Source,
    IReadOnlyList<TranslationPayload> Translations,
    IReadOnlyList<string>? Synonyms);

public record TranslationPayload(string Text, bool IsPrimary);

public record WordDto(
    Guid Id,
    Guid LessonId,
    string Term,
    int SortOrder,
    WordSource Source,
    IReadOnlyList<TranslationDto> Translations,
    IReadOnlyList<SynonymDto> Synonyms,
    DateTime CreatedAt,
    DateTime UpdatedAt);

public record TranslationDto(Guid Id, string Text, bool IsPrimary);

public record SynonymDto(Guid Id, string Text);
