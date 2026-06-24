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
