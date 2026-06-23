import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_dtos.freezed.dart';
part 'lesson_dtos.g.dart';

/// POST /api/lessons isteği (CreateLessonRequest).
///
/// Diller verilmezse API en→tr varsayar; UI yine de varsayılanları gönderir.
@freezed
class CreateLessonRequest with _$CreateLessonRequest {
  const factory CreateLessonRequest({
    required String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
  }) = _CreateLessonRequest;

  factory CreateLessonRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLessonRequestFromJson(json);
}

/// PUT /api/lessons/{id} isteği (UpdateLessonRequest).
///
/// Yayımlama durumu ayrı uçtan (`POST /lessons/{id}/publish`) yönetilir.
@freezed
class UpdateLessonRequest with _$UpdateLessonRequest {
  const factory UpdateLessonRequest({
    required String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
  }) = _UpdateLessonRequest;

  factory UpdateLessonRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLessonRequestFromJson(json);
}

/// Ders (LessonDto) — API ile birebir.
@freezed
class LessonDto with _$LessonDto {
  const factory LessonDto({
    required String id,
    required String teacherId,
    required String title,
    String? description,
    required String sourceLanguage,
    required String targetLanguage,
    required bool isPublished,
    required int wordCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LessonDto;

  factory LessonDto.fromJson(Map<String, dynamic> json) =>
      _$LessonDtoFromJson(json);
}
