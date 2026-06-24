// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClassDtoImpl _$$ClassDtoImplFromJson(Map<String, dynamic> json) =>
    _$ClassDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      inviteCode: json['inviteCode'] as String?,
      studentCount: (json['studentCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClassDtoImplToJson(_$ClassDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'inviteCode': instance.inviteCode,
      'studentCount': instance.studentCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ClassMemberDtoImpl _$$ClassMemberDtoImplFromJson(Map<String, dynamic> json) =>
    _$ClassMemberDtoImpl(
      studentId: json['studentId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$ClassMemberDtoImplToJson(
  _$ClassMemberDtoImpl instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'displayName': instance.displayName,
  'email': instance.email,
};

_$ClassDetailDtoImpl _$$ClassDetailDtoImplFromJson(Map<String, dynamic> json) =>
    _$ClassDetailDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      inviteCode: json['inviteCode'] as String?,
      studentCount: (json['studentCount'] as num).toInt(),
      students:
          (json['students'] as List<dynamic>)
              .map((e) => ClassMemberDto.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$ClassDetailDtoImplToJson(
  _$ClassDetailDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'inviteCode': instance.inviteCode,
  'studentCount': instance.studentCount,
  'students': instance.students.map((e) => e.toJson()).toList(),
};

_$ClassMembershipDtoImpl _$$ClassMembershipDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ClassMembershipDtoImpl(
  classId: json['classId'] as String,
  className: json['className'] as String,
  teacherName: json['teacherName'] as String,
);

Map<String, dynamic> _$$ClassMembershipDtoImplToJson(
  _$ClassMembershipDtoImpl instance,
) => <String, dynamic>{
  'classId': instance.classId,
  'className': instance.className,
  'teacherName': instance.teacherName,
};

_$CreateClassRequestImpl _$$CreateClassRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateClassRequestImpl(name: json['name'] as String);

Map<String, dynamic> _$$CreateClassRequestImplToJson(
  _$CreateClassRequestImpl instance,
) => <String, dynamic>{'name': instance.name};

_$ClassInviteCodeDtoImpl _$$ClassInviteCodeDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ClassInviteCodeDtoImpl(code: json['code'] as String);

Map<String, dynamic> _$$ClassInviteCodeDtoImplToJson(
  _$ClassInviteCodeDtoImpl instance,
) => <String, dynamic>{'code': instance.code};

_$JoinClassRequestImpl _$$JoinClassRequestImplFromJson(
  Map<String, dynamic> json,
) => _$JoinClassRequestImpl(code: json['code'] as String);

Map<String, dynamic> _$$JoinClassRequestImplToJson(
  _$JoinClassRequestImpl instance,
) => <String, dynamic>{'code': instance.code};
