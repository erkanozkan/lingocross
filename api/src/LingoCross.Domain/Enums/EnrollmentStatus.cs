namespace LingoCross.Domain.Enums;

/// <summary>
/// Öğretmen-öğrenci eşleşmesinin durumu. Sayısal değerler kalıcı olarak saklandığı için
/// DEĞİŞTİRİLMEMELİDİR.
/// </summary>
public enum EnrollmentStatus
{
    /// <summary>Öğrenci katılım talep etti, öğretmen onayı bekleniyor.</summary>
    Pending = 1,

    /// <summary>Eşleşme etkin; öğrenci öğretmenin yayımlanmış derslerine erişebilir.</summary>
    Active = 2,

    /// <summary>Öğretmen tarafından reddedildi.</summary>
    Rejected = 3,
}
