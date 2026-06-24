namespace LingoCross.Domain.Enums;

/// <summary>
/// Bir dersin yaşam döngüsü durumu. Sayısal değerler kalıcı olarak saklandığı için
/// DEĞİŞTİRİLMEMELİDİR. Öğrenci görünürlüğü ayrı <c>IsPublished</c> bayrağıyla yönetilir:
/// Active ve Completed yayımlanmış (görünür), Draft yayımlanmamıştır.
/// </summary>
public enum LessonStatus
{
    /// <summary>Taslak — henüz yayımlanmamış, öğrenciye görünmez (is_published=false).</summary>
    Draft = 1,

    /// <summary>Yayımlanmış ve aktif — öğrenciye görünür (is_published=true).</summary>
    Active = 2,

    /// <summary>Tamamlandı — öğrenciye görünür kalır, "tamamlandı" işaretlidir (is_published=true).</summary>
    Completed = 3,
}
