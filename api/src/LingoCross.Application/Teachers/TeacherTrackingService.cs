using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Teachers.Dtos;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Teachers;

/// <summary>
/// Öğretmen takip görünümü (F2.3). Öğretmen yalnızca kendi Active eşleşmeli öğrencilerinin,
/// yalnızca paylaşılmış sonuçlarını görür. Yeni tablo yoktur; mevcut entity'ler join'lenir.
/// </summary>
public class TeacherTrackingService : ITeacherTrackingService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;

    public TeacherTrackingService(IAppDbContext db, ICurrentUser currentUser)
    {
        _db = db;
        _currentUser = currentUser;
    }

    public async Task<IReadOnlyList<StudentSummaryDto>> ListMyStudentsAsync(CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Bu öğretmenin Active eşleşmeli öğrencileri (öğrenci başına özet).
        var students = await _db.Enrollments
            .Where(e => e.TeacherId == teacherId && e.Status == EnrollmentStatus.Active)
            .Select(e => new { e.StudentId, e.Student.DisplayName })
            .ToListAsync(cancellationToken);

        if (students.Count == 0)
        {
            return [];
        }

        var studentIds = students.Select(s => s.StudentId).ToList();

        // Yalnız bu öğretmenin Active öğrencilerinin PAYLAŞILMIŞ sonuçları üzerinden öğrenci başına özet.
        // Gizlilik: shared_with_teacher=false sonuçlar tamamen dışarıda.
        var summaries = await _db.GameResults
            .Where(r => r.SharedWithTeacher
                && studentIds.Contains(r.Session.StudentId))
            .GroupBy(r => r.Session.StudentId)
            .Select(g => new
            {
                StudentId = g.Key,
                Count = g.Count(),
                AverageScore = g.Average(r => (double)r.Score),
                LastActivityAt = g.Max(r => r.SharedAt),
            })
            .ToListAsync(cancellationToken);

        var byStudent = summaries.ToDictionary(s => s.StudentId);

        return students
            .Select(s =>
            {
                byStudent.TryGetValue(s.StudentId, out var summary);
                return new StudentSummaryDto(
                    s.StudentId,
                    s.DisplayName,
                    summary?.Count ?? 0,
                    summary is null
                        ? null
                        : (int)Math.Round(summary.AverageScore, MidpointRounding.AwayFromZero),
                    summary?.LastActivityAt);
            })
            .OrderBy(s => s.DisplayName, StringComparer.OrdinalIgnoreCase)
            .ToList();
    }

    public async Task<IReadOnlyList<SharedResultDto>> GetStudentSharedResultsAsync(
        Guid studentId, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Öğrenci bu öğretmene Active eşleşmeli değilse varlığı sızdırmamak için 404.
        var enrolled = await _db.Enrollments.AnyAsync(
            e => e.TeacherId == teacherId
                && e.StudentId == studentId
                && e.Status == EnrollmentStatus.Active,
            cancellationToken);

        if (!enrolled)
        {
            throw AppException.NotFound("Öğrenci bulunamadı.");
        }

        // Yalnız bu öğrencinin paylaşılmış sonuçları, yeniden eskiye.
        var rows = await _db.GameResults
            .Where(r => r.SharedWithTeacher && r.Session.StudentId == studentId)
            .OrderByDescending(r => r.SharedAt)
            .ThenByDescending(r => r.CreatedAt)
            .Select(r => new SharedResultDto(
                r.Id,
                r.Session.Game.Lesson.Title,
                r.Session.Game.Type,
                r.Score,
                r.DurationMs,
                r.TotalItems,
                r.CorrectItems,
                r.SharedAt,
                r.CreatedAt))
            .ToListAsync(cancellationToken);

        return rows;
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
