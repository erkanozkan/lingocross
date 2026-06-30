using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Subscriptions;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// F8.1 — EntitlementService: premium çözümü (lazy-expiry), Free limitleri ve 402 feature kapıları.
/// </summary>
public class EntitlementServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"entitlement-{Guid.NewGuid()}")
            .Options);

    private static SubscriptionOptions Opts() => new()
    {
        StubEnabled = true,
        FreeMaxClasses = 2,
        FreeMaxLessons = 5,
        FreeMaxTeachers = 1,
        TrialDays = 7,
    };

    private static EntitlementService Svc(AppDbContext db, Guid userId, SubscriptionOptions? opts = null)
        => new(db, TestCurrentUser.Teacher(userId), Options.Create(opts ?? Opts()));

    private static async Task<Guid> SeedUserAsync(AppDbContext db, UserRole role = UserRole.Teacher)
    {
        var u = new User { Email = $"{Guid.NewGuid():N}@x.com", PasswordHash = "x", DisplayName = "U", Role = role };
        db.Users.Add(u);
        await db.SaveChangesAsync();
        return u.Id;
    }

    [Fact]
    public async Task Get_NoSubscriptionRow_IsFree_WithConfiguredLimits()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var snap = await Svc(db, userId).GetAsync(userId);

        Assert.False(snap.IsPremium);
        Assert.Equal(SubscriptionStatus.None, snap.Status);
        // Sınıf/ders/öğretmen kotaları kaldırıldı → Free'de de sınırsız. Tek premium: OCR.
        Assert.Equal(int.MaxValue, snap.MaxClasses);
        Assert.Equal(int.MaxValue, snap.MaxLessons);
        Assert.Equal(int.MaxValue, snap.MaxTeachers);
        // OCR ücreti kaldırıldı → Free'de de açık.
        Assert.True(snap.OcrEnabled);
    }

    [Fact]
    public async Task Get_ActiveFutureSubscription_IsPremium_Unlimited()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        db.Subscriptions.Add(new Subscription
        {
            UserId = userId,
            Plan = SubscriptionPlan.Premium,
            Status = SubscriptionStatus.Active,
            Period = SubscriptionPeriod.Monthly,
            Source = SubscriptionSource.Stub,
            StartedAt = DateTime.UtcNow.AddDays(-1),
            ExpiresAt = DateTime.UtcNow.AddDays(30),
        });
        await db.SaveChangesAsync();

        var snap = await Svc(db, userId).GetAsync(userId);

        Assert.True(snap.IsPremium);
        Assert.Equal(int.MaxValue, snap.MaxClasses);
        Assert.Equal(int.MaxValue, snap.MaxLessons);
        Assert.Equal(int.MaxValue, snap.MaxTeachers);
        Assert.True(snap.OcrEnabled);
    }

    [Fact]
    public async Task Get_ActiveButExpired_LazyExpiry_IsFree()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        // Durum Active olsa bile geçmiş ExpiresAt → premium SAYILMAZ.
        db.Subscriptions.Add(new Subscription
        {
            UserId = userId,
            Plan = SubscriptionPlan.Premium,
            Status = SubscriptionStatus.Active,
            Period = SubscriptionPeriod.Monthly,
            Source = SubscriptionSource.Stub,
            StartedAt = DateTime.UtcNow.AddDays(-40),
            ExpiresAt = DateTime.UtcNow.AddDays(-1),
        });
        await db.SaveChangesAsync();

        var snap = await Svc(db, userId).GetAsync(userId);

        Assert.False(snap.IsPremium);
        // OCR ücreti kaldırıldı → premium olmasa da açık.
        Assert.True(snap.OcrEnabled);
        Assert.Equal(int.MaxValue, snap.MaxClasses);
    }

    [Fact]
    public async Task RequireOcr_Free_DoesNotThrow()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        // OCR ücreti kaldırıldı → Free kullanıcıda da fırlatmamalı.
        await Svc(db, userId).RequireOcrAsync();
    }

    [Fact]
    public async Task RequireOcr_Premium_Passes()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        db.Subscriptions.Add(new Subscription
        {
            UserId = userId,
            Plan = SubscriptionPlan.Premium,
            Status = SubscriptionStatus.Trial,
            Source = SubscriptionSource.Stub,
            StartedAt = DateTime.UtcNow,
            ExpiresAt = DateTime.UtcNow.AddDays(7),
        });
        await db.SaveChangesAsync();

        // Fırlatmamalı.
        await Svc(db, userId).RequireOcrAsync();
    }

    [Fact]
    public async Task RequireClassQuota_Free_Unlimited_DoesNotThrow()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        // Sınıf kotası kaldırıldı → yüksek sayıda bile fırlatmamalı (Free sınırsız).
        await Svc(db, userId).RequireClassQuotaAsync(999);
    }

    [Fact]
    public async Task RequireLessonQuota_BelowLimit_Passes()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        await Svc(db, userId).RequireLessonQuotaAsync(4);
    }
}
