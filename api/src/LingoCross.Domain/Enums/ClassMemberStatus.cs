namespace LingoCross.Domain.Enums;

/// <summary>
/// Bir öğrencinin bir sınıftaki üyelik durumu. Sayısal değerler kalıcı olarak saklandığı için
/// DEĞİŞTİRİLMEMELİDİR. MVP'de yalnızca Active vardır; ileride Pending/Removed gibi durumlar
/// için yer ayrılmıştır.
/// </summary>
public enum ClassMemberStatus
{
    /// <summary>Üyelik etkin; öğrenci sınıfa atanmış yayınlı oyunlara erişebilir.</summary>
    Active = 1,
}
