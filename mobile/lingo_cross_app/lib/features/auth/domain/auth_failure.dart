import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

/// Auth akışlarındaki tipli hata türleri. Sunum katmanı bunları i18n
/// metinlerine eşler (kimlik bilgisi sızdırmayan genel mesajlar).
@freezed
sealed class AuthFailure with _$AuthFailure {
  /// 401/400 — login'de e-posta/şifre hatalı.
  const factory AuthFailure.invalidCredentials() = InvalidCredentials;

  /// 409 — register'da e-posta zaten kayıtlı.
  const factory AuthFailure.emailTaken() = EmailTaken;

  /// Ağ/bağlantı hatası.
  const factory AuthFailure.network() = NetworkFailure;

  /// Beklenmeyen sunucu hatası.
  const factory AuthFailure.unexpected() = UnexpectedFailure;
}
