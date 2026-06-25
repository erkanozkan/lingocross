import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_enrich_dtos.freezed.dart';
part 'ocr_enrich_dtos.g.dart';

/// POST /api/ocr/enrich isteği.
///
/// [imageBase64] kelime listesi fotoğrafının base64 (data: öneki olmadan)
/// gösterimidir; bulut AI görüntüyü okur ve kelimeleri çıkarır. [mediaType]
/// görüntünün MIME tipidir (`image/jpeg`, `image/png`). Kaynak/hedef dil ISO
/// kodlarıdır (`en`, `tr`).
@freezed
class OcrEnrichRequest with _$OcrEnrichRequest {
  const factory OcrEnrichRequest({
    required String imageBase64,
    required String mediaType,
    required String sourceLanguage,
    required String targetLanguage,
  }) = _OcrEnrichRequest;

  factory OcrEnrichRequest.fromJson(Map<String, dynamic> json) =>
      _$OcrEnrichRequestFromJson(json);
}

/// POST /api/ocr/enrich 200 yanıtı: zenginleştirilmiş kelime listesi.
@freezed
class OcrEnrichResponse with _$OcrEnrichResponse {
  const factory OcrEnrichResponse({
    @Default(<OcrEnrichedWord>[]) List<OcrEnrichedWord> words,
  }) = _OcrEnrichResponse;

  factory OcrEnrichResponse.fromJson(Map<String, dynamic> json) =>
      _$OcrEnrichResponseFromJson(json);
}

/// Bulut AI tarafından zenginleştirilmiş tek bir kelime.
@freezed
class OcrEnrichedWord with _$OcrEnrichedWord {
  const factory OcrEnrichedWord({
    required String term,
    @Default('') String meaning,
    @Default(<String>[]) List<String> synonyms,
  }) = _OcrEnrichedWord;

  factory OcrEnrichedWord.fromJson(Map<String, dynamic> json) =>
      _$OcrEnrichedWordFromJson(json);
}
