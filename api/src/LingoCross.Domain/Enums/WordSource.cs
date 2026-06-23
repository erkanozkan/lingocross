namespace LingoCross.Domain.Enums;

/// <summary>
/// Bir kelimenin nasıl girildiğini belirtir. Sayısal değerler kalıcı olarak saklandığı için
/// DEĞİŞTİRİLMEMELİDİR.
/// </summary>
public enum WordSource
{
    /// <summary>Öğretmen tarafından elle girilmiş.</summary>
    Manual = 1,

    /// <summary>Kameradan OCR ile tanınıp gözden geçirilerek kaydedilmiş.</summary>
    Ocr = 2,
}
