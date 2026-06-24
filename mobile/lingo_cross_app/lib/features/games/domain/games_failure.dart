import 'package:freezed_annotation/freezed_annotation.dart';

part 'games_failure.freezed.dart';

/// Oyun işlemlerinde sunum katmanına taşınan hata türleri.
///
/// Repository [DioException]'ı bu tiplere indirger; ekranlar i18n metnini
/// `games_failure_messages.dart` üzerinden çözer.
@freezed
class GamesFailure with _$GamesFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory GamesFailure.network() = _Network;

  /// Kaynak bulunamadı (404) — örn. ders/oyun yok.
  const factory GamesFailure.notFound() = _NotFound;

  /// Yetkisiz / yasak (401/403) — örn. enrolled olmayan öğrenci.
  const factory GamesFailure.forbidden() = _Forbidden;

  /// Yetersiz kelime / oynatılamaz (400) — oyun üretilemiyor.
  const factory GamesFailure.insufficientWords() = _InsufficientWords;

  /// Beklenmeyen sunucu hatası.
  const factory GamesFailure.unexpected() = _Unexpected;
}
