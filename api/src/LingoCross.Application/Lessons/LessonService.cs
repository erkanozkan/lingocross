using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Lessons.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Lessons;

public class LessonService : ILessonService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;

    public LessonService(IAppDbContext db, ICurrentUser currentUser)
    {
        _db = db;
        _currentUser = currentUser;
    }

    public async Task<LessonDto> CreateAsync(CreateLessonRequest request, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        var lesson = new Lesson
        {
            TeacherId = teacherId,
            Title = request.Title.Trim(),
            Description = string.IsNullOrWhiteSpace(request.Description) ? null : request.Description.Trim(),
            SourceLanguage = NormalizeLang(request.SourceLanguage, "en"),
            TargetLanguage = NormalizeLang(request.TargetLanguage, "tr"),
            IsPublished = false,
        };

        _db.Lessons.Add(lesson);
        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(lesson, wordCount: 0);
    }

    public async Task<IReadOnlyList<LessonDto>> ListMineAsync(CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        var lessons = await _db.Lessons
            .Where(l => l.TeacherId == teacherId)
            .OrderByDescending(l => l.CreatedAt)
            .Select(l => new LessonDto(
                l.Id,
                l.TeacherId,
                l.Title,
                l.Description,
                l.SourceLanguage,
                l.TargetLanguage,
                l.IsPublished,
                l.Words.Count,
                l.CreatedAt,
                l.UpdatedAt))
            .ToListAsync(cancellationToken);

        return lessons;
    }

    public async Task<IReadOnlyList<LessonDto>> ListVisibleAsync(CancellationToken cancellationToken = default)
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        // Öğretmen davranışı değişmez: kendi tüm dersleri.
        if (_currentUser.Role == UserRole.Teacher)
        {
            return await ListMineAsync(cancellationToken);
        }

        // Öğrenci: Active eşleşmesi olan öğretmenlerin yayımlanmış dersleri.
        var lessons = await _db.Lessons
            .Where(l => l.IsPublished
                && _db.Enrollments.Any(e =>
                    e.StudentId == userId
                    && e.TeacherId == l.TeacherId
                    && e.Status == EnrollmentStatus.Active))
            .OrderByDescending(l => l.CreatedAt)
            .Select(l => new LessonDto(
                l.Id,
                l.TeacherId,
                l.Title,
                l.Description,
                l.SourceLanguage,
                l.TargetLanguage,
                l.IsPublished,
                l.Words.Count,
                l.CreatedAt,
                l.UpdatedAt))
            .ToListAsync(cancellationToken);

        return lessons;
    }

    public async Task<LessonDto> GetAsync(Guid lessonId, CancellationToken cancellationToken = default)
    {
        var lesson = await GetAccessibleLessonAsync(lessonId, cancellationToken);
        var wordCount = await _db.Words.CountAsync(w => w.LessonId == lesson.Id, cancellationToken);
        return ToDto(lesson, wordCount);
    }

    public async Task<LessonDto> UpdateAsync(Guid lessonId, UpdateLessonRequest request, CancellationToken cancellationToken = default)
    {
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);

        lesson.Title = request.Title.Trim();
        lesson.Description = string.IsNullOrWhiteSpace(request.Description) ? null : request.Description.Trim();
        lesson.SourceLanguage = NormalizeLang(request.SourceLanguage, lesson.SourceLanguage);
        lesson.TargetLanguage = NormalizeLang(request.TargetLanguage, lesson.TargetLanguage);

        await _db.SaveChangesAsync(cancellationToken);

        var wordCount = await _db.Words.CountAsync(w => w.LessonId == lesson.Id, cancellationToken);
        return ToDto(lesson, wordCount);
    }

    public async Task DeleteAsync(Guid lessonId, CancellationToken cancellationToken = default)
    {
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);
        _db.Lessons.Remove(lesson);
        await _db.SaveChangesAsync(cancellationToken);
    }

    public async Task<LessonDto> PublishAsync(Guid lessonId, CancellationToken cancellationToken = default)
    {
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);

        var wordCount = await _db.Words.CountAsync(w => w.LessonId == lesson.Id, cancellationToken);
        if (wordCount == 0)
        {
            throw AppException.BadRequest("Boş bir ders yayımlanamaz; önce kelime ekleyin.");
        }

        lesson.IsPublished = true;
        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(lesson, wordCount);
    }

    /// <summary>
    /// Dersi getirir ve sahiplik kontrolü yapar. Başkasının dersi de dahil olmak üzere bulunamayan
    /// her durumda 404 döner (varlığın sızdırılmaması için 403 yerine 404).
    /// </summary>
    private async Task<Lesson> GetOwnedLessonAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        var teacherId = RequireTeacher();

        var lesson = await _db.Lessons.FirstOrDefaultAsync(l => l.Id == lessonId, cancellationToken);
        if (lesson is null || lesson.TeacherId != teacherId)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        return lesson;
    }

    /// <summary>
    /// Rol-duyarlı okuma erişimi: öğretmen kendi dersine, öğrenci yalnız Active eşleşmesi olan
    /// öğretmenin yayımlanmış dersine erişebilir. Aksi her durumda 404 (varlığı sızdırmamak için).
    /// </summary>
    private async Task<Lesson> GetAccessibleLessonAsync(Guid lessonId, CancellationToken cancellationToken)
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

            return lesson;
        }

        // Öğrenci: ders yayımlanmış olmalı ve öğretmenle Active eşleşme bulunmalı.
        var hasAccess = lesson.IsPublished && await _db.Enrollments.AnyAsync(
            e => e.StudentId == userId
                && e.TeacherId == lesson.TeacherId
                && e.Status == EnrollmentStatus.Active,
            cancellationToken);

        if (!hasAccess)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        return lesson;
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

    private static string NormalizeLang(string? value, string fallback)
        => string.IsNullOrWhiteSpace(value) ? fallback : value.Trim().ToLowerInvariant();

    private static LessonDto ToDto(Lesson l, int wordCount)
        => new(l.Id, l.TeacherId, l.Title, l.Description, l.SourceLanguage, l.TargetLanguage,
            l.IsPublished, wordCount, l.CreatedAt, l.UpdatedAt);
}
