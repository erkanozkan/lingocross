namespace LingoCross.Application.Ocr.Dtos;

/// <summary>
/// Bir kelime listesi görüntüsünü (genellikle el yazısı, kâğıttan fotoğraf) Claude vision
/// ile zenginleştirme isteği. Görüntü doğrudan modele gönderilir; model satırları kaynak
/// terim ↔ hedef karşılık olarak ayırır ve eşanlamlar üretir. Cihaz-içi OCR'a gerek yoktur.
/// </summary>
public record OcrEnrichRequest(
    string ImageBase64,
    string MediaType = "image/jpeg",
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
