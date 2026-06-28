namespace LingoCross.Domain.Enums;

/// <summary>
/// Aboneliğin nereden geldiği. Sayısal değerler kalıcı olarak saklandığı için DEĞİŞTİRİLMEMELİDİR.
/// <c>Stub</c> dev/test satın alma akışı, <c>Manual</c> idari atama, <c>AppleIap</c> gerçek App Store
/// satın alımları, <c>GoogleIap</c> ise gerçek Google Play satın alımları içindir.
/// </summary>
public enum SubscriptionSource
{
    Stub = 1,
    Manual = 2,
    AppleIap = 3,
    GoogleIap = 4,
}
