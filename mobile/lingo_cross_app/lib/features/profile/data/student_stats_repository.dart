import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/profile_failure.dart';
import 'dtos/student_stats_dto.dart';

/// Öğrenci profil istatistikleriyle konuşan repository.
///
/// `GET /api/students/me/stats` (Student) → tamamlanmış oyun sayısı + ortalama
/// başarı puanı. Bearer token interceptor tarafından eklenir.
class StudentStatsRepository {
  StudentStatsRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Geçerli öğrencinin profil istatistiklerini getirir.
  Future<StudentStatsDto> fetchMyStats() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/students/me/stats',
      );
      return StudentStatsDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ProfileFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ProfileFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const ProfileFailure.network();
        return switch (status) {
          401 || 403 => const ProfileFailure.forbidden(),
          _ => const ProfileFailure.unexpected(),
        };
    }
  }
}

final studentStatsRepositoryProvider = Provider<StudentStatsRepository>((ref) {
  return StudentStatsRepository(ref.watch(dioProvider));
});
