using LingoCross.Application.Ocr.Dtos;

namespace LingoCross.Application.Ocr;

/// <summary>
/// OCR ham metnini bir dil modeliyle zenginleştirir: Türkçe karakter hatalarını düzeltir,
/// her satırı terim ↔ karşılık olarak dile göre ayırır ve uygun dilde eşanlam üretir.
/// Yapılandırma yoksa veya sağlayıcı hatası olursa <c>AppException</c> (503) fırlatır;
/// böylece istemci yerel ayrıştırmaya düşebilir.
/// </summary>
public interface IOcrEnrichmentService
{
    Task<OcrEnrichResponse> EnrichAsync(OcrEnrichRequest request, CancellationToken cancellationToken = default);
}
