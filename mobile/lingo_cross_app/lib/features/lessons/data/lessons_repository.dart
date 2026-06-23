import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/lessons_failure.dart';
import 'dtos/lesson_dtos.dart';
import 'dtos/word_dtos.dart';

/// Lessons/Words uçlarıyla konuşan repository.
///
/// Tüm uçlar Teacher rolü + Bearer (token interceptor tarafından eklenir):
/// - `GET/POST  /api/lessons`
/// - `GET/PUT/DELETE /api/lessons/{id}`
/// - `POST /api/lessons/{id}/publish`
/// - `GET/POST /api/lessons/{id}/words`
/// - `PUT/DELETE /api/words/{wordId}`
class LessonsRepository {
  LessonsRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  // --- Lessons ---

  Future<List<LessonDto>> listLessons() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/lessons');
      return (res.data ?? const [])
          .map((e) => LessonDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<LessonDto> getLesson(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_base/lessons/$id');
      return LessonDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<LessonDto> createLesson(CreateLessonRequest request) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/lessons',
        data: request.toJson(),
      );
      return LessonDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<LessonDto> updateLesson(String id, UpdateLessonRequest request) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '$_base/lessons/$id',
        data: request.toJson(),
      );
      return LessonDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> deleteLesson(String id) async {
    try {
      await _dio.delete<dynamic>('$_base/lessons/$id');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<LessonDto> publishLesson(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/lessons/$id/publish',
      );
      return LessonDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // --- Words ---

  Future<List<WordDto>> listWords(String lessonId) async {
    try {
      final res =
          await _dio.get<List<dynamic>>('$_base/lessons/$lessonId/words');
      return (res.data ?? const [])
          .map((e) => WordDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<WordDto> addWord(String lessonId, AddWordRequest request) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/lessons/$lessonId/words',
        data: request.toJson(),
      );
      return WordDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<WordDto> updateWord(String wordId, UpdateWordRequest request) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '$_base/words/$wordId',
        data: request.toJson(),
      );
      return WordDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> deleteWord(String wordId) async {
    try {
      await _dio.delete<dynamic>('$_base/words/$wordId');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  LessonsFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const LessonsFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const LessonsFailure.network();
        return switch (status) {
          404 => const LessonsFailure.notFound(),
          401 || 403 => const LessonsFailure.forbidden(),
          400 || 422 => const LessonsFailure.validation(),
          _ => const LessonsFailure.unexpected(),
        };
    }
  }
}

final lessonsRepositoryProvider = Provider<LessonsRepository>((ref) {
  return LessonsRepository(ref.watch(dioProvider));
});
