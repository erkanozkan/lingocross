using LingoCross.Application.Admin.Dtos;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Admin;

/// <summary>
/// Faz 2 — ÖSYM resmi soru bankasının toplu, idempotent (slug) import'u. Tüm yazma tek bir transaction
/// içinde yapılır; herhangi bir soru doğrulamayı geçemezse (tam 5 şık + tam 1 doğru değilse) AppException(400)
/// atılır ve transaction commit edilmediği için hiçbir değişiklik kalıcı olmaz.
/// </summary>
public class QuestionImportService : IQuestionImportService
{
    /// <summary>Her sorunun zorunlu şık sayısı (ÖSYM A–E).</summary>
    public const int OptionsPerQuestion = 5;

    private readonly IAppDbContext _db;

    public QuestionImportService(IAppDbContext db)
    {
        _db = db;
    }

    public async Task<QuestionImportResultDto> ImportAsync(
        ImportQuestionTopicRequest request, CancellationToken cancellationToken = default)
    {
        ValidatePayload(request);

        var slug = request.Slug.Trim();

        await using var transaction = await _db.BeginTransactionAsync(cancellationToken);

        // Slug ile idempotent: mevcut başlığı (sorularıyla) çek; yoksa oluştur.
        var topic = await _db.QuestionTopics
            .Include(t => t.Questions)
            .ThenInclude(q => q.Options)
            .FirstOrDefaultAsync(t => t.Slug == slug, cancellationToken);

        if (topic is null)
        {
            topic = new QuestionTopic { Slug = slug };
            _db.QuestionTopics.Add(topic);
        }

        topic.Title = request.Title.Trim();
        topic.Description = string.IsNullOrWhiteSpace(request.Description) ? null : request.Description.Trim();
        topic.IsActive = request.IsActive;
        topic.SortOrder = request.SortOrder;

        // Soruları yeniden yaz: mevcut sorular (şıkları cascade) silinir, yenileri eklenir. Bu, import'u
        // tam-yenileme (replace) semantiğiyle idempotent yapar.
        if (topic.Questions.Count > 0)
        {
            _db.Questions.RemoveRange(topic.Questions);
            topic.Questions.Clear();
        }

        var ordinal = 0;
        foreach (var q in request.Questions)
        {
            var question = new Question
            {
                Stem = q.Stem.Trim(),
                Explanation = string.IsNullOrWhiteSpace(q.Explanation) ? null : q.Explanation.Trim(),
                SourceRef = string.IsNullOrWhiteSpace(q.SourceRef) ? null : q.SourceRef.Trim(),
                Ordinal = ordinal++,
            };

            foreach (var o in q.Options.OrderBy(o => o.Position))
            {
                question.Options.Add(new QuestionOption
                {
                    Position = o.Position,
                    Text = o.Text.Trim(),
                    IsCorrect = o.IsCorrect,
                });
            }

            topic.Questions.Add(question);
        }

        await _db.SaveChangesAsync(cancellationToken);
        await transaction.CommitAsync(cancellationToken);

        return new QuestionImportResultDto(topic.Id, topic.Slug, request.Questions.Count);
    }

    public async Task<IReadOnlyList<AdminQuestionTopicDto>> ListTopicsAsync(CancellationToken cancellationToken = default)
    {
        return await _db.QuestionTopics
            .OrderBy(t => t.SortOrder)
            .ThenBy(t => t.Title)
            .Select(t => new AdminQuestionTopicDto(
                t.Id,
                t.Slug,
                t.Title,
                t.Description,
                t.IsActive,
                t.SortOrder,
                t.Questions.Count))
            .ToListAsync(cancellationToken);
    }

    /// <summary>
    /// İçerik doğrulaması: başlık/slug dolu, en az 1 soru; her soru tam 5 şık, şık pozisyonları 0..4
    /// (benzersiz), tam 1 doğru şık. Aksi halde AppException(400). FluentValidation üst seviye yapıyı
    /// (boş alanlar) yakalar; burada iş-kuralı invariant'ı (5/1) garanti edilir.
    /// </summary>
    private static void ValidatePayload(ImportQuestionTopicRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Slug) || string.IsNullOrWhiteSpace(request.Title))
        {
            throw AppException.BadRequest("Konu başlığı ve slug zorunludur.");
        }

        if (request.Questions is null || request.Questions.Count == 0)
        {
            throw AppException.BadRequest("En az bir soru gerekir.");
        }

        for (var i = 0; i < request.Questions.Count; i++)
        {
            var q = request.Questions[i];
            var label = $"Soru {i + 1}";

            if (string.IsNullOrWhiteSpace(q.Stem))
            {
                throw AppException.BadRequest($"{label}: soru kökü boş olamaz.");
            }

            if (q.Options is null || q.Options.Count != OptionsPerQuestion)
            {
                throw AppException.BadRequest($"{label}: tam {OptionsPerQuestion} şık olmalıdır.");
            }

            var positions = q.Options.Select(o => o.Position).ToHashSet();
            if (positions.Count != OptionsPerQuestion
                || q.Options.Any(o => o.Position < 0 || o.Position >= OptionsPerQuestion))
            {
                throw AppException.BadRequest($"{label}: şık pozisyonları 0..{OptionsPerQuestion - 1} arası ve benzersiz olmalıdır.");
            }

            if (q.Options.Any(o => string.IsNullOrWhiteSpace(o.Text)))
            {
                throw AppException.BadRequest($"{label}: şık metni boş olamaz.");
            }

            if (q.Options.Count(o => o.IsCorrect) != 1)
            {
                throw AppException.BadRequest($"{label}: tam bir doğru şık olmalıdır.");
            }
        }
    }
}
