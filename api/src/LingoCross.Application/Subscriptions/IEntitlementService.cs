using LingoCross.Domain.Enums;

namespace LingoCross.Application.Subscriptions;

/// <summary>
/// Bir kullanıcının premium hak/limitlerinin anlık görüntüsü. Premium'da limitler
/// <see cref="int.MaxValue"/> (sınırsız) olur ve <see cref="OcrEnabled"/> true'dur.
/// </summary>
public record EntitlementSnapshot(
    bool IsPremium,
    SubscriptionStatus Status,
    SubscriptionPeriod? Period,
    DateTime? ExpiresAt,
    int MaxClasses,
    int MaxLessons,
    int MaxTeachers,
    bool OcrEnabled);

/// <summary>
/// Entitlement (hak/limit) konularında tek otorite. Premium çözümü, Free limitleri ve özellik
/// kapıları buradan geçer; servisler limit/feature kararlarını kendileri vermez.
/// </summary>
public interface IEntitlementService
{
    /// <summary>Verilen kullanıcının güncel hak/limit anlık görüntüsünü döndürür (lazy-expiry uygulanır).</summary>
    Task<EntitlementSnapshot> GetAsync(Guid userId, CancellationToken cancellationToken = default);

    /// <summary>Geçerli kullanıcı OCR'a yetkili değilse 402 (feature="ocr") fırlatır.</summary>
    Task RequireOcrAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Mevcut (arşivlenmemiş) sınıf sayısı limiti aşıyorsa 402 (feature="class_limit") fırlatır.
    /// Yeni sınıf eklenmeden önce çağrılır.
    /// </summary>
    Task RequireClassQuotaAsync(int currentCount, CancellationToken cancellationToken = default);

    /// <summary>
    /// Mevcut ders sayısı limiti aşıyorsa 402 (feature="lesson_limit") fırlatır.
    /// Yeni ders eklenmeden önce çağrılır.
    /// </summary>
    Task RequireLessonQuotaAsync(int currentCount, CancellationToken cancellationToken = default);

    /// <summary>
    /// Öğrencinin katıldığı farklı öğretmen sayısı limiti aşıyorsa 402 (feature="multi_teacher")
    /// fırlatır. YALNIZCA gerçekten yeni bir öğretmene katılınacağı durumda çağrılmalıdır
    /// (aynı öğretmenin başka sınıfı / tekrar katılım için çağrılmaz).
    /// </summary>
    Task RequireMultiTeacherJoinAsync(int currentDistinctTeacherCount, CancellationToken cancellationToken = default);
}
