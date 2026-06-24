import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/games_failure.dart';
import 'dtos/game_dtos.dart';

/// Oyun (games / game-sessions) uçlarıyla konuşan repository.
///
/// - `GET  /api/lessons/{lessonId}/games` (Teacher/Student) → oyun listesi
/// - `POST /api/games/{gameId}/sessions`  (Student) → oturum + içerik
/// - `GET  /api/game-sessions/{sessionId}` (Student) → oturum durumu
///
/// Bearer token interceptor tarafından eklenir; M4'te sonuç gönderimi YOK (M5).
class GamesRepository {
  GamesRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Dersin oyunlarını döndürür (öğretmen için WordMatching yoksa API üretir).
  Future<List<GameDto>> listForLesson(String lessonId) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '$_base/lessons/$lessonId/games',
      );
      return (res.data ?? const [])
          .map((e) => GameDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Bir oyun için yeni oturum başlatır; üretilmiş eşleştirme içeriğiyle döner.
  Future<StartGameSessionResponse> startSession(String gameId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/games/$gameId/sessions',
      );
      return StartGameSessionResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Bir oturumun güncel durumu (yalnız sahibi öğrenci).
  Future<GameSessionDto> getSession(String sessionId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/game-sessions/$sessionId',
      );
      return GameSessionDto.fromJson(res.data!);
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
          // 400 = yetersiz kelime / oynatılamaz (servis BadRequest fırlatır).
          400 || 422 => const GamesFailure.insufficientWords(),
          401 || 403 => const GamesFailure.forbidden(),
          404 => const GamesFailure.notFound(),
          _ => const GamesFailure.unexpected(),
        };
    }
  }
}

final gamesRepositoryProvider = Provider<GamesRepository>((ref) {
  return GamesRepository(ref.watch(dioProvider));
});
