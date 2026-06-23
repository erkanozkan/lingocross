import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/word_source.dart';

part 'word_dtos.freezed.dart';
part 'word_dtos.g.dart';

/// API'deki int WordSource değerini (`1`/`2`) [WordSource] enum'una çevirir.
class WordSourceConverter implements JsonConverter<WordSource, int> {
  const WordSourceConverter();

  @override
  WordSource fromJson(int json) => WordSource.fromValue(json);

  @override
  int toJson(WordSource object) => object.value;
}

/// Bir kelimenin çeviri yükü (TranslationPayload). `text` + `isPrimary`.
@freezed
class TranslationPayload with _$TranslationPayload {
  const factory TranslationPayload({
    required String text,
    required bool isPrimary,
  }) = _TranslationPayload;

  factory TranslationPayload.fromJson(Map<String, dynamic> json) =>
      _$TranslationPayloadFromJson(json);
}

/// POST /api/lessons/{id}/words isteği (AddWordRequest).
///
/// İç içe [TranslationPayload] listesi de Map'e serileşmeli; bu nedenle
/// `build.yaml`'da `explicit_to_json: true` etkindir (aksi halde nesne olduğu
/// gibi kalır → API hatası).
@freezed
class AddWordRequest with _$AddWordRequest {
  const factory AddWordRequest({
    required String term,
    int? sortOrder,
    @WordSourceNullableConverter() WordSource? source,
    required List<TranslationPayload> translations,
    List<String>? synonyms,
  }) = _AddWordRequest;

  factory AddWordRequest.fromJson(Map<String, dynamic> json) =>
      _$AddWordRequestFromJson(json);
}

/// PUT /api/words/{wordId} isteği (UpdateWordRequest).
@freezed
class UpdateWordRequest with _$UpdateWordRequest {
  const factory UpdateWordRequest({
    required String term,
    int? sortOrder,
    @WordSourceNullableConverter() WordSource? source,
    required List<TranslationPayload> translations,
    List<String>? synonyms,
  }) = _UpdateWordRequest;

  factory UpdateWordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWordRequestFromJson(json);
}

/// Kelime (WordDto) — API ile birebir.
@freezed
class WordDto with _$WordDto {
  const factory WordDto({
    required String id,
    required String lessonId,
    required String term,
    required int sortOrder,
    @WordSourceConverter() required WordSource source,
    required List<TranslationDto> translations,
    required List<SynonymDto> synonyms,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WordDto;

  factory WordDto.fromJson(Map<String, dynamic> json) =>
      _$WordDtoFromJson(json);
}

/// Çeviri (TranslationDto).
@freezed
class TranslationDto with _$TranslationDto {
  const factory TranslationDto({
    required String id,
    required String text,
    required bool isPrimary,
  }) = _TranslationDto;

  factory TranslationDto.fromJson(Map<String, dynamic> json) =>
      _$TranslationDtoFromJson(json);
}

/// Eşanlam (SynonymDto).
@freezed
class SynonymDto with _$SynonymDto {
  const factory SynonymDto({
    required String id,
    required String text,
  }) = _SynonymDto;

  factory SynonymDto.fromJson(Map<String, dynamic> json) =>
      _$SynonymDtoFromJson(json);
}

/// İsteklerde `source` opsiyonel olduğu için null-güvenli converter.
class WordSourceNullableConverter
    implements JsonConverter<WordSource?, int?> {
  const WordSourceNullableConverter();

  @override
  WordSource? fromJson(int? json) =>
      json == null ? null : WordSource.fromValue(json);

  @override
  int? toJson(WordSource? object) => object?.value;
}
