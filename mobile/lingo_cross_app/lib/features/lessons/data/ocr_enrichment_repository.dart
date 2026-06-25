import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/ocr_line_parser.dart';
import 'dtos/ocr_enrich_dtos.dart';

/// Görüntüyü bulut AI ile okuyup kelime listesine çeviren repository
/// (`POST /api/ocr/enrich`).
///
/// Uç Bearer + Teacher korumalıdır (token interceptor başlığı ekler). Sunucuda
/// AI anahtarı yoksa veya upstream hata olursa **503** döner.
///
/// Sözleşme: [enrich] **başarıda** kelimeleri, **her türlü hata/çevrimdışı/503
/// veya boş sonuçta `null`** döndürür (asla fırlatmaz). Çağıran taraf `null`'ı
/// "AI okuyamadı/hata" olarak yorumlar ve kullanıcıya hata/boş durumu gösterir.
class OcrEnrichmentRepository {
  OcrEnrichmentRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Base64 kodlu görüntüyü bulut AI'ya gönderip çıkarılan kelimeleri döndürür.
  /// Başarısızlıkta (503/ağ/biçim/boş) `null` döner.
  Future<List<OcrEnrichedWord>?> enrich({
    required String imageBase64,
    required String mediaType,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (imageBase64.trim().isEmpty) return null;
    try {
      final request = OcrEnrichRequest(
        imageBase64: imageBase64,
        mediaType: mediaType,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/ocr/enrich',
        data: request.toJson(),
      );
      final data = res.data;
      if (data == null) return null;
      final parsed = OcrEnrichResponse.fromJson(data);
      // Boş liste de "kullanılabilir sonuç yok" demektir → hata/boş durumu.
      return parsed.words.isEmpty ? null : parsed.words;
    } catch (_) {
      // 503 (anahtar yok/upstream), ağ hatası, biçim hatası → null.
      return null;
    }
  }
}

final ocrEnrichmentRepositoryProvider =
    Provider<OcrEnrichmentRepository>((ref) {
  return OcrEnrichmentRepository(ref.watch(dioProvider));
});

/// Bulut AI'dan dönen kelimeleri gözden geçirme adaylarına çevirir (saf mantık).
///
/// - Boş `term`'li kayıtlar elenir.
/// - `meaning` boşsa null'a indirgenir (review alanı boş gelir).
/// - `synonyms` budanır (boşlar atılır, kırpılır) ve adaya taşınır.
/// - `tooShort`, terim < 2 karakterse işaretlenir (yerel ayrıştırmayla tutarlı).
List<OcrCandidate> enrichedWordsToCandidates(List<OcrEnrichedWord> words) {
  return [
    for (final w in words)
      if (w.term.trim().isNotEmpty)
        OcrCandidate(
          term: w.term.trim(),
          meaning: w.meaning.trim().isEmpty ? null : w.meaning.trim(),
          tooShort: w.term.trim().length < 2,
          synonyms: [
            for (final s in w.synonyms)
              if (s.trim().isNotEmpty) s.trim(),
          ],
        ),
  ];
}
