import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/lesson_status.dart';

part 'lesson_dtos.freezed.dart';
part 'lesson_dtos.g.dart';

/// API'deki int LessonStatus değerini (`1`/`2`/`3`) [LessonStatus] enum'una çevirir.
class LessonStatusConverter implements JsonConverter<LessonStatus, int> {
  const LessonStatusConverter();

  @override
  LessonStatus fromJson(int json) => LessonStatus.fromValue(json);

  @override
  int toJson(LessonStatus object) => object.value;
}

/// POST /api/lessons isteği (CreateLessonRequest).
///
/// Diller verilmezse API en→tr varsayar; UI yine de varsayılanları gönderir.
/// [scheduledLabel] serbest metin (örn. "15-21 Temmuz 2024").
@freezed
class CreateLessonRequest with _$CreateLessonRequest {
  const factory CreateLessonRequest({
    required String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
    String? scheduledLabel,
  }) = _CreateLessonRequest;

  factory CreateLessonRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLessonRequestFromJson(json);
}

/// PUT /api/lessons/{id} isteği (UpdateLessonRequest).
///
/// Yayımlama durumu ayrı uçlardan (`publish`/`unpublish`/`complete`) yönetilir.
@freezed
class UpdateLessonRequest with _$UpdateLessonRequest {
  const factory UpdateLessonRequest({
    required String title,
    String? description,
    String? sourceLanguage,
    String? targetLanguage,
    String? scheduledLabel,
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
    String? scheduledLabel,
    @LessonStatusConverter() required LessonStatus status,
    required bool isPublished,
    required int wordCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LessonDto;

  factory LessonDto.fromJson(Map<String, dynamic> json) =>
      _$LessonDtoFromJson(json);
}
