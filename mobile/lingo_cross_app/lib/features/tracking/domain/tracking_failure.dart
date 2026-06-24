import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_failure.freezed.dart';

/// Öğretmen takip (tracking) işlemlerinde sunum katmanına taşınan hata türleri.
///
/// Repository [DioException]'ı bu tiplere indirger; ekranlar i18n metnini
/// `tracking_failure_messages.dart` üzerinden çözer.
@freezed
class TrackingFailure with _$TrackingFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory TrackingFailure.network() = _Network;

  /// Kaynak bulunamadı (404) — örn. öğrenci yok veya öğretmenin değil.
  const factory TrackingFailure.notFound() = _NotFound;

  /// Yetkisiz / yasak (401/403).
  const factory TrackingFailure.forbidden() = _Forbidden;

  /// Beklenmeyen sunucu hatası.
  const factory TrackingFailure.unexpected() = _Unexpected;
}
