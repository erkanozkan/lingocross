using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Words.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Words;

public class WordService : IWordService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;

    public WordService(IAppDbContext db, ICurrentUser currentUser)
    {
        _db = db;
        _currentUser = currentUser;
    }

    public async Task<IReadOnlyList<WordDto>> ListByLessonAsync(Guid lessonId, CancellationToken cancellationToken = default)
    {
        await EnsureLessonReadableAsync(lessonId, cancellationToken);

        var words = await _db.Words
            .Where(w => w.LessonId == lessonId)
            .Include(w => w.Translations)
            .Include(w => w.Synonyms)
            .OrderBy(w => w.SortOrder)
            .ThenBy(w => w.CreatedAt)
            .ToListAsync(cancellationToken);

        return words.Select(ToDto).ToList();
    }

    public async Task<WordDto> AddAsync(Guid lessonId, AddWordRequest request, CancellationToken cancellationToken = default)
    {
        await EnsureLessonOwnedAsync(lessonId, cancellationToken);

        var sortOrder = request.SortOrder
            ?? (await _db.Words.Where(w => w.LessonId == lessonId).MaxAsync(w => (int?)w.SortOrder, cancellationToken) ?? -1) + 1;

        var word = new Word
        {
            LessonId = lessonId,
            Term = request.Term.Trim(),
            SortOrder = sortOrder,
            Source = request.Source ?? WordSource.Manual,
        };

        ApplyTranslations(word, request.Translations);
        ApplySynonyms(word, request.Synonyms);

        _db.Words.Add(word);
        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(word);
    }

    public async Task<WordDto> UpdateAsync(Guid wordId, UpdateWordRequest request, CancellationToken cancellationToken = default)
    {
        var word = await _db.Words
            .Include(w => w.Translations)
            .Include(w => w.Synonyms)
            .FirstOrDefaultAsync(w => w.Id == wordId, cancellationToken);

        if (word is null)
        {
            throw AppException.NotFound("Kelime bulunamadı.");
        }

        await EnsureLessonOwnedAsync(word.LessonId, cancellationToken);

        word.Term = request.Term.Trim();
        if (request.SortOrder is { } order)
        {
            word.SortOrder = order;
        }
        if (request.Source is { } source)
        {
            word.Source = source;
        }

        // Çeviri ve eşanlamları tamamen yenisiyle değiştir (idempotent payload).
        word.Translations.Clear();
        word.Synonyms.Clear();
        ApplyTranslations(word, request.Translations);
        ApplySynonyms(word, request.Synonyms);

        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(word);
    }

    public async Task DeleteAsync(Guid wordId, CancellationToken cancellationToken = default)
    {
        var word = await _db.Words.FirstOrDefaultAsync(w => w.Id == wordId, cancellationToken);
        if (word is null)
        {
            throw AppException.NotFound("Kelime bulunamadı.");
        }

        await EnsureLessonOwnedAsync(word.LessonId, cancellationToken);

        _db.Words.Remove(word);
        await _db.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Dersin var olduğunu ve oturum açan öğretmene ait olduğunu doğrular; aksi halde 404
    /// (varlığı sızdırmamak için). Öğretmen olmayan rol 403 alır.
    /// </summary>
    private async Task EnsureLessonOwnedAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Teacher)
        {
            throw new AppException(403, "Bu işlem için öğretmen yetkisi gerekir.");
        }

        var lesson = await _db.Lessons.FirstOrDefaultAsync(l => l.Id == lessonId, cancellationToken);
        if (lesson is null || lesson.TeacherId != userId)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }
    }

    /// <summary>
    /// Rol-duyarlı okuma erişimi: öğretmen kendi dersinin kelimelerini, öğrenci yalnız Active
    /// eşleşmesi olan öğretmenin yayımlanmış dersinin kelimelerini görebilir. Aksi 404.
    /// </summary>
    private async Task EnsureLessonReadableAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        var lesson = await _db.Lessons.FirstOrDefaultAsync(l => l.Id == lessonId, cancellationToken);
        if (lesson is null)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        if (_currentUser.Role == UserRole.Teacher)
        {
            if (lesson.TeacherId != userId)
            {
                throw AppException.NotFound("Ders bulunamadı.");
            }

            return;
        }

        var hasAccess = lesson.IsPublished && await _db.Enrollments.AnyAsync(
            e => e.StudentId == userId
                && e.TeacherId == lesson.TeacherId
                && e.Status == EnrollmentStatus.Active,
            cancellationToken);

        if (!hasAccess)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }
    }

    private static void ApplyTranslations(Word word, IReadOnlyList<TranslationPayload> payload)
    {
        var translations = (payload ?? Array.Empty<TranslationPayload>())
            .Where(t => !string.IsNullOrWhiteSpace(t.Text))
            .Select(t => new WordTranslation { Text = t.Text.Trim(), IsPrimary = t.IsPrimary })
            .ToList();

        // En çok bir primary olmalı; hiç işaretlenmemişse ilkini primary yap.
        if (translations.Count > 0 && translations.Count(t => t.IsPrimary) == 0)
        {
            translations[0].IsPrimary = true;
        }
        else if (translations.Count(t => t.IsPrimary) > 1)
        {
            var seen = false;
            foreach (var t in translations)
            {
                if (t.IsPrimary && seen)
                {
                    t.IsPrimary = false;
                }
                else if (t.IsPrimary)
                {
                    seen = true;
                }
            }
        }

        foreach (var t in translations)
        {
            word.Translations.Add(t);
        }
    }

    private static void ApplySynonyms(Word word, IReadOnlyList<string>? payload)
    {
        foreach (var s in payload ?? Array.Empty<string>())
        {
            if (!string.IsNullOrWhiteSpace(s))
            {
                word.Synonyms.Add(new WordSynonym { Text = s.Trim() });
            }
        }
    }

    private static WordDto ToDto(Word w)
        => new(
            w.Id,
            w.LessonId,
            w.Term,
            w.SortOrder,
            w.Source,
            w.Translations
                .OrderByDescending(t => t.IsPrimary)
                .ThenBy(t => t.CreatedAt)
                .Select(t => new TranslationDto(t.Id, t.Text, t.IsPrimary))
                .ToList(),
            w.Synonyms
                .OrderBy(s => s.CreatedAt)
                .Select(s => new SynonymDto(s.Id, s.Text))
                .ToList(),
            w.CreatedAt,
            w.UpdatedAt);
}
