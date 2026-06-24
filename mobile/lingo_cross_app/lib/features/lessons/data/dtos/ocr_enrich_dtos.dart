import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_enrich_dtos.freezed.dart';
part 'ocr_enrich_dtos.g.dart';

/// POST /api/ocr/enrich isteği.
///
/// [rawText] ML Kit'in tanıdığı ham metindir; satırlar `\n` ile ayrılır.
/// Kaynak/hedef dil ISO kodlarıdır (`en`, `tr`).
@freezed
class OcrEnrichRequest with _$OcrEnrichRequest {
  const factory OcrEnrichRequest({
    required String rawText,
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
