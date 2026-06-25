using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Subscriptions;
using LingoCross.Application.Subscriptions.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// F8.1 — SubscriptionService stub akışı: activate (trial/aylık/yıllık), cancel ve StubEnabled
/// güvenlik davranışı (kapalıyken 503). DTO limitleri entitlement otoritesiyle tutarlıdır.
/// </summary>
public class SubscriptionServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"sub-{Guid.NewGuid()}")
            .Options);

    private static SubscriptionOptions Opts(bool stubEnabled) => new()
    {
        StubEnabled = stubEnabled,
        FreeMaxClasses = 2,
        FreeMaxLessons = 5,
        FreeMaxTeachers = 1,
        TrialDays = 7,
    };

    private static SubscriptionService Svc(
        AppDbContext db,
        Guid userId,
        bool stubEnabled = true,
        IAppleReceiptVerifier? appleVerifier = null,
        string? appleSharedSecret = "shared-secret")
    {
        var current = TestCurrentUser.Teacher(userId);
        var options = Options.Create(Opts(stubEnabled));
        var entitlement = new EntitlementService(db, current, options);
        var appleOptions = Options.Create(new AppleOptions { SharedSecret = appleSharedSecret });
        return new SubscriptionService(
            db,
            current,
            entitlement,
            options,
            appleOptions,
            appleVerifier ?? new FakeAppleReceiptVerifier(new AppleVerifyResult(false, null, null, null, "unset")));
    }

    /// <summary>Apple'a gerçek istek atmadan sabit sonuç döndüren sahte doğrulayıcı.</summary>
    private sealed class FakeAppleReceiptVerifier : IAppleReceiptVerifier
    {
        private readonly AppleVerifyResult _result;
        public string? LastReceiptData { get; private set; }

        public FakeAppleReceiptVerifier(AppleVerifyResult result) => _result = result;

        public Task<AppleVerifyResult> VerifyAsync(string receiptData, CancellationToken cancellationToken = default)
        {
            LastReceiptData = receiptData;
            return Task.FromResult(_result);
        }
    }

    private static async Task<Guid> SeedUserAsync(AppDbContext db)
    {
        var u = new User { Email = $"{Guid.NewGuid():N}@x.com", PasswordHash = "x", DisplayName = "U", Role = UserRole.Teacher };
        db.Users.Add(u);
        await db.SaveChangesAsync();
        return u.Id;
    }

    [Fact]
    public async Task GetMine_NoRow_ReturnsFreeDto()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var dto = await Svc(db, userId).GetMineAsync();

        Assert.False(dto.IsPremium);
        Assert.Equal(SubscriptionStatus.None, dto.Status);
        Assert.Equal(2, dto.MaxClasses);
        Assert.Equal(5, dto.MaxLessons);
        Assert.Equal(1, dto.MaxTeachers);
        Assert.False(dto.OcrEnabled);
    }

    [Fact]
    public async Task ActivateStub_Trial_SetsTrialAndExpiry_AndUnlimitedWireLimits()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var dto = await Svc(db, userId).ActivateStubAsync(new ActivateStubRequest(null, Trial: true));

        Assert.True(dto.IsPremium);
        Assert.Equal(SubscriptionStatus.Trial, dto.Status);
        Assert.NotNull(dto.ExpiresAt);
        // Sınırsız konvansiyonu: tel üzerinde -1.
        Assert.Equal(-1, dto.MaxClasses);
        Assert.Equal(-1, dto.MaxLessons);
        Assert.Equal(-1, dto.MaxTeachers);
        Assert.True(dto.OcrEnabled);

        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionStatus.Trial, row.Status);
        Assert.Null(row.Period);
        Assert.InRange(row.ExpiresAt!.Value, DateTime.UtcNow.AddDays(6), DateTime.UtcNow.AddDays(8));
    }

    [Fact]
    public async Task ActivateStub_Monthly_SetsActiveAround30Days()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var dto = await Svc(db, userId).ActivateStubAsync(
            new ActivateStubRequest(SubscriptionPeriod.Monthly, Trial: false));

        Assert.True(dto.IsPremium);
        Assert.Equal(SubscriptionStatus.Active, dto.Status);
        Assert.Equal(SubscriptionPeriod.Monthly, dto.Period);

        var row = await db.Subscriptions.SingleAsync();
        Assert.InRange(row.ExpiresAt!.Value, DateTime.UtcNow.AddDays(29), DateTime.UtcNow.AddDays(31));
    }

    [Fact]
    public async Task ActivateStub_Annual_SetsActiveAround365Days()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        await Svc(db, userId).ActivateStubAsync(new ActivateStubRequest(SubscriptionPeriod.Annual, Trial: false));

        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionStatus.Active, row.Status);
        Assert.InRange(row.ExpiresAt!.Value, DateTime.UtcNow.AddDays(364), DateTime.UtcNow.AddDays(366));
    }

    [Fact]
    public async Task ActivateStub_Upsert_SingleRowPerUser()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var svc = Svc(db, userId);

        await svc.ActivateStubAsync(new ActivateStubRequest(null, Trial: true));
        await svc.ActivateStubAsync(new ActivateStubRequest(SubscriptionPeriod.Annual, Trial: false));

        Assert.Equal(1, await db.Subscriptions.CountAsync(s => s.UserId == userId));
        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionStatus.Active, row.Status);
        Assert.Equal(SubscriptionPeriod.Annual, row.Period);
    }

    [Fact]
    public async Task Cancel_FallsBackToFree()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var svc = Svc(db, userId);
        await svc.ActivateStubAsync(new ActivateStubRequest(SubscriptionPeriod.Monthly, Trial: false));

        var dto = await svc.CancelAsync();

        Assert.False(dto.IsPremium);
        Assert.Equal(SubscriptionStatus.Canceled, dto.Status);
        Assert.Equal(2, dto.MaxClasses);
        Assert.False(dto.OcrEnabled);
    }

    [Fact]
    public async Task ActivateStub_StubDisabled_Throws503()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, userId, stubEnabled: false)
                .ActivateStubAsync(new ActivateStubRequest(SubscriptionPeriod.Monthly, Trial: false)));

        Assert.Equal(503, ex.StatusCode);
        Assert.Equal(0, await db.Subscriptions.CountAsync());
    }

    [Fact]
    public async Task Cancel_StubDisabled_Throws503()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, userId, stubEnabled: false).CancelAsync());

        Assert.Equal(503, ex.StatusCode);
    }

    [Fact]
    public async Task GetMine_AlwaysAllowed_EvenWhenStubDisabled()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        // StubEnabled=false olsa bile GET me 503 fırlatmaz.
        var dto = await Svc(db, userId, stubEnabled: false).GetMineAsync();

        Assert.False(dto.IsPremium);
    }

    // --- S3: Apple IAP makbuz doğrulama ---

    [Fact]
    public async Task VerifyApple_ValidMonthlyFutureExpiry_SetsActivePremium()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var verifier = new FakeAppleReceiptVerifier(new AppleVerifyResult(
            IsValid: true,
            ProductId: AppleOptions.MonthlyProductId,
            ExpiresAt: DateTimeOffset.UtcNow.AddDays(20),
            OriginalTransactionId: "txn-1001",
            RawError: null));

        var dto = await Svc(db, userId, appleVerifier: verifier).VerifyAppleReceiptAsync("base64receipt");

        Assert.True(dto.IsPremium);
        Assert.Equal(SubscriptionStatus.Active, dto.Status);
        Assert.Equal(SubscriptionPeriod.Monthly, dto.Period);
        Assert.NotNull(dto.ExpiresAt);

        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionPlan.Premium, row.Plan);
        Assert.Equal(SubscriptionSource.AppleIap, row.Source);
        Assert.Equal(SubscriptionStatus.Active, row.Status);
        Assert.Equal(SubscriptionPeriod.Monthly, row.Period);
        Assert.Equal("txn-1001", row.StoreTransactionId);
        Assert.NotNull(row.ExpiresAt);
    }

    [Fact]
    public async Task VerifyApple_ValidAnnual_SetsAnnualPeriod()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var verifier = new FakeAppleReceiptVerifier(new AppleVerifyResult(
            true, AppleOptions.AnnualProductId, DateTimeOffset.UtcNow.AddDays(300), "txn-2002", null));

        var dto = await Svc(db, userId, appleVerifier: verifier).VerifyAppleReceiptAsync("r");

        Assert.True(dto.IsPremium);
        Assert.Equal(SubscriptionPeriod.Annual, dto.Period);

        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionPeriod.Annual, row.Period);
    }

    [Fact]
    public async Task VerifyApple_ValidButPastExpiry_SetsExpiredNotPremium()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var verifier = new FakeAppleReceiptVerifier(new AppleVerifyResult(
            true, AppleOptions.MonthlyProductId, DateTimeOffset.UtcNow.AddDays(-1), "txn-3003", null));

        var dto = await Svc(db, userId, appleVerifier: verifier).VerifyAppleReceiptAsync("r");

        Assert.False(dto.IsPremium);
        Assert.Equal(SubscriptionStatus.Expired, dto.Status);

        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionStatus.Expired, row.Status);
        Assert.Equal(SubscriptionSource.AppleIap, row.Source);
    }

    [Fact]
    public async Task VerifyApple_InvalidReceipt_Throws400()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var verifier = new FakeAppleReceiptVerifier(new AppleVerifyResult(false, null, null, null, "21003"));

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, userId, appleVerifier: verifier).VerifyAppleReceiptAsync("r"));

        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.Subscriptions.CountAsync());
    }

    [Fact]
    public async Task VerifyApple_NoSharedSecret_Throws503()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);
        var verifier = new FakeAppleReceiptVerifier(new AppleVerifyResult(
            true, AppleOptions.MonthlyProductId, DateTimeOffset.UtcNow.AddDays(10), "txn", null));

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, userId, appleVerifier: verifier, appleSharedSecret: null).VerifyAppleReceiptAsync("r"));

        Assert.Equal(503, ex.StatusCode);
        Assert.Equal(0, await db.Subscriptions.CountAsync());
    }

    [Fact]
    public async Task VerifyApple_EmptyReceipt_Throws400()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, userId).VerifyAppleReceiptAsync("   "));

        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task VerifyApple_Upsert_SingleRowPerUser()
    {
        var db = NewDb();
        var userId = await SeedUserAsync(db);

        var monthly = new FakeAppleReceiptVerifier(new AppleVerifyResult(
            true, AppleOptions.MonthlyProductId, DateTimeOffset.UtcNow.AddDays(10), "txn-A", null));
        await Svc(db, userId, appleVerifier: monthly).VerifyAppleReceiptAsync("r1");

        var annual = new FakeAppleReceiptVerifier(new AppleVerifyResult(
            true, AppleOptions.AnnualProductId, DateTimeOffset.UtcNow.AddDays(300), "txn-B", null));
        await Svc(db, userId, appleVerifier: annual).VerifyAppleReceiptAsync("r2");

        Assert.Equal(1, await db.Subscriptions.CountAsync(s => s.UserId == userId));
        var row = await db.Subscriptions.SingleAsync();
        Assert.Equal(SubscriptionPeriod.Annual, row.Period);
        Assert.Equal("txn-B", row.StoreTransactionId);
    }
}
