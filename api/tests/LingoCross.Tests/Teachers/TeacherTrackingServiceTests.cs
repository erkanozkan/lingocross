using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Teachers;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Teachers;

/// <summary>
/// F2.3 — Öğretmen takip (öğretmen tarafı): yalnız Active eşleşmeli öğrenciler listelenir;
/// özet sayıları/ortalama yalnız paylaşılan sonuçlar üzerinden hesaplanır (paylaşılmamış sızmaz);
/// öğrenci sonuç görünümü yalnız paylaşılmış sonuçları döndürür ve enrolled olmayan/başka
/// öğretmenin öğrencisi → 404; öğretmen-only (öğrenci → 403).
/// </summary>
public class TeacherTrackingServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"teacher-tracking-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email, string displayName)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = displayName, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    /// <summary>
    /// F4.3: Öğretmen takibi artık sınıf üyeliğinden türetilir. Bu yardımcı, geriye dönük test
    /// niyetini korur: Active → öğretmenin bir sınıfına Active üye; Pending/Rejected → üyelik YOK
    /// (öğrenci öğretmenin sınıfında değil → takip dışı). Enrollment kaydı da geri-uyum için yazılır.
    /// </summary>
    private static async Task SeedEnrollmentAsync(
        AppDbContext db, Guid teacherId, Guid studentId, EnrollmentStatus status)
    {
        db.Enrollments.Add(new Enrollment { TeacherId = teacherId, StudentId = studentId, Status = status });
        await db.SaveChangesAsync();

        if (status == EnrollmentStatus.Active)
        {
            var klass = new Class { TeacherId = teacherId, Name = "Sınıf", InviteCode = $"T{Guid.NewGuid():N}"[..8].ToUpperInvariant() };
            db.Classes.Add(klass);
            await db.SaveChangesAsync();
            db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = studentId, Status = ClassMemberStatus.Active });
            await db.SaveChangesAsync();
        }
    }

    /// <summary>Ders + oyun + tamamlanmış oturum + sonuç seed eder; istenirse paylaşılmış işaretler.</summary>
    private static async Task<GameResult> SeedResultAsync(
        AppDbContext db, Guid teacherId, Guid studentId,
        int total, int correct, bool shared, DateTime? sharedAt = null)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = true };
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var game = new Game { LessonId = lesson.Id, Type = GameType.WordMatching, Title = "Kelime Eşleştirme" };
        db.Games.Add(game);
        await db.SaveChangesAsync();

        var session = new GameSession
        {
            GameId = game.Id,
            StudentId = studentId,
            Status = GameSessionStatus.Completed,
            StartedAt = DateTime.UtcNow,
            CompletedAt = DateTime.UtcNow,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();

        var result = new GameResult
        {
            SessionId = session.Id,
            DurationMs = 1000,
            TotalItems = total,
            CorrectItems = correct,
            Score = total <= 0 ? 0 : (int)Math.Round(correct * 100.0 / total, MidpointRounding.AwayFromZero),
            SharedWithTeacher = shared,
            SharedAt = shared ? (sharedAt ?? DateTime.UtcNow) : null,
        };
        db.GameResults.Add(result);
        await db.SaveChangesAsync();
        return result;
    }

    /// <summary>Verilen sonuca, Ordinal'ları KARIŞIK gelen kelime kalemleri ekler (F7.5).</summary>
    private static async Task SeedResultItemsAsync(AppDbContext db, Guid resultId)
    {
        db.GameResultItems.AddRange(
            new GameResultItem { ResultId = resultId, Ordinal = 2, Term = "bird", ExpectedAnswer = "kuş", StudentAnswer = "kuş", IsCorrect = true },
            new GameResultItem { ResultId = resultId, Ordinal = 0, Term = "cat", ExpectedAnswer = "kedi", StudentAnswer = "kedi", IsCorrect = true },
            new GameResultItem { ResultId = resultId, Ordinal = 1, Term = "dog", ExpectedAnswer = "köpek", StudentAnswer = null, IsCorrect = false });
        await db.SaveChangesAsync();
    }

    // ---- ListMyStudents ----

    [Fact]
    public async Task ListMyStudents_ReturnsOnlyActiveStudents_WithSharedSummary()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var active = await SeedUserAsync(db, UserRole.Student, "a@x.com", "Active Ali");
        var pending = await SeedUserAsync(db, UserRole.Student, "p@x.com", "Pending Pelin");

        await SeedEnrollmentAsync(db, teacher.Id, active.Id, EnrollmentStatus.Active);
        await SeedEnrollmentAsync(db, teacher.Id, pending.Id, EnrollmentStatus.Pending);

        // active: iki paylaşılmış (score 100, 50 → ort 75) + bir paylaşılmamış (sayılmamalı).
        await SeedResultAsync(db, teacher.Id, active.Id, 8, 8, shared: true, sharedAt: DateTime.UtcNow.AddHours(-2));
        var newest = await SeedResultAsync(db, teacher.Id, active.Id, 8, 4, shared: true, sharedAt: DateTime.UtcNow.AddHours(-1));
        await SeedResultAsync(db, teacher.Id, active.Id, 8, 2, shared: false);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var students = await svc.ListMyStudentsAsync();

        // Yalnız Active öğrenci listelenir (Pending dışarıda).
        Assert.Single(students);
        var dto = students[0];
        Assert.Equal(active.Id, dto.StudentId);
        Assert.Equal("Active Ali", dto.DisplayName);
        Assert.Equal(2, dto.SharedResultsCount);            // paylaşılmamış sonuç sayılmadı
        Assert.Equal(75, dto.AverageScore);                  // (100+50)/2
        Assert.Equal(newest.SharedAt, dto.LastActivityAt);   // en son paylaşılan
    }

    [Fact]
    public async Task ListMyStudents_ActiveStudentWithNoSharedResults_HasZeroCountNullAverage()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");
        await SeedEnrollmentAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        // Sadece paylaşılmamış sonuç var.
        await SeedResultAsync(db, teacher.Id, student.Id, 8, 8, shared: false);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var students = await svc.ListMyStudentsAsync();

        Assert.Single(students);
        Assert.Equal(0, students[0].SharedResultsCount);
        Assert.Null(students[0].AverageScore);
        Assert.Null(students[0].LastActivityAt);
    }

    [Fact]
    public async Task ListMyStudents_DoesNotLeakOtherTeachersStudents()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com", "T1");
        var otherTeacher = await SeedUserAsync(db, UserRole.Teacher, "t2@x.com", "T2");
        var mine = await SeedUserAsync(db, UserRole.Student, "m@x.com", "Mine");
        var theirs = await SeedUserAsync(db, UserRole.Student, "o@x.com", "Theirs");

        await SeedEnrollmentAsync(db, teacher.Id, mine.Id, EnrollmentStatus.Active);
        await SeedEnrollmentAsync(db, otherTeacher.Id, theirs.Id, EnrollmentStatus.Active);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var students = await svc.ListMyStudentsAsync();

        Assert.Single(students);
        Assert.Equal(mine.Id, students[0].StudentId);
    }

    [Fact]
    public async Task ListMyStudents_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");

        var svc = new TeacherTrackingService(db, TestCurrentUser.Student(student.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ListMyStudentsAsync());
        Assert.Equal(403, ex.StatusCode);
    }

    // ---- GetStudentSharedResults ----

    [Fact]
    public async Task GetStudentSharedResults_ReturnsOnlyShared_NewestFirst()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");
        await SeedEnrollmentAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var older = await SeedResultAsync(db, teacher.Id, student.Id, 8, 8, shared: true, sharedAt: DateTime.UtcNow.AddHours(-3));
        var newer = await SeedResultAsync(db, teacher.Id, student.Id, 8, 4, shared: true, sharedAt: DateTime.UtcNow.AddHours(-1));
        await SeedResultAsync(db, teacher.Id, student.Id, 8, 2, shared: false); // paylaşılmamış sızmamalı

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var results = await svc.GetStudentSharedResultsAsync(student.Id);

        Assert.Equal(2, results.Count);
        Assert.Equal(newer.Id, results[0].ResultId); // yeniden eskiye
        Assert.Equal(older.Id, results[1].ResultId);
        Assert.All(results, r => Assert.Equal("Ders", r.LessonTitle));
        Assert.Equal(GameType.WordMatching, results[0].GameType);
    }

    [Fact]
    public async Task GetStudentSharedResults_NotEnrolledStudent_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var stranger = await SeedUserAsync(db, UserRole.Student, "x@x.com", "Stranger");

        // Hiç eşleşme yok.
        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetStudentSharedResultsAsync(stranger.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetStudentSharedResults_PendingEnrollment_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");
        await SeedEnrollmentAsync(db, teacher.Id, student.Id, EnrollmentStatus.Pending);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetStudentSharedResultsAsync(student.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetStudentSharedResults_OtherTeachersStudent_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com", "T1");
        var otherTeacher = await SeedUserAsync(db, UserRole.Teacher, "t2@x.com", "T2");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");

        // Öğrenci yalnızca DİĞER öğretmene Active eşleşmeli.
        await SeedEnrollmentAsync(db, otherTeacher.Id, student.Id, EnrollmentStatus.Active);
        await SeedResultAsync(db, otherTeacher.Id, student.Id, 8, 8, shared: true);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetStudentSharedResultsAsync(student.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetStudentSharedResults_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");

        var svc = new TeacherTrackingService(db, TestCurrentUser.Student(student.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetStudentSharedResultsAsync(student.Id));
        Assert.Equal(403, ex.StatusCode);
    }

    // ---- GetStudentResultDetail (F7.5) ----

    [Fact]
    public async Task GetStudentResultDetail_ReturnsItems_OrderedByOrdinal()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");
        await SeedEnrollmentAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var result = await SeedResultAsync(db, teacher.Id, student.Id, 3, 2, shared: true);
        await SeedResultItemsAsync(db, result.Id);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var detail = await svc.GetStudentResultDetailAsync(student.Id, result.Id);

        Assert.Equal(result.Id, detail.ResultId);
        Assert.Equal("Sema", detail.StudentDisplayName);
        Assert.Equal("Ders", detail.LessonTitle);
        Assert.Equal(GameType.WordMatching, detail.GameType);
        Assert.Equal(3, detail.TotalItems);
        Assert.Equal(2, detail.CorrectItems);

        Assert.Equal(3, detail.Items.Count);
        // Ordinal sırasıyla: 0=cat, 1=dog, 2=bird.
        Assert.Equal(new[] { 0, 1, 2 }, detail.Items.Select(i => i.Ordinal).ToArray());
        Assert.Equal("cat", detail.Items[0].Term);
        Assert.Equal("dog", detail.Items[1].Term);
        Assert.Null(detail.Items[1].StudentAnswer);
        Assert.False(detail.Items[1].IsCorrect);
        Assert.Equal("bird", detail.Items[2].Term);
    }

    [Fact]
    public async Task GetStudentResultDetail_LegacyResultWithoutItems_ReturnsEmptyList()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");
        await SeedEnrollmentAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var result = await SeedResultAsync(db, teacher.Id, student.Id, 8, 8, shared: true);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var detail = await svc.GetStudentResultDetailAsync(student.Id, result.Id);

        Assert.Empty(detail.Items);
    }

    [Fact]
    public async Task GetStudentResultDetail_UnsharedResult_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");
        await SeedEnrollmentAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        // Sonuç var ama paylaşılmamış → 404.
        var result = await SeedResultAsync(db, teacher.Id, student.Id, 8, 8, shared: false);
        await SeedResultItemsAsync(db, result.Id);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.GetStudentResultDetailAsync(student.Id, result.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetStudentResultDetail_NotEnrolledStudent_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var stranger = await SeedUserAsync(db, UserRole.Student, "x@x.com", "Stranger");

        // Stranger öğretmene eşleşmeli değil ama paylaşılmış sonucu var.
        var result = await SeedResultAsync(db, teacher.Id, stranger.Id, 8, 8, shared: true);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.GetStudentResultDetailAsync(stranger.Id, result.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetStudentResultDetail_OtherTeachersStudent_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com", "T1");
        var otherTeacher = await SeedUserAsync(db, UserRole.Teacher, "t2@x.com", "T2");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");

        // Öğrenci yalnızca DİĞER öğretmene Active eşleşmeli.
        await SeedEnrollmentAsync(db, otherTeacher.Id, student.Id, EnrollmentStatus.Active);
        var result = await SeedResultAsync(db, otherTeacher.Id, student.Id, 8, 8, shared: true);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.GetStudentResultDetailAsync(student.Id, result.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetStudentResultDetail_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");

        var svc = new TeacherTrackingService(db, TestCurrentUser.Student(student.Id));
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.GetStudentResultDetailAsync(student.Id, Guid.NewGuid()));
        Assert.Equal(403, ex.StatusCode);
    }
}
