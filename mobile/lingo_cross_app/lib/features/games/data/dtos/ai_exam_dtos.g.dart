// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_exam_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiExamGenerateRequestImpl _$$AiExamGenerateRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AiExamGenerateRequestImpl(
  grade: (json['grade'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$AiExamGenerateRequestImplToJson(
  _$AiExamGenerateRequestImpl instance,
) => <String, dynamic>{
  'grade': instance.grade,
  'count': instance.count,
  'types': instance.types,
};

_$AiGeneratedQuestionOptionImpl _$$AiGeneratedQuestionOptionImplFromJson(
  Map<String, dynamic> json,
) => _$AiGeneratedQuestionOptionImpl(
  id: json['id'] as String,
  position: (json['position'] as num).toInt(),
  text: json['text'] as String,
  isCorrect: json['isCorrect'] as bool,
);

Map<String, dynamic> _$$AiGeneratedQuestionOptionImplToJson(
  _$AiGeneratedQuestionOptionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'position': instance.position,
  'text': instance.text,
  'isCorrect': instance.isCorrect,
};

_$AiGeneratedQuestionImpl _$$AiGeneratedQuestionImplFromJson(
  Map<String, dynamic> json,
) => _$AiGeneratedQuestionImpl(
  id: json['id'] as String,
  type: json['type'] as String,
  stem: json['stem'] as String,
  explanation: json['explanation'] as String?,
  options:
      (json['options'] as List<dynamic>)
          .map(
            (e) =>
                AiGeneratedQuestionOption.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$$AiGeneratedQuestionImplToJson(
  _$AiGeneratedQuestionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'stem': instance.stem,
  'explanation': instance.explanation,
  'options': instance.options.map((e) => e.toJson()).toList(),
};

_$AiExamResultDtoImpl _$$AiExamResultDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AiExamResultDtoImpl(
  topicId: json['topicId'] as String,
  title: json['title'] as String,
  grade: (json['grade'] as num).toInt(),
  lessonId: json['lessonId'] as String,
  questions:
      (json['questions'] as List<dynamic>)
          .map((e) => AiGeneratedQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$AiExamResultDtoImplToJson(
  _$AiExamResultDtoImpl instance,
) => <String, dynamic>{
  'topicId': instance.topicId,
  'title': instance.title,
  'grade': instance.grade,
  'lessonId': instance.lessonId,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};
