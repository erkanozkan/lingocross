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

        // F4.3: öğretmenin sınıflarındaki DISTINCT Active öğrenciler (öğrenci başına özet).
        var students = await _db.ClassMembers
            .Where(m => m.Status == ClassMemberStatus.Active
                && m.Class.TeacherId == teacherId
                && !m.Class.IsArchived)
            .Select(m => new { m.StudentId, m.Student.DisplayName })
            .Distinct()
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

        // F4.3: öğrenci öğretmenin sınıflarından birinde Active üye değilse 404 (varlığı sızdırmamak için).
        var enrolled = await _db.ClassMembers.AnyAsync(
            m => m.Status == ClassMemberStatus.Active
                && m.Class.TeacherId == teacherId
                && !m.Class.IsArchived
                && m.StudentId == studentId,
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

    public async Task<TeacherStatsDto> GetMyStatsAsync(CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();
        var weekAgo = DateTime.UtcNow.AddDays(-7);

        // Arşivlenmemiş sınıflar.
        var classCount = await _db.Classes
            .CountAsync(c => c.TeacherId == teacherId && !c.IsArchived, cancellationToken);

        // Sınıflarındaki distinct Active öğrenci.
        var studentCount = await _db.ClassMembers
            .Where(m => m.Status == ClassMemberStatus.Active
                && m.Class.TeacherId == teacherId
                && !m.Class.IsArchived)
            .Select(m => m.StudentId)
            .Distinct()
            .CountAsync(cancellationToken);

        // Bu hafta yapılan atamalar: her atama için hedef sınıfın distinct Active öğrenci sayısı
        // beklenen tamamlama eder; (oyun × sınıf) üzerinden toplanır.
        var assignmentClassIds = await _db.GameAssignments
            .Where(a => a.Class.TeacherId == teacherId
                && !a.Class.IsArchived
                && a.CreatedAt >= weekAgo)
            .Select(a => a.ClassId)
            .ToListAsync(cancellationToken);

        var weeklyAssignedCount = 0;
        if (assignmentClassIds.Count > 0)
        {
            // Her hedef sınıf için distinct Active öğrenci sayısı (sınıf başına bir kez hesaplanır).
            var activePerClass = await _db.ClassMembers
                .Where(m => m.Status == ClassMemberStatus.Active
                    && assignmentClassIds.Contains(m.ClassId))
                .GroupBy(m => m.ClassId)
                // (class_id, student_id) benzersiz olduğundan üye sayısı = distinct öğrenci sayısı.
                .Select(g => new { ClassId = g.Key, Count = g.Count() })
                .ToListAsync(cancellationToken);

            var countByClass = activePerClass.ToDictionary(x => x.ClassId, x => x.Count);
            // assignmentClassIds her (oyun × sınıf) atamasını ayrı temsil eder; sınıf birden çok
            // atamada görünürse her atama için ayrı beklenti sayılır.
            foreach (var classId in assignmentClassIds)
            {
                weeklyAssignedCount += countByClass.TryGetValue(classId, out var n) ? n : 0;
            }
        }

        // Bu hafta tamamlanan: bu öğretmenin sınıflarına atanmış oyunlara ait, bu hafta tamamlanmış
        // sonuçların distinct (öğrenci, oyun) sayısı.
        var completedPairs = await _db.GameResults
            .Where(r => (r.Session.CompletedAt ?? r.CreatedAt) >= weekAgo
                && r.Session.Game.Assignments.Any(a => a.Class.TeacherId == teacherId && !a.Class.IsArchived))
            .Select(r => new { r.Session.StudentId, r.Session.GameId })
            .Distinct()
            .CountAsync(cancellationToken);

        var completionRate = weeklyAssignedCount > 0
            ? (int)Math.Round(100.0 * completedPairs / weeklyAssignedCount, MidpointRounding.AwayFromZero)
            : 0;

        return new TeacherStatsDto(
            classCount,
            studentCount,
            weeklyAssignedCount,
            completedPairs,
            completionRate);
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
