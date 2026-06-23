// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationPayloadImpl _$$TranslationPayloadImplFromJson(
  Map<String, dynamic> json,
) => _$TranslationPayloadImpl(
  text: json['text'] as String,
  isPrimary: json['isPrimary'] as bool,
);

Map<String, dynamic> _$$TranslationPayloadImplToJson(
  _$TranslationPayloadImpl instance,
) => <String, dynamic>{'text': instance.text, 'isPrimary': instance.isPrimary};

_$AddWordRequestImpl _$$AddWordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddWordRequestImpl(
  term: json['term'] as String,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  source: const WordSourceNullableConverter().fromJson(
    (json['source'] as num?)?.toInt(),
  ),
  translations:
      (json['translations'] as List<dynamic>)
          .map((e) => TranslationPayload.fromJson(e as Map<String, dynamic>))
          .toList(),
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$AddWordRequestImplToJson(
  _$AddWordRequestImpl instance,
) => <String, dynamic>{
  'term': instance.term,
  'sortOrder': instance.sortOrder,
  'source': const WordSourceNullableConverter().toJson(instance.source),
  'translations': instance.translations.map((e) => e.toJson()).toList(),
  'synonyms': instance.synonyms,
};

_$UpdateWordRequestImpl _$$UpdateWordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateWordRequestImpl(
  term: json['term'] as String,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  source: const WordSourceNullableConverter().fromJson(
    (json['source'] as num?)?.toInt(),
  ),
  translations:
      (json['translations'] as List<dynamic>)
          .map((e) => TranslationPayload.fromJson(e as Map<String, dynamic>))
          .toList(),
  synonyms:
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$UpdateWordRequestImplToJson(
  _$UpdateWordRequestImpl instance,
) => <String, dynamic>{
  'term': instance.term,
  'sortOrder': instance.sortOrder,
  'source': const WordSourceNullableConverter().toJson(instance.source),
  'translations': instance.translations.map((e) => e.toJson()).toList(),
  'synonyms': instance.synonyms,
};

_$WordDtoImpl _$$WordDtoImplFromJson(Map<String, dynamic> json) =>
    _$WordDtoImpl(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      term: json['term'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      source: const WordSourceConverter().fromJson(
        (json['source'] as num).toInt(),
      ),
      translations:
          (json['translations'] as List<dynamic>)
              .map((e) => TranslationDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      synonyms:
          (json['synonyms'] as List<dynamic>)
              .map((e) => SynonymDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WordDtoImplToJson(_$WordDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lessonId': instance.lessonId,
      'term': instance.term,
      'sortOrder': instance.sortOrder,
      'source': const WordSourceConverter().toJson(instance.source),
      'translations': instance.translations.map((e) => e.toJson()).toList(),
      'synonyms': instance.synonyms.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TranslationDtoImpl _$$TranslationDtoImplFromJson(Map<String, dynamic> json) =>
    _$TranslationDtoImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      isPrimary: json['isPrimary'] as bool,
    );

Map<String, dynamic> _$$TranslationDtoImplToJson(
  _$TranslationDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'isPrimary': instance.isPrimary,
};

_$SynonymDtoImpl _$$SynonymDtoImplFromJson(Map<String, dynamic> json) =>
    _$SynonymDtoImpl(id: json['id'] as String, text: json['text'] as String);

Map<String, dynamic> _$$SynonymDtoImplToJson(_$SynonymDtoImpl instance) =>
    <String, dynamic>{'id': instance.id, 'text': instance.text};
