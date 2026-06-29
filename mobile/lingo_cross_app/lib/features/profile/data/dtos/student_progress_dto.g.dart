// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentProgressDtoImpl _$$StudentProgressDtoImplFromJson(
  Map<String, dynamic> json,
) => _$StudentProgressDtoImpl(
  gamesPlayed: (json['gamesPlayed'] as num).toInt(),
  averageAccuracy: (json['averageAccuracy'] as num).toInt(),
  accuracyTrendDelta: (json['accuracyTrendDelta'] as num?)?.toInt(),
  weeklyMinutes: (json['weeklyMinutes'] as num).toInt(),
  weeklyGoalMinutes: (json['weeklyGoalMinutes'] as num).toInt(),
  streakDays: (json['streakDays'] as num).toInt(),
);

Map<String, dynamic> _$$StudentProgressDtoImplToJson(
  _$StudentProgressDtoImpl instance,
) => <String, dynamic>{
  'gamesPlayed': instance.gamesPlayed,
  'averageAccuracy': instance.averageAccuracy,
  'accuracyTrendDelta': instance.accuracyTrendDelta,
  'weeklyMinutes': instance.weeklyMinutes,
  'weeklyGoalMinutes': instance.weeklyGoalMinutes,
  'streakDays': instance.streakDays,
};
