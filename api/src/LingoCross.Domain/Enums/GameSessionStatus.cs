namespace LingoCross.Domain.Enums;

/// <summary>
/// Bir oyun oturumunun durumu. Sayısal değerler kalıcı olarak saklandığı için DEĞİŞTİRİLMEMELİDİR.
/// </summary>
public enum GameSessionStatus
{
    /// <summary>Oturum başlatıldı, oyuncu oynuyor.</summary>
    InProgress = 1,

    /// <summary>Oyun tamamlandı (sonuç M5'te kaydedilir).</summary>
    Completed = 2,

    /// <summary>Oturum yarıda bırakıldı.</summary>
    Abandoned = 3,
}
