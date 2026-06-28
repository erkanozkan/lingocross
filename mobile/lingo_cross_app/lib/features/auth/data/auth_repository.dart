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

  /// Şifre sıfırlar: e-postaya gönderilen 6 haneli kod + yeni şifre
  /// (POST /auth/reset-password → 200). Kod hatalı/süresi dolmuş/çok fazla
  /// deneme → 400 ProblemDetails → [AuthFailure.resetCodeInvalid] (varsa
  /// backend `detail`/`title` mesajıyla). Diğer durumlar ağ/genel hataya eşlenir.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post<dynamic>(
        '$_base/auth/reset-password',
        data: ResetPasswordRequest(
          email: email,
          code: code,
          newPassword: newPassword,
        ).toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthFailure.resetCodeInvalid(
          message: _problemDetailsMessage(e.response?.data),
        );
      }
      throw _mapNetworkOrGeneric(e);
    }
  }

  /// ProblemDetails gövdesinden gösterilebilir mesajı çıkarır (`detail`,
  /// yoksa `title`). Beklenmeyen biçim → null (UI genel metne düşer).
  String? _problemDetailsMessage(Object? data) {
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail;
      final title = data['title'];
      if (title is String && title.trim().isNotEmpty) return title;
    }
    return null;
  }

  /// Mevcut kullanıcı profili (GET /auth/me). Authenticated Dio kullanılır;
  /// 401 olursa interceptor refresh dener. Token geçersizse hata fırlatır.
  Future<UserDto> me() async {
    final res = await _dio.get<Map<String, dynamic>>('$_base/auth/me');
    return UserDto.fromJson(res.data!);
  }

  /// Görünen adı (ve opsiyonel dil tercihini) günceller (PUT /auth/me → 200
  /// UserDto). [preferredLocale] verilmezse istekte yer almaz.
  Future<UserDto> updateProfile({
    required String displayName,
    String? preferredLocale,
  }) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '$_base/auth/me',
        data: UpdateProfileRequest(
          displayName: displayName,
          preferredLocale: preferredLocale,
        ).toJson(),
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

  /// Mevcut kullanıcıyı ve tüm verisini kalıcı olarak siler
  /// (DELETE /auth/me → 204). Authenticated Dio; 401'de interceptor refresh
  /// dener. Hata mevcut auth hata eşlemesiyle fırlatılır (UI mesaj gösterir).
  Future<void> deleteAccount() async {
    try {
      await _dio.delete<dynamic>('$_base/auth/me');
    } on DioException catch (e) {
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
