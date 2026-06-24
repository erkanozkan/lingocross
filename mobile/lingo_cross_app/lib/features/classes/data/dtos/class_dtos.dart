import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_dtos.freezed.dart';
part 'class_dtos.g.dart';

/// Bir sınıfın özeti (ClassDto) — API ile birebir.
///
/// `GET /api/classes` ve `POST/PUT /api/classes` yanıtlarında döner.
/// [inviteCode] arşivli/yeniden üretildiğinde değişebilir; liste yanıtında
/// null olabilir.
@freezed
class ClassDto with _$ClassDto {
  const factory ClassDto({
    required String id,
    required String name,
    String? inviteCode,
    required int studentCount,
    required DateTime createdAt,
  }) = _ClassDto;

  factory ClassDto.fromJson(Map<String, dynamic> json) =>
      _$ClassDtoFromJson(json);
}

/// Bir sınıfın öğrenci satırı (ClassMemberDto) — sınıf detayında listelenir.
@freezed
class ClassMemberDto with _$ClassMemberDto {
  const factory ClassMemberDto({
    required String studentId,
    required String displayName,
    required String email,
  }) = _ClassMemberDto;

  factory ClassMemberDto.fromJson(Map<String, dynamic> json) =>
      _$ClassMemberDtoFromJson(json);
}

/// Sınıf detayı (ClassDetailDto) — `GET /api/classes/{id}`.
@freezed
class ClassDetailDto with _$ClassDetailDto {
  const factory ClassDetailDto({
    required String id,
    required String name,
    String? inviteCode,
    required int studentCount,
    required List<ClassMemberDto> students,
  }) = _ClassDetailDto;

  factory ClassDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ClassDetailDtoFromJson(json);
}

/// Öğrencinin katıldığı bir sınıf (ClassMembershipDto) — `GET /api/classes/me`
/// ve `POST /api/classes/join` yanıtı.
@freezed
class ClassMembershipDto with _$ClassMembershipDto {
  const factory ClassMembershipDto({
    required String classId,
    required String className,
    required String teacherName,
  }) = _ClassMembershipDto;

  factory ClassMembershipDto.fromJson(Map<String, dynamic> json) =>
      _$ClassMembershipDtoFromJson(json);
}

/// Sınıf oluşturma / yeniden adlandırma isteği (CreateClassRequest).
@freezed
class CreateClassRequest with _$CreateClassRequest {
  const factory CreateClassRequest({required String name}) =
      _CreateClassRequest;

  factory CreateClassRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateClassRequestFromJson(json);
}

/// Davet kodu yanıtı (InviteCodeDto) — `GET .../invite-code` ve regenerate.
@freezed
class ClassInviteCodeDto with _$ClassInviteCodeDto {
  const factory ClassInviteCodeDto({required String code}) =
      _ClassInviteCodeDto;

  factory ClassInviteCodeDto.fromJson(Map<String, dynamic> json) =>
      _$ClassInviteCodeDtoFromJson(json);
}

/// Sınıfa katılma isteği (öğrenci) — `POST /api/classes/join`.
@freezed
class JoinClassRequest with _$JoinClassRequest {
  const factory JoinClassRequest({required String code}) = _JoinClassRequest;

  factory JoinClassRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinClassRequestFromJson(json);
}
