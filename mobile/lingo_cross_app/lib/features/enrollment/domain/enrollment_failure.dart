import 'package:freezed_annotation/freezed_annotation.dart';

part 'enrollment_failure.freezed.dart';

/// Enrollment (katılım / davet kodu) işlemlerinde sunum katmanına taşınan
/// hata türleri. Repository [DioException]'ı bu tiplere indirger; ekranlar
/// (örn. JoinTeacherScreen) `.when` ile i18n metnini çözer.
@freezed
class EnrollmentFailure with _$EnrollmentFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory EnrollmentFailure.network() = _Network;

  /// Geçersiz davet kodu (404).
  const factory EnrollmentFailure.invalidCode() = _InvalidCode;

  /// Süresi geçmiş davet kodu (410).
  const factory EnrollmentFailure.expiredCode() = _ExpiredCode;

  /// Yetkisiz / yasak (401/403).
  const factory EnrollmentFailure.forbidden() = _Forbidden;

  /// Beklenmeyen sunucu hatası.
  const factory EnrollmentFailure.unexpected() = _Unexpected;
}
