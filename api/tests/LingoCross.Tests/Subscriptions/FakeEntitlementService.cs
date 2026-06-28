using LingoCross.Application.Subscriptions;
using LingoCross.Domain.Enums;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// Testlerde kullanılan yapılandırılabilir entitlement sahtesi. Varsayılan olarak Premium (sınırsız,
/// OCR açık) davranır ve hiçbir Require... çağrısı 402 fırlatmaz. <see cref="Premium"/> false yapıldığında
/// verilen Free limitlerini uygular ve gerçek <see cref="EntitlementService"/> ile aynı 402 davranışını taklit eder.
/// </summary>
internal sealed class FakeEntitlementService : IEntitlementService
{
    public bool Premium { get; init; } = true;

    public int MaxClasses { get; init; } = 2;

    public int MaxLessons { get; init; } = 5;

    public int MaxTeachers { get; init; } = 1;

    public Task<EntitlementSnapshot> GetAsync(Guid userId, CancellationToken cancellationToken = default)
        => Task.FromResult(Premium
            ? new EntitlementSnapshot(true, SubscriptionStatus.Active, SubscriptionPeriod.Monthly, null,
                int.MaxValue, int.MaxValue, int.MaxValue, true)
            : new EntitlementSnapshot(false, SubscriptionStatus.None, null, null,
                MaxClasses, MaxLessons, MaxTeachers, false));

    public Task RequireOcrAsync(CancellationToken cancellationToken = default)
    {
        if (!Premium)
        {
            throw Application.Common.Exceptions.AppException.PaymentRequired("OCR Premium özelliğidir.", "ocr");
        }

        return Task.CompletedTask;
    }

    public Task RequirePuzzleCreateAsync(CancellationToken cancellationToken = default)
    {
        if (!Premium)
        {
            throw Application.Common.Exceptions.AppException.PaymentRequired(
                "Bulmaca oluşturmak Premium özelliğidir.", "puzzle_create");
        }

        return Task.CompletedTask;
    }

    public Task RequireClassQuotaAsync(int currentCount, CancellationToken cancellationToken = default)
    {
        if (!Premium && currentCount >= MaxClasses)
        {
            throw Application.Common.Exceptions.AppException.PaymentRequired("Sınıf limiti.", "class_limit");
        }

        return Task.CompletedTask;
    }

    public Task RequireLessonQuotaAsync(int currentCount, CancellationToken cancellationToken = default)
    {
        if (!Premium && currentCount >= MaxLessons)
        {
            throw Application.Common.Exceptions.AppException.PaymentRequired("Ders limiti.", "lesson_limit");
        }

        return Task.CompletedTask;
    }

    public Task RequireMultiTeacherJoinAsync(int currentDistinctTeacherCount, CancellationToken cancellationToken = default)
    {
        if (!Premium && currentDistinctTeacherCount >= MaxTeachers)
        {
            throw Application.Common.Exceptions.AppException.PaymentRequired("Çoklu öğretmen.", "multi_teacher");
        }

        return Task.CompletedTask;
    }
}
