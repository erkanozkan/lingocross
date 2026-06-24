namespace LingoCross.Application.Ocr.Dtos;

/// <summary>
/// OCR ham metnini Claude ile zenginleştirme isteği. Ham metinde Türkçe karakter
/// hataları (ör. "Öğlen" → "Qğlen") olabilir; servis bunları düzeltir, satırları
/// terim ↔ karşılık olarak ayırır ve eşanlamlar üretir.
/// </summary>
public record OcrEnrichRequest(
    string RawText,
    string SourceLanguage = "en",
    string TargetLanguage = "tr");

/// <summary>Zenginleştirme sonucu: ayrıştırılmış ve düzeltilmiş kelime listesi.</summary>
public record OcrEnrichResponse(IReadOnlyList<EnrichedWord> Words);

/// <summary>
/// Tek bir kelime: kaynak dildeki terim, hedef dildeki karşılığı ve uygun dildeki
/// 1-2 eşanlam (yoksa boş liste).
/// </summary>
public record EnrichedWord(
    string Term,
    string Meaning,
    IReadOnlyList<string> Synonyms);
