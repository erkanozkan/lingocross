// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_enrich_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OcrEnrichRequestImpl _$$OcrEnrichRequestImplFromJson(
  Map<String, dynamic> json,
) => _$OcrEnrichRequestImpl(
  rawText: json['rawText'] as String,
  sourceLanguage: json['sourceLanguage'] as String,
  targetLanguage: json['targetLanguage'] as String,
);

Map<String, dynamic> _$$OcrEnrichRequestImplToJson(
  _$OcrEnrichRequestImpl instance,
) => <String, dynamic>{
  'rawText': instance.rawText,
  'sourceLanguage': instance.sourceLanguage,
  'targetLanguage': instance.targetLanguage,
};

_$OcrEnrichResponseImpl _$$OcrEnrichResponseImplFromJson(
  Map<String, dynamic> json,
) => _$OcrEnrichResponseImpl(
  words:
      (json['words'] as List<dynamic>?)
          ?.map((e) => OcrEnrichedWord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OcrEnrichedWord>[],
);

Map<String, dynamic> _$$OcrEnrichResponseImplToJson(
  _$OcrEnrichResponseImpl instance,
) => <String, dynamic>{'words': instance.words.map((e) => e.toJson()).toList()};

_$OcrEnrichedWordImpl _$$OcrEnrichedWordImplFromJson(
  Map<String, dynamic> json,
) => _$OcrEnrichedWordImpl(
  term: json['term'] as String,
  meaning: json['meaning'] as String? ?? '',
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$$OcrEnrichedWordImplToJson(
  _$OcrEnrichedWordImpl instance,
) => <String, dynamic>{
  'term': instance.term,
  'meaning': instance.meaning,
  'synonyms': instance.synonyms,
};
