// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherStatsDtoImpl _$$TeacherStatsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TeacherStatsDtoImpl(
  classCount: (json['classCount'] as num).toInt(),
  studentCount: (json['studentCount'] as num).toInt(),
  weeklyAssignedCount: (json['weeklyAssignedCount'] as num).toInt(),
  weeklyCompletedCount: (json['weeklyCompletedCount'] as num).toInt(),
  completionRate: (json['completionRate'] as num).toInt(),
);

Map<String, dynamic> _$$TeacherStatsDtoImplToJson(
  _$TeacherStatsDtoImpl instance,
) => <String, dynamic>{
  'classCount': instance.classCount,
  'studentCount': instance.studentCount,
  'weeklyAssignedCount': instance.weeklyAssignedCount,
  'weeklyCompletedCount': instance.weeklyCompletedCount,
  'completionRate': instance.completionRate,
};
