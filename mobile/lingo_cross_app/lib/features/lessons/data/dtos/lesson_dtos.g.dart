// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateLessonRequestImpl _$$CreateLessonRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateLessonRequestImpl(
  title: json['title'] as String,
  description: json['description'] as String?,
  sourceLanguage: json['sourceLanguage'] as String?,
  targetLanguage: json['targetLanguage'] as String?,
  scheduledLabel: json['scheduledLabel'] as String?,
);

Map<String, dynamic> _$$CreateLessonRequestImplToJson(
  _$CreateLessonRequestImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'sourceLanguage': instance.sourceLanguage,
  'targetLanguage': instance.targetLanguage,
  'scheduledLabel': instance.scheduledLabel,
};

_$UpdateLessonRequestImpl _$$UpdateLessonRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateLessonRequestImpl(
  title: json['title'] as String,
  description: json['description'] as String?,
  sourceLanguage: json['sourceLanguage'] as String?,
  targetLanguage: json['targetLanguage'] as String?,
  scheduledLabel: json['scheduledLabel'] as String?,
);

Map<String, dynamic> _$$UpdateLessonRequestImplToJson(
  _$UpdateLessonRequestImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'sourceLanguage': instance.sourceLanguage,
  'targetLanguage': instance.targetLanguage,
  'scheduledLabel': instance.scheduledLabel,
};

_$LessonDtoImpl _$$LessonDtoImplFromJson(Map<String, dynamic> json) =>
    _$LessonDtoImpl(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      scheduledLabel: json['scheduledLabel'] as String?,
      status: const LessonStatusConverter().fromJson(
        (json['status'] as num).toInt(),
      ),
      isPublished: json['isPublished'] as bool,
      wordCount: (json['wordCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LessonDtoImplToJson(_$LessonDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'title': instance.title,
      'description': instance.description,
      'sourceLanguage': instance.sourceLanguage,
      'targetLanguage': instance.targetLanguage,
      'scheduledLabel': instance.scheduledLabel,
      'status': const LessonStatusConverter().toJson(instance.status),
      'isPublished': instance.isPublished,
      'wordCount': instance.wordCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
