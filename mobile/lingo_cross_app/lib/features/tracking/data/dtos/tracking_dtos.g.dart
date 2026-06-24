// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentSummaryDtoImpl _$$StudentSummaryDtoImplFromJson(
  Map<String, dynamic> json,
) => _$StudentSummaryDtoImpl(
  studentId: json['studentId'] as String,
  displayName: json['displayName'] as String,
  sharedResultsCount: (json['sharedResultsCount'] as num).toInt(),
  averageScore: (json['averageScore'] as num?)?.toInt(),
  lastActivityAt:
      json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$$StudentSummaryDtoImplToJson(
  _$StudentSummaryDtoImpl instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'displayName': instance.displayName,
  'sharedResultsCount': instance.sharedResultsCount,
  'averageScore': instance.averageScore,
  'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
};

_$SharedResultDtoImpl _$$SharedResultDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SharedResultDtoImpl(
  resultId: json['resultId'] as String,
  lessonTitle: json['lessonTitle'] as String,
  gameType: const GameTypeConverter().fromJson(
    (json['gameType'] as num).toInt(),
  ),
  score: (json['score'] as num).toInt(),
  durationMs: (json['durationMs'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  correctItems: (json['correctItems'] as num).toInt(),
  sharedAt:
      json['sharedAt'] == null
          ? null
          : DateTime.parse(json['sharedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$SharedResultDtoImplToJson(
  _$SharedResultDtoImpl instance,
) => <String, dynamic>{
  'resultId': instance.resultId,
  'lessonTitle': instance.lessonTitle,
  'gameType': const GameTypeConverter().toJson(instance.gameType),
  'score': instance.score,
  'durationMs': instance.durationMs,
  'totalItems': instance.totalItems,
  'correctItems': instance.correctItems,
  'sharedAt': instance.sharedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

_$ResultItemDtoImpl _$$ResultItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$ResultItemDtoImpl(
      ordinal: (json['ordinal'] as num).toInt(),
      term: json['term'] as String,
      expectedAnswer: json['expectedAnswer'] as String,
      studentAnswer: json['studentAnswer'] as String?,
      isCorrect: json['isCorrect'] as bool,
    );

Map<String, dynamic> _$$ResultItemDtoImplToJson(_$ResultItemDtoImpl instance) =>
    <String, dynamic>{
      'ordinal': instance.ordinal,
      'term': instance.term,
      'expectedAnswer': instance.expectedAnswer,
      'studentAnswer': instance.studentAnswer,
      'isCorrect': instance.isCorrect,
    };

_$StudentResultDetailDtoImpl _$$StudentResultDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$StudentResultDetailDtoImpl(
  resultId: json['resultId'] as String,
  studentDisplayName: json['studentDisplayName'] as String,
  lessonTitle: json['lessonTitle'] as String,
  gameType: const GameTypeConverter().fromJson(
    (json['gameType'] as num).toInt(),
  ),
  score: (json['score'] as num).toInt(),
  durationMs: (json['durationMs'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  correctItems: (json['correctItems'] as num).toInt(),
  sharedAt:
      json['sharedAt'] == null
          ? null
          : DateTime.parse(json['sharedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ResultItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ResultItemDto>[],
);

Map<String, dynamic> _$$StudentResultDetailDtoImplToJson(
  _$StudentResultDetailDtoImpl instance,
) => <String, dynamic>{
  'resultId': instance.resultId,
  'studentDisplayName': instance.studentDisplayName,
  'lessonTitle': instance.lessonTitle,
  'gameType': const GameTypeConverter().toJson(instance.gameType),
  'score': instance.score,
  'durationMs': instance.durationMs,
  'totalItems': instance.totalItems,
  'correctItems': instance.correctItems,
  'sharedAt': instance.sharedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'items': instance.items.map((e) => e.toJson()).toList(),
};
