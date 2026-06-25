using LingoCross.Application.Ocr.Dtos;

namespace LingoCross.Application.Ocr;

/// <summary>
/// Bir kelime listesi görüntüsünü (genellikle el yazısı) bir vision modeliyle zenginleştirir:
/// görüntüyü doğrudan okur, her satırı terim ↔ karşılık olarak dile göre ayırır ve uygun
/// dilde eşanlam üretir. Yapılandırma yoksa veya sağlayıcı hatası olursa <c>AppException</c>
/// (503) fırlatır; böylece istemci yerel ayrıştırmaya düşebilir.
/// </summary>
public interface IOcrEnrichmentService
{
    Task<OcrEnrichResponse> EnrichAsync(OcrEnrichRequest request, CancellationToken cancellationToken = default);
}
