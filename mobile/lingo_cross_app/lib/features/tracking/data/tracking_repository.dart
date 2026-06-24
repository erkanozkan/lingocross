import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/tracking_failure.dart';
import 'dtos/tracking_dtos.dart';

/// Öğretmen takip (teachers/me) uçlarıyla konuşan repository.
///
/// - `GET /api/teachers/me/students` (Teacher) → öğrenci özetleri (paylaşılan
///   sonuç sayısı + ortalama + son aktivite).
/// - `GET /api/teachers/me/students/{studentId}/results` (Teacher) → o öğrencinin
///   paylaştığı sonuçlar (yeniden eskiye sıralanır).
///
/// Bearer token interceptor tarafından eklenir.
class TrackingRepository {
  TrackingRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Öğretmenin öğrenci özetleri (ada göre alfabetik sıralanır).
  Future<List<StudentSummaryDto>> listStudents() async {
    try {
      final res =
          await _dio.get<List<dynamic>>('$_base/teachers/me/students');
      final list =
          (res.data ?? const [])
              .map((e) => StudentSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => a.displayName
                .toLowerCase()
                .compareTo(b.displayName.toLowerCase()));
      return list;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Bir öğrencinin paylaştığı sonuçlar (en yeni → en eski sıralanır).
  Future<List<SharedResultDto>> listStudentResults(String studentId) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '$_base/teachers/me/students/$studentId/results',
      );
      final list =
          (res.data ?? const [])
              .map((e) => SharedResultDto.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5).
  Future<StudentResultDetailDto> getStudentResultDetail(
    String studentId,
    String resultId,
  ) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/teachers/me/students/$studentId/results/$resultId',
      );
      return StudentResultDetailDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  TrackingFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const TrackingFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const TrackingFailure.network();
        return switch (status) {
          401 || 403 => const TrackingFailure.forbidden(),
          404 => const TrackingFailure.notFound(),
          _ => const TrackingFailure.unexpected(),
        };
    }
  }
}

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepository(ref.watch(dioProvider));
});
