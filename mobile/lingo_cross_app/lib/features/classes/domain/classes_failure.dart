import 'package:freezed_annotation/freezed_annotation.dart';

part 'classes_failure.freezed.dart';

/// Sınıf (classes) işlemlerinde sunum katmanına taşınan hata türleri.
///
/// Repository [DioException]'ı bu tiplere indirger; ekranlar `.when` ile i18n
/// metnini çözer. [invalidCode] sınıfa katılırken geçersiz/arşivli koddur (404).
@freezed
class ClassesFailure with _$ClassesFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory ClassesFailure.network() = _Network;

  /// Geçersiz / arşivli davet kodu (404 — sınıfa katılma).
  const factory ClassesFailure.invalidCode() = _InvalidCode;

  /// Kaynak bulunamadı (404 — sınıf/öğrenci yok).
  const factory ClassesFailure.notFound() = _NotFound;

  /// Yetkisiz / yasak (401/403).
  const factory ClassesFailure.forbidden() = _Forbidden;

  /// Beklenmeyen sunucu hatası.
  const factory ClassesFailure.unexpected() = _Unexpected;
}
