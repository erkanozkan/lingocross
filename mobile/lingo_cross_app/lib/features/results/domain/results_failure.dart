import 'package:freezed_annotation/freezed_annotation.dart';

part 'results_failure.freezed.dart';

/// Sonuç (results) işlemlerinde sunum katmanına taşınan hata türleri.
///
/// Repository [DioException]'ı bu tiplere indirger; ekranlar i18n metnini
/// `results_failure_messages.dart` üzerinden çözer.
@freezed
class ResultsFailure with _$ResultsFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory ResultsFailure.network() = _Network;

  /// Kaynak bulunamadı (404) — örn. oturum/sonuç yok veya sahibi değil.
  const factory ResultsFailure.notFound() = _NotFound;

  /// Yetkisiz / yasak (401/403).
  const factory ResultsFailure.forbidden() = _Forbidden;

  /// Beklenmeyen sunucu hatası.
  const factory ResultsFailure.unexpected() = _Unexpected;
}
