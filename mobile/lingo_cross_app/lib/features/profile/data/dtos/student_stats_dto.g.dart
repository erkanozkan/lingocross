// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentStatsDtoImpl _$$StudentStatsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$StudentStatsDtoImpl(
  gamesPlayed: (json['gamesPlayed'] as num).toInt(),
  averageAccuracy: (json['averageAccuracy'] as num).toInt(),
);

Map<String, dynamic> _$$StudentStatsDtoImplToJson(
  _$StudentStatsDtoImpl instance,
) => <String, dynamic>{
  'gamesPlayed': instance.gamesPlayed,
  'averageAccuracy': instance.averageAccuracy,
};
