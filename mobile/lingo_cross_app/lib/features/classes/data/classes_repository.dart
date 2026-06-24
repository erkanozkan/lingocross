import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/classes_failure.dart';
import 'dtos/class_dtos.dart';

/// Adlandırılmış sınıf (classes) uçlarıyla konuşan repository (Bearer token
/// interceptor tarafından eklenir):
/// - `GET    /api/classes`                       (Teacher) — sınıflarım
/// - `POST   /api/classes {name}`                (Teacher) — sınıf oluştur
/// - `GET    /api/classes/{id}`                  (Teacher) — sınıf detayı
/// - `PUT    /api/classes/{id} {name}`           (Teacher) — yeniden adlandır
/// - `DELETE /api/classes/{id}`                  (Teacher) — arşivle
/// - `GET    /api/classes/{id}/invite-code`      (Teacher)
/// - `POST   /api/classes/{id}/invite-code/regenerate` (Teacher)
/// - `DELETE /api/classes/{id}/students/{sid}`   (Teacher) — öğrenci çıkar
/// - `GET    /api/classes/me`                    (Student) — katıldığım sınıflar
/// - `POST   /api/classes/join {code}`           (Student) — sınıfa katıl
class ClassesRepository {
  ClassesRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Öğretmenin sınıfları (`GET /api/classes`).
  Future<List<ClassDto>> listMine() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/classes');
      return (res.data ?? const [])
          .map((e) => ClassDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Yeni sınıf oluşturur (`POST /api/classes`).
  Future<ClassDto> create(String name) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/classes',
        data: CreateClassRequest(name: name).toJson(),
      );
      return ClassDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sınıf detayını döndürür (`GET /api/classes/{id}`).
  Future<ClassDetailDto> detail(String classId) async {
    try {
      final res =
          await _dio.get<Map<String, dynamic>>('$_base/classes/$classId');
      return ClassDetailDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sınıfı yeniden adlandırır (`PUT /api/classes/{id}`).
  Future<ClassDto> rename(String classId, String name) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '$_base/classes/$classId',
        data: CreateClassRequest(name: name).toJson(),
      );
      return ClassDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sınıfı arşivler (`DELETE /api/classes/{id}` → 204).
  Future<void> archive(String classId) async {
    try {
      await _dio.delete<void>('$_base/classes/$classId');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sınıfın davet kodu (`GET /api/classes/{id}/invite-code`).
  Future<ClassInviteCodeDto> getInviteCode(String classId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_base/classes/$classId/invite-code',
      );
      return ClassInviteCodeDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Yeni davet kodu üretir (`POST .../invite-code/regenerate`).
  Future<ClassInviteCodeDto> regenerateInviteCode(String classId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/classes/$classId/invite-code/regenerate',
      );
      return ClassInviteCodeDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Bir öğrenciyi sınıftan çıkarır (`DELETE .../students/{sid}` → 204).
  Future<void> removeStudent(String classId, String studentId) async {
    try {
      await _dio.delete<void>('$_base/classes/$classId/students/$studentId');
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğrenci: katıldığı sınıflar (`GET /api/classes/me`).
  Future<List<ClassMembershipDto>> listMemberships() async {
    try {
      final res = await _dio.get<List<dynamic>>('$_base/classes/me');
      return (res.data ?? const [])
          .map((e) => ClassMembershipDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Öğrenci: davet koduyla sınıfa katılır (`POST /api/classes/join`).
  /// Geçersiz/arşivli kod → 404 → [ClassesFailure.invalidCode].
  Future<ClassMembershipDto> joinByCode(String code) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/classes/join',
        data: JoinClassRequest(code: code).toJson(),
      );
      return ClassMembershipDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ClassesFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ClassesFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const ClassesFailure.network();
        return switch (status) {
          404 => const ClassesFailure.notFound(),
          401 || 403 => const ClassesFailure.forbidden(),
          _ => const ClassesFailure.unexpected(),
        };
    }
  }
}

final classesRepositoryProvider = Provider<ClassesRepository>((ref) {
  return ClassesRepository(ref.watch(dioProvider));
});
