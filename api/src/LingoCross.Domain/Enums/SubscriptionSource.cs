namespace LingoCross.Domain.Enums;

/// <summary>
/// Aboneliğin nereden geldiği. Sayısal değerler kalıcı olarak saklandığı için DEĞİŞTİRİLMEMELİDİR.
/// <c>Stub</c> dev/test satın alma akışı, <c>Manual</c> idari atama, <c>AppleIap</c> ileriye dönük
/// gerçek App Store satın alımları içindir (S3 dikişi).
/// </summary>
public enum SubscriptionSource
{
    Stub = 1,
    Manual = 2,
    AppleIap = 3,
}
