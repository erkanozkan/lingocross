using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Games;
using LingoCross.Application.QuestionBanks.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.QuestionBanks;

/// <summary>
/// AI ile çoktan seçmeli soru üretip teacher-owned bir <see cref="QuestionTopic"/> olarak kaydeder.
/// Üretici (<see cref="IClaudeQuestionGenerator"/>) ağ çağrısını soyutlar; çıktı bu serviste doğrulanır.
/// </summary>
public class AiQuestionService : IAiQuestionService
{
    /// <summary>Üretilebilecek desteklenen soru türleri.</summary>
    private static readonly HashSet<string> AllowedTypes = new(StringComparer.Ordinal)
    {
        "word_meaning", "fill_blank", "synonym",
    };

    private const int OptionCount = 4;
    private const int MinWords = 4;

    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly IClaudeQuestionGenerator _generator;

    public AiQuestionService(IAppDbContext db, ICurrentUser currentUser, IClaudeQuestionGenerator generator)
    {
        _db = db;
        _currentUser = currentUser;
        _generator = generator;
    }

    public async Task<AiQuestionsResultDto> GenerateAsync(
        Guid lessonId, int grade, int count, IReadOnlyList<string> types, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Girdi doğrulaması (FluentValidation'a ek olarak savunmacı katman).
        if (count is < 1 or > 10)
        {
            throw AppException.BadRequest("Soru sayısı 1 ile 10 arasında olmalıdır.");
        }

        var requestedTypes = (types ?? Array.Empty<string>())
            .Where(t => !string.IsNullOrWhiteSpace(t))
            .Select(t => t.Trim())
            .Distinct(StringComparer.Ordinal)
            .ToList();

        if (requestedTypes.Count == 0 || requestedTypes.Any(t => !AllowedTypes.Contains(t)))
        {
            throw AppException.BadRequest("Geçerli en az bir soru türü seçilmelidir (word_meaning, fill_blank, synonym).");
        }

        // Ders sahibi öğretmen mi? (varlığı sızdırmamak için yoksa 404).
        var lesson = await _db.Lessons
            .AsNoTracking()
            .FirstOrDefaultAsync(l => l.Id == lessonId && l.TeacherId == teacherId, cancellationToken);

        if (lesson is null)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        // Ders kelimelerini (terim + çeviri + eşanlam) yükle.
        var words = await _db.Words
            .AsNoTracking()
            .Where(w => w.LessonId == lessonId)
            .OrderBy(w => w.SortOrder)
            .Select(w => new
            {
                w.Term,
                Translations = w.Translations.Select(tr => tr.Text).ToList(),
                Synonyms = w.Synonyms.Select(s => s.Text).ToList(),
            })
            .ToListAsync(cancellationToken);

        var translatedCount = words.Count(w => w.Translations.Any(t => !string.IsNullOrWhiteSpace(t)));
        if (translatedCount < MinWords)
        {
            throw AppException.BadRequest("Bu ders için yeterli kelime yok (en az 4).");
        }

        var input = new QuestionGenerationInput(
            lesson.Title,
            lesson.Description,
            grade,
            count,
            requestedTypes,
            words
                .Select(w => new QuestionGenerationWord(
                    w.Term,
                    w.Translations.Where(t => !string.IsNullOrWhiteSpace(t)).ToList(),
                    w.Synonyms.Where(s => !string.IsNullOrWhiteSpace(s)).ToList()))
                .ToList());

        // Üret + doğrula; uymazsa 1 kez yeniden dene, yine olmazsa 400.
        var generated = await GenerateValidatedAsync(input, count, requestedTypes, cancellationToken);

        // Kaydet: teacher-owned QuestionTopic + Question'lar + QuestionOption'lar.
        var topic = new QuestionTopic
        {
            Title = $"{lesson.Title} — Sınav ({grade}. sınıf)",
            Slug = $"ai-{Guid.NewGuid():N}"[..11], // ai- + 8 hex
            TeacherId = teacherId,
            LessonId = lessonId,
            Grade = grade,
            IsActive = true,
        };

        var ordinal = 0;
        foreach (var gq in generated)
        {
            var question = new Question
            {
                Stem = gq.Stem.Trim(),
                Explanation = string.IsNullOrWhiteSpace(gq.Explanation) ? null : gq.Explanation.Trim(),
                Kind = gq.Type,
                Ordinal = ordinal++,
            };

            foreach (var opt in gq.Options.OrderBy(o => o.Position))
            {
                question.Options.Add(new QuestionOption
                {
                    Position = opt.Position,
                    Text = opt.Text.Trim(),
                    IsCorrect = opt.IsCorrect,
                });
            }

            topic.Questions.Add(question);
        }

        _db.QuestionTopics.Add(topic);
        await _db.SaveChangesAsync(cancellationToken);

        var questionDtos = topic.Questions
            .OrderBy(q => q.Ordinal)
            .Select(q => new AiQuestionDto(
                q.Id,
                q.Kind ?? string.Empty,
                q.Stem,
                q.Explanation,
                q.Options
                    .OrderBy(o => o.Position)
                    .Select(o => new AiQuestionOptionDto(o.Id, o.Position, o.Text, o.IsCorrect))
                    .ToList()))
            .ToList();

        return new AiQuestionsResultDto(topic.Id, topic.Title, grade, lessonId, questionDtos);
    }

    public async Task DeleteQuestionAsync(Guid topicId, Guid questionId, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Yalnız sahibinin AI başlığındaki soru silinebilir; aksi 404 (varlığı sızdırmamak için).
        var question = await _db.Questions
            .Include(q => q.QuestionTopic)
            .FirstOrDefaultAsync(
                q => q.Id == questionId && q.QuestionTopicId == topicId && q.QuestionTopic.TeacherId == teacherId,
                cancellationToken);

        if (question is null)
        {
            throw AppException.NotFound("Soru bulunamadı.");
        }

        _db.Questions.Remove(question); // Şıklar cascade ile silinir.
        await _db.SaveChangesAsync(cancellationToken);
    }

    private async Task<IReadOnlyList<GeneratedQuestion>> GenerateValidatedAsync(
        QuestionGenerationInput input, int count, IReadOnlyList<string> allowed, CancellationToken cancellationToken)
    {
        for (var attempt = 0; attempt < 2; attempt++)
        {
            var result = await _generator.GenerateAsync(input, cancellationToken);
            if (TryValidate(result, count, allowed, out var valid))
            {
                return valid;
            }
        }

        throw AppException.BadRequest("AI geçerli sorular üretemedi, lütfen tekrar deneyin.");
    }

    private static bool TryValidate(
        GeneratedQuestionsResult result, int count, IReadOnlyList<string> allowed,
        out IReadOnlyList<GeneratedQuestion> valid)
    {
        valid = Array.Empty<GeneratedQuestion>();
        var questions = result?.Questions;
        if (questions is null || questions.Count != count)
        {
            return false;
        }

        var allowedSet = allowed.ToHashSet(StringComparer.Ordinal);
        foreach (var q in questions)
        {
            if (string.IsNullOrWhiteSpace(q.Stem) || string.IsNullOrWhiteSpace(q.Type) || !allowedSet.Contains(q.Type))
            {
                return false;
            }

            var options = q.Options;
            if (options is null || options.Count != OptionCount)
            {
                return false;
            }

            if (options.Count(o => o.IsCorrect) != 1)
            {
                return false;
            }

            // Pozisyonlar 0–3 ve benzersiz; şık metni dolu.
            var positions = options.Select(o => o.Position).OrderBy(p => p).ToList();
            if (!positions.SequenceEqual(Enumerable.Range(0, OptionCount))
                || options.Any(o => string.IsNullOrWhiteSpace(o.Text)))
            {
                return false;
            }
        }

        valid = questions;
        return true;
    }

    private Guid RequireTeacher()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Teacher)
        {
            throw new AppException(403, "Bu işlem için öğretmen yetkisi gerekir.");
        }

        return userId;
    }
}
