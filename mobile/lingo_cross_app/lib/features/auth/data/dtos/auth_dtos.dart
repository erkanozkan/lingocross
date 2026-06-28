import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/user_role.dart';

part 'auth_dtos.freezed.dart';
part 'auth_dtos.g.dart';

/// API'deki int rol değerini (`1`/`2`) [UserRole] enum'una çevirir.
class UserRoleConverter implements JsonConverter<UserRole, int> {
  const UserRoleConverter();

  @override
  UserRole fromJson(int json) => UserRole.fromValue(json);

  @override
  int toJson(UserRole object) => object.value;
}

/// POST /api/auth/register isteği (RegisterRequest).
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String password,
    required String displayName,
    @UserRoleConverter() required UserRole role,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// POST /api/auth/login isteği (LoginRequest).
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// POST /api/auth/refresh isteği (RefreshRequest).
@freezed
class RefreshRequest with _$RefreshRequest {
  const factory RefreshRequest({required String refreshToken}) =
      _RefreshRequest;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
}

/// POST /api/auth/logout isteği (LogoutRequest).
@freezed
class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({required String refreshToken}) = _LogoutRequest;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
}

/// POST /api/auth/forgot-password isteği (ForgotPasswordRequest).
@freezed
class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({required String email}) =
      _ForgotPasswordRequest;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
}

/// PUT /api/auth/me isteği — görünen ad + (opsiyonel) dil tercihi güncelleme
/// (UpdateProfileRequest). `displayName` zorunlu kalır; `preferredLocale` yalnız
/// verildiğinde gönderilir (null gönderilmez → mevcut backend davranışı korunur).
@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    required String displayName,
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) String? preferredLocale,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}

/// POST /api/auth/change-password isteği (ChangePasswordRequest).
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// POST /api/auth/reset-password isteği (ResetPasswordRequest).
///
/// Backend sözleşmesi: `{ email, code, newPassword }`. Kod tam 6 rakam, 15 dk
/// geçerli; hata → 400 ProblemDetails.
@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String email,
    required String code,
    required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

/// Kullanıcı (UserDto).
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String displayName,
    @UserRoleConverter() required UserRole role,
    required String preferredLocale,
    String? inviteCode,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

/// Giriş/kayıt/yenileme yanıtı (AuthResponse).
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
    required UserDto user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
