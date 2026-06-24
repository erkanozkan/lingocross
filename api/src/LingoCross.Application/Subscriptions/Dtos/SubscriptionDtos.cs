using LingoCross.Domain.Enums;

namespace LingoCross.Application.Subscriptions.Dtos;

/// <summary>
/// Kullanıcının abonelik durumu + uygulanan limitler. Mobil tarafın tek kaynaktan hak/limit
/// okuyabilmesi için limitler de döndürülür.
/// <para>
/// Sınırsız konvansiyonu: Premium kullanıcıda <c>MaxClasses/MaxLessons/MaxTeachers</c> alanları
/// <b>-1</b> ile gösterilir (-1 = sınırsız). Free kullanıcıda gerçek pozitif limitler döner.
/// </para>
/// </summary>
public record SubscriptionDto(
    SubscriptionPlan Plan,
    SubscriptionStatus Status,
    SubscriptionPeriod? Period,
    DateTime? ExpiresAt,
    bool IsPremium,
    int MaxClasses,
    int MaxLessons,
    int MaxTeachers,
    bool OcrEnabled);

/// <summary>
/// Stub abonelik etkinleştirme isteği. <c>Trial=true</c> ise deneme aboneliği başlatılır ve
/// <c>Period</c> yok sayılır; aksi halde <c>Period</c> zorunludur (aylık/yıllık).
/// </summary>
public record ActivateStubRequest(SubscriptionPeriod? Period, bool Trial);
