namespace LingoCross.Application.Subscriptions;

/// <summary>
/// appsettings/ortam değişkenlerindeki "Subscription" bölümüne bağlanan ayarlar.
/// <para>
/// Mimari notu: <c>JwtOptions</c> Infrastructure'da tutulur çünkü yalnızca Infrastructure tarafından
/// tüketilir. Bu ayarlar ise <c>EntitlementService</c> (Application) tarafından kullanıldığından ve
/// Application, Infrastructure'a referans veremeyeceğinden, POCO Application'da yer alır; binding
/// (Configure) Infrastructure'ın DI'ında yapılır.
/// </para>
/// </summary>
public class SubscriptionOptions
{
    public const string SectionName = "Subscription";

    /// <summary>Stub (sahte) satın alma uçlarının açık olup olmadığı. Production'da kapalı tutulur.</summary>
    public bool StubEnabled { get; set; }

    /// <summary>Free öğretmenin oluşturabileceği en fazla (arşivlenmemiş) sınıf sayısı.</summary>
    public int FreeMaxClasses { get; set; } = 2;

    /// <summary>Free öğretmenin oluşturabileceği en fazla ders sayısı.</summary>
    public int FreeMaxLessons { get; set; } = 5;

    /// <summary>Free öğrencinin katılabileceği en fazla farklı öğretmen sayısı.</summary>
    public int FreeMaxTeachers { get; set; } = 1;

    /// <summary>Stub deneme (trial) aboneliğinin gün cinsinden süresi.</summary>
    public int TrialDays { get; set; } = 7;
}
