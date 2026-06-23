import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/enrollment_failure.dart';
import 'dtos/enrollment_dtos.dart';

/// Enrollment / davet kodu uçlarıyla konuşan repository (Bearer token
/// interceptor tarafından eklenir):
/// - `POST /api/enrollments/join`        (Student) — davet koduyla katıl
/// - `GET  /api/enrollments`             (rol-bazlı) — kendi eşleşmelerim
/// - `GET  /api/teachers/me/invite-code` (Teacher) — davet kodu
/// - `POST /api/teachers/me/invite-code/regenerate` (Teacher) — yeni kod
class EnrollmentRepository {
  EnrollmentRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Öğrenci, davet koduyla bir öğretmene katılır. API idempotent: zaten
  /// kayıtlıysa (409) yine başarı (mevcut kayıt) döner — bu durumu çağıran
  /// taraf başarı gibi ele alır.
  Future<EnrollmentDto> joinByCode(String code) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/enrollments/join',
        data: JoinByCodeRequest(code: code).toJson(),
      );
      return EnrollmentDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Oturum açan kullanıcının eşleşmeleri (öğrenci → öğretmenler).
  Future<List<EnrollmentDto>> listMine() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/enrollments');
      return (res.data ?? const [])
          .map((e) => EnrollmentDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmenin aktif davet kodu (yoksa API üretir).
  Future<InviteCodeDto> getInviteCode() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/teachers/me/invite-code',
      );
      return InviteCodeDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen için yeni davet kodu üretir (eskisi geçersizleşir).
  Future<InviteCodeDto> regenerateInviteCode() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/teachers/me/invite-code/regenerate',
      );
      return InviteCodeDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  EnrollmentFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const EnrollmentFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const EnrollmentFailure.network();
        return switch (status) {
          404 => const EnrollmentFailure.invalidCode(),
          410 => const EnrollmentFailure.expiredCode(),
          401 || 403 => const EnrollmentFailure.forbidden(),
          _ => const EnrollmentFailure.unexpected(),
        };
    }
  }
}

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  return EnrollmentRepository(ref.watch(dioProvider));
});
