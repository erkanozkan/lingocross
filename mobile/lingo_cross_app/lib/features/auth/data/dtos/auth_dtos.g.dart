// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  displayName: json['displayName'] as String,
  role: const UserRoleConverter().fromJson((json['role'] as num).toInt()),
);

Map<String, dynamic> _$$RegisterRequestImplToJson(
  _$RegisterRequestImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'displayName': instance.displayName,
  'role': const UserRoleConverter().toJson(instance.role),
};

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$RefreshRequestImpl _$$RefreshRequestImplFromJson(Map<String, dynamic> json) =>
    _$RefreshRequestImpl(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$$RefreshRequestImplToJson(
  _$RefreshRequestImpl instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$LogoutRequestImpl(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

_$ForgotPasswordRequestImpl _$$ForgotPasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ForgotPasswordRequestImpl(email: json['email'] as String);

Map<String, dynamic> _$$ForgotPasswordRequestImplToJson(
  _$ForgotPasswordRequestImpl instance,
) => <String, dynamic>{'email': instance.email};

_$UpdateProfileRequestImpl _$$UpdateProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateProfileRequestImpl(
  displayName: json['displayName'] as String,
  preferredLocale: json['preferredLocale'] as String?,
);

Map<String, dynamic> _$$UpdateProfileRequestImplToJson(
  _$UpdateProfileRequestImpl instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  if (instance.preferredLocale case final value?) 'preferredLocale': value,
};

_$ChangePasswordRequestImpl _$$ChangePasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ChangePasswordRequestImpl(
  currentPassword: json['currentPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$ChangePasswordRequestImplToJson(
  _$ChangePasswordRequestImpl instance,
) => <String, dynamic>{
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ResetPasswordRequestImpl(
  token: json['token'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
  _$ResetPasswordRequestImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'newPassword': instance.newPassword,
};

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: const UserRoleConverter().fromJson((json['role'] as num).toInt()),
      preferredLocale: json['preferredLocale'] as String,
      inviteCode: json['inviteCode'] as String?,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'role': const UserRoleConverter().toJson(instance.role),
      'preferredLocale': instance.preferredLocale,
      'inviteCode': instance.inviteCode,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['accessToken'] as String,
      accessTokenExpiresAt: DateTime.parse(
        json['accessTokenExpiresAt'] as String,
      ),
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiresAt: DateTime.parse(
        json['refreshTokenExpiresAt'] as String,
      ),
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt.toIso8601String(),
      'refreshToken': instance.refreshToken,
      'refreshTokenExpiresAt': instance.refreshTokenExpiresAt.toIso8601String(),
      'user': instance.user.toJson(),
    };
