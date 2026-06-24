// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubmitResultRequestImpl _$$SubmitResultRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SubmitResultRequestImpl(
  durationMs: (json['durationMs'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  correctItems: (json['correctItems'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SubmitResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$SubmitResultRequestImplToJson(
  _$SubmitResultRequestImpl instance,
) => <String, dynamic>{
  'durationMs': instance.durationMs,
  'totalItems': instance.totalItems,
  'correctItems': instance.correctItems,
  if (instance.items?.map((e) => e.toJson()).toList() case final value?)
    'items': value,
};

_$SubmitResultItemImpl _$$SubmitResultItemImplFromJson(
  Map<String, dynamic> json,
) => _$SubmitResultItemImpl(
  ordinal: (json['ordinal'] as num).toInt(),
  term: json['term'] as String,
  expectedAnswer: json['expectedAnswer'] as String,
  studentAnswer: json['studentAnswer'] as String?,
  isCorrect: json['isCorrect'] as bool,
);

Map<String, dynamic> _$$SubmitResultItemImplToJson(
  _$SubmitResultItemImpl instance,
) => <String, dynamic>{
  'ordinal': instance.ordinal,
  'term': instance.term,
  'expectedAnswer': instance.expectedAnswer,
  'studentAnswer': instance.studentAnswer,
  'isCorrect': instance.isCorrect,
};

_$GameResultDtoImpl _$$GameResultDtoImplFromJson(Map<String, dynamic> json) =>
    _$GameResultDtoImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      gameId: json['gameId'] as String,
      gameType: const GameTypeConverter().fromJson(
        (json['gameType'] as num).toInt(),
      ),
      lessonId: json['lessonId'] as String,
      lessonTitle: json['lessonTitle'] as String,
      durationMs: (json['durationMs'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      correctItems: (json['correctItems'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      sharedWithTeacher: json['sharedWithTeacher'] as bool,
      sharedAt:
          json['sharedAt'] == null
              ? null
              : DateTime.parse(json['sharedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$GameResultDtoImplToJson(_$GameResultDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'gameId': instance.gameId,
      'gameType': const GameTypeConverter().toJson(instance.gameType),
      'lessonId': instance.lessonId,
      'lessonTitle': instance.lessonTitle,
      'durationMs': instance.durationMs,
      'totalItems': instance.totalItems,
      'correctItems': instance.correctItems,
      'score': instance.score,
      'sharedWithTeacher': instance.sharedWithTeacher,
      'sharedAt': instance.sharedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
