namespace LingoCross.Domain.Enums;

/// <summary>
/// Abonelik planı. Sayısal değerler kalıcı olarak saklandığı için DEĞİŞTİRİLMEMELİDİR.
/// MVP'de tek ücretli plan vardır; Free için ayrı bir değer yoktur (abonelik satırı olmaması = Free).
/// </summary>
public enum SubscriptionPlan
{
    Premium = 1,
}
