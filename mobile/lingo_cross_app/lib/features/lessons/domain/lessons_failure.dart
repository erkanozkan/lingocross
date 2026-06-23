import 'package:freezed_annotation/freezed_annotation.dart';

part 'lessons_failure.freezed.dart';

/// Ders/kelime işlemlerinde sunum katmanına taşınan hata türleri.
///
/// Repository [DioException]'ı bu tiplere indirger; ekranlar i18n metnini
/// `lessons_failure_messages.dart` üzerinden çözer.
@freezed
class LessonsFailure with _$LessonsFailure {
  /// Ağ / bağlantı hatası (timeout, no response).
  const factory LessonsFailure.network() = _Network;

  /// Kaynak bulunamadı (404).
  const factory LessonsFailure.notFound() = _NotFound;

  /// Yetkisiz / yasak (403) — örn. başka öğretmenin dersi.
  const factory LessonsFailure.forbidden() = _Forbidden;

  /// Doğrulama / istek hatası (400).
  const factory LessonsFailure.validation() = _Validation;

  /// Beklenmeyen sunucu hatası.
  const factory LessonsFailure.unexpected() = _Unexpected;
}
