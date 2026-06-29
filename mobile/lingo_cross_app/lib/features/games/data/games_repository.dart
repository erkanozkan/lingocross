import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/game_type.dart';
import '../domain/games_failure.dart';
import 'dtos/game_dtos.dart';

/// Oyun (games / game-sessions) uçlarıyla konuşan repository.
///
/// - `POST /api/lessons/{lessonId}/games` (Teacher) → oyun oluştur + yayınla
/// - `GET  /api/lessons/{lessonId}/games` (Teacher) → dersin oyunları
/// - `GET  /api/teachers/me/games`        (Teacher) → tüm bulmacaları (Bulmacalarım)
/// - `POST /api/games/{gameId}/share`     (Teacher) → bulmacayı yeniden yayınla
/// - `GET  /api/games/assigned`           (Student) → atanan (yayımlı) oyunlar
/// - `POST /api/games/{gameId}/sessions`  (Student) → oturum + içerik
/// - `GET  /api/game-sessions/{sessionId}` (Student) → oturum durumu
/// - `GET  /api/question-topics`          (Teacher) → atanabilir soru konuları
/// - `POST /api/question-topics/{id}/assignments` (Teacher) → sınıf atamaları
/// - `GET  /api/question-topics/{id}/assignments` (Teacher) → mevcut atamalar
///
/// Bearer token interceptor tarafından eklenir.
class GamesRepository {
  GamesRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Öğretmen: bir derste oyun oluşturur ve yayınlar (`POST .../games`).
  ///
  /// Yetersiz kelime (400) → [GamesFailure.insufficientWords].
  Future<GameDto> createGame(String lessonId, CreateGameRequest request) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/lessons/$lessonId/games',
        data: request.toJson(),
      );
      return GameDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen: bir derste [type] türünde oluşturulacak bulmacanın ÖRNEK
  /// önizlemesini döndürür (`POST .../games/preview`). Kalıcı değildir.
  ///
  /// Yetersiz kelime (400) → [GamesFailure.insufficientWords].
  Future<GamePreviewResponse> previewGame(String lessonId, GameType type) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/lessons/$lessonId/games/preview',
        data: {'type': type.value},
      );
      return GamePreviewResponse.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen: dersin oyunlarını döndürür (`GET .../games`).
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

  /// Öğretmen: tüm derslerindeki bulmacaları döndürür (Bulmacalarım —
  /// `GET /api/teachers/me/games`).
  Future<List<TeacherPuzzleDto>> listMyPuzzles() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/teachers/me/games');
      return (res.data ?? const [])
          .map((e) => TeacherPuzzleDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen: bir bulmacayı (yeniden) paylaşır/yayınlar — idempotent
  /// (`POST /api/games/{gameId}/share`).
  Future<GameDto> sharePuzzle(String gameId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/games/$gameId/share',
      );
      return GameDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğrenci: kendisine atanmış (yayımlanmış) oyunları döndürür
  /// (`GET /api/games/assigned`).
  Future<List<AssignedGameDto>> listAssigned() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/games/assigned');
      return (res.data ?? const [])
          .map((e) => AssignedGameDto.fromJson(e as Map<String, dynamic>))
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

  /// Öğretmen: atanabilir soru konularını döndürür (Çıkmış Sorular —
  /// `GET /api/question-topics`).
  Future<List<QuestionTopicDto>> listQuestionTopics() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/question-topics');
      return (res.data ?? const [])
          .map((e) => QuestionTopicDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen: bir konunun sınıf atamalarını ayarlar (idempotent —
  /// `POST /api/question-topics/{topicId}/assignments`). Boş liste tüm
  /// atamaları kaldırır.
  Future<GameAssignmentsDto> setTopicAssignments(
    String topicId,
    List<String> classIds,
  ) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/question-topics/$topicId/assignments',
        data: {'classIds': classIds},
      );
      return GameAssignmentsDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğretmen: bir konunun mevcut sınıf atamalarını döndürür
  /// (`GET /api/question-topics/{topicId}/assignments`).
  Future<GameAssignmentsDto> getTopicAssignments(String topicId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/question-topics/$topicId/assignments',
      );
      return GameAssignmentsDto.fromJson(res.data!);
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
