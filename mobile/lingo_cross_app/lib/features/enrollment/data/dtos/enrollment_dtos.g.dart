// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JoinByCodeRequestImpl _$$JoinByCodeRequestImplFromJson(
  Map<String, dynamic> json,
) => _$JoinByCodeRequestImpl(code: json['code'] as String);

Map<String, dynamic> _$$JoinByCodeRequestImplToJson(
  _$JoinByCodeRequestImpl instance,
) => <String, dynamic>{'code': instance.code};

_$InviteCodeDtoImpl _$$InviteCodeDtoImplFromJson(Map<String, dynamic> json) =>
    _$InviteCodeDtoImpl(code: json['code'] as String);

Map<String, dynamic> _$$InviteCodeDtoImplToJson(_$InviteCodeDtoImpl instance) =>
    <String, dynamic>{'code': instance.code};

_$EnrollmentDtoImpl _$$EnrollmentDtoImplFromJson(Map<String, dynamic> json) =>
    _$EnrollmentDtoImpl(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      studentId: json['studentId'] as String,
      status: const EnrollmentStatusConverter().fromJson(
        (json['status'] as num).toInt(),
      ),
      counterpartUserId: json['counterpartUserId'] as String,
      counterpartDisplayName: json['counterpartDisplayName'] as String,
      counterpartEmail: json['counterpartEmail'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EnrollmentDtoImplToJson(_$EnrollmentDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'studentId': instance.studentId,
      'status': const EnrollmentStatusConverter().toJson(instance.status),
      'counterpartUserId': instance.counterpartUserId,
      'counterpartDisplayName': instance.counterpartDisplayName,
      'counterpartEmail': instance.counterpartEmail,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
