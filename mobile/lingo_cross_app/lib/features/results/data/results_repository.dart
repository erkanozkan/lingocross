import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/results_failure.dart';
import 'dtos/result_dtos.dart';

/// Oyun sonucu (results / game-sessions) uçlarıyla konuşan repository.
///
/// - `POST /api/game-sessions/{sessionId}/result` (Student) → sonuç gönderir,
///   oturumu tamamlar; oturum başına tek sonuç (tekrar gönderimde mevcut döner).
/// - `POST /api/results/{resultId}/share` (Student) → öğretmenle paylaşır.
/// - `GET  /api/results/me` (Student) → öğrencinin geçmiş sonuçları.
///
/// Bearer token interceptor tarafından eklenir.
class ResultsRepository {
  ResultsRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Bir oturum için sonuç gönderir; hesaplanmış skorla [GameResultDto] döner.
  Future<GameResultDto> submitResult(
    String sessionId,
    SubmitResultRequest request,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/game-sessions/$sessionId/result',
        data: request.toJson(),
      );
      return GameResultDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Bir sonucu öğretmenle paylaşır; güncel [GameResultDto] döner
  /// (`sharedWithTeacher = true`).
  Future<GameResultDto> share(String resultId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/results/$resultId/share',
      );
      return GameResultDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Geçerli öğrencinin geçmiş sonuçları (en yeni → en eski sıralanır).
  Future<List<GameResultDto>> listMine() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/results/me');
      final list =
          (res.data ?? const [])
              .map((e) => GameResultDto.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ResultsFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ResultsFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const ResultsFailure.network();
        return switch (status) {
          401 || 403 => const ResultsFailure.forbidden(),
          404 => const ResultsFailure.notFound(),
          _ => const ResultsFailure.unexpected(),
        };
    }
  }
}

final resultsRepositoryProvider = Provider<ResultsRepository>((ref) {
  return ResultsRepository(ref.watch(dioProvider));
});
