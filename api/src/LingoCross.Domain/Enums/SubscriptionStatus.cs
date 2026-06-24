namespace LingoCross.Domain.Enums;

/// <summary>
/// Abonelik durumu. Sayısal değerler kalıcı olarak saklandığı için DEĞİŞTİRİLMEMELİDİR.
/// <c>None</c> hiçbir aboneliğin olmadığı (Free) durumu temsil eder.
/// </summary>
public enum SubscriptionStatus
{
    None = 0,
    Trial = 1,
    Active = 2,
    Expired = 3,
    Canceled = 4,
}
