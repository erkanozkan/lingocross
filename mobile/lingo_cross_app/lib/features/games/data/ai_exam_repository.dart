import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/games_failure.dart';
import 'dtos/ai_exam_dtos.dart';

/// Yapay zekâ ile sınav soruları (ai-questions) uçlarıyla konuşan repository.
///
/// - `POST   /api/lessons/{lessonId}/ai-questions` (Teacher) → soru üret
/// - `DELETE /api/question-topics/{topicId}/questions/{questionId}` (Teacher) → 204
///
/// Atama için mevcut `GamesRepository.setTopicAssignments` yeniden kullanılır
/// (yeni uç eklenmez). Bearer token interceptor tarafından eklenir.
class AiExamRepository {
  AiExamRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Öğretmen: bir dersin içeriğinden yapay zekâ ile çoktan seçmeli sorular
  /// üretir (`POST .../ai-questions`).
  ///
  /// Hatalar: 400 → [GamesFailure.insufficientWords] (yetersiz kelime / geçersiz
  /// count-types), 404 → [GamesFailure.notFound] (ders sahibi değil), 503 →
  /// [GamesFailure.aiUnavailable] (AI yapılandırılmamış).
  Future<AiExamResultDto> generate(
    String lessonId,
    AiExamGenerateRequest request,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/lessons/$lessonId/ai-questions',
        data: request.toJson(),
      );
      return AiExamResultDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen: üretilen bir soruyu konudan siler (`DELETE
  /// .../question-topics/{topicId}/questions/{questionId}` → 204).
  Future<void> deleteQuestion(String topicId, String questionId) async {
    try {
      await _dio.delete<void>(
        '$_base/question-topics/$topicId/questions/$questionId',
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  GamesFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const GamesFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const GamesFailure.network();
        return switch (status) {
          // 400 = yetersiz kelime / geçersiz count-types.
          400 || 422 => const GamesFailure.insufficientWords(),
          401 || 403 => const GamesFailure.forbidden(),
          404 => const GamesFailure.notFound(),
          // 503 = AI yapılandırılmamış (Anthropic anahtarı yok).
          503 => const GamesFailure.aiUnavailable(),
          _ => const GamesFailure.unexpected(),
        };
    }
  }
}

final aiExamRepositoryProvider = Provider<AiExamRepository>((ref) {
  return AiExamRepository(ref.watch(dioProvider));
});
