import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enrollment_status.dart';

part 'enrollment_dtos.freezed.dart';
part 'enrollment_dtos.g.dart';

/// API'deki int EnrollmentStatus değerini (`1`/`2`/`3`) enum'a çevirir.
class EnrollmentStatusConverter
    implements JsonConverter<EnrollmentStatus, int> {
  const EnrollmentStatusConverter();

  @override
  EnrollmentStatus fromJson(int json) => EnrollmentStatus.fromValue(json);

  @override
  int toJson(EnrollmentStatus object) => object.value;
}

/// POST /api/enrollments/join isteği (JoinByCodeRequest).
@freezed
class JoinByCodeRequest with _$JoinByCodeRequest {
  const factory JoinByCodeRequest({required String code}) = _JoinByCodeRequest;

  factory JoinByCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinByCodeRequestFromJson(json);
}

/// Öğretmenin davet kodu (InviteCodeDto) — GET /api/teachers/me/invite-code.
@freezed
class InviteCodeDto with _$InviteCodeDto {
  const factory InviteCodeDto({required String code}) = _InviteCodeDto;

  factory InviteCodeDto.fromJson(Map<String, dynamic> json) =>
      _$InviteCodeDtoFromJson(json);
}

/// Bir eşleşme kaydı (EnrollmentDto) — API ile birebir.
///
/// Karşı tarafın kimliği rol bağlamına göre doldurulur: öğretmen listelerken
/// counterpart = öğrenci, öğrenci listelerken counterpart = öğretmen.
@freezed
class EnrollmentDto with _$EnrollmentDto {
  const factory EnrollmentDto({
    required String id,
    required String teacherId,
    required String studentId,
    @EnrollmentStatusConverter() required EnrollmentStatus status,
    required String counterpartUserId,
    required String counterpartDisplayName,
    required String counterpartEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EnrollmentDto;

  factory EnrollmentDto.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentDtoFromJson(json);
}
