import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/auth_failure.dart';
import '../domain/user_role.dart';
import 'dtos/auth_dtos.dart';

/// Auth uçlarıyla konuşan repository (POST /api/auth/*).
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/auth/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );
      return AuthResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapLoginError(e);
    }
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/auth/register',
        data: RegisterRequest(
          email: email,
          password: password,
          displayName: displayName,
          role: role,
        ).toJson(),
      );
      return AuthResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapRegisterError(e);
    }
  }

  /// Güvenlik gereği başarısızlıkta dahi hata fırlatmaz; yalnız ağ hatasında
  /// [AuthFailure.network] döner (UX spec: kayıtlı olmayan e-posta → success).
  Future<void> forgotPassword({required String email}) async {
    try {
      await _dio.post<dynamic>(
        '$_base/auth/forgot-password',
        data: ForgotPasswordRequest(email: email).toJson(),
      );
    } on DioException catch (e) {
      throw _mapNetworkOrGeneric(e);
    }
  }

  /// Mevcut kullanıcı profili (GET /auth/me). Authenticated Dio kullanılır;
  /// 401 olursa interceptor refresh dener. Token geçersizse hata fırlatır.
  Future<UserDto> me() async {
    final res = await _dio.get<Map<String, dynamic>>('$_base/auth/me');
    return UserDto.fromJson(res.data!);
  }

  /// Görünen adı günceller (PUT /auth/me → 200 UserDto).
  Future<UserDto> updateProfile({required String displayName}) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '$_base/auth/me',
        data: UpdateProfileRequest(displayName: displayName).toJson(),
      );
      return UserDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapNetworkOrGeneric(e);
    }
  }

  /// Şifre değiştirir (POST /auth/change-password → 200 AuthResponse, yeni
  /// token'larla). Yanlış mevcut şifre → 400 → [WrongCurrentPassword].
  Future<AuthResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/auth/change-password',
        data: ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ).toJson(),
      );
      return AuthResponse.fromJson(res.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw const AuthFailure.wrongCurrentPassword();
      }
      throw _mapNetworkOrGeneric(e);
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      await _dio.post<dynamic>(
        '$_base/auth/logout',
        data: LogoutRequest(refreshToken: refreshToken).toJson(),
      );
    } on DioException catch (_) {
      // Logout best-effort; lokal temizlik her halükârda yapılır.
    }
  }

  AuthFailure _mapLoginError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401 || status == 400) {
      return const AuthFailure.invalidCredentials();
    }
    return _mapNetworkOrGeneric(e);
  }

  AuthFailure _mapRegisterError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 409) {
      return const AuthFailure.emailTaken();
    }
    return _mapNetworkOrGeneric(e);
  }

  AuthFailure _mapNetworkOrGeneric(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const AuthFailure.network();
      default:
        if (e.response == null) return const AuthFailure.network();
        return const AuthFailure.unexpected();
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});
