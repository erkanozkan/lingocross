import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/profile_failure.dart';
import 'dtos/teacher_stats_dto.dart';

/// Öğretmen profil istatistikleriyle konuşan repository.
///
/// `GET /api/teachers/me/stats` (Teacher) → sınıf/öğrenci sayısı + haftalık
/// atanan/tamamlanan ödev + katılım oranı. Bearer token interceptor tarafından
/// eklenir.
class TeacherStatsRepository {
  TeacherStatsRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Geçerli öğretmenin profil istatistiklerini getirir.
  Future<TeacherStatsDto> fetchMyStats() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/teachers/me/stats',
      );
      return TeacherStatsDto.fromJson(res.data!);
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

final teacherStatsRepositoryProvider = Provider<TeacherStatsRepository>((ref) {
  return TeacherStatsRepository(ref.watch(dioProvider));
});
