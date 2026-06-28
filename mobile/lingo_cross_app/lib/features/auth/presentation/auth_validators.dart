import '../../../core/l10n/gen/app_localizations.dart';

/// Mobil tarafı API ile aynı kuralları uygular (bkz. AuthValidators.cs):
/// - E-posta: boş değil + geçerli format (+ register'da max 256).
/// - Şifre: boş değil; register'da min 8, max 128.
/// - Ad Soyad: boş değil, max 128.
abstract final class AuthValidators {
  AuthValidators._();

  // RFC'ye yakın, pratik e-posta regex'i.
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static String? email(String? value, AppLocalizations l10n) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l10n.authValidationEmailRequired;
    if (v.length > 256 || !_emailRegExp.hasMatch(v)) {
      return l10n.authValidationEmailInvalid;
    }
    return null;
  }

  /// Login: yalnız boş kontrolü (API login'de min uzunluk dayatmaz).
  static String? loginPassword(String? value, AppLocalizations l10n) {
    if ((value ?? '').isEmpty) return l10n.authValidationPasswordRequired;
    return null;
  }

  /// Register: min 8 (API kuralı).
  static String? newPassword(String? value, AppLocalizations l10n) {
    final v = value ?? '';
    if (v.isEmpty) return l10n.authValidationPasswordRequired;
    if (v.length < 8) return l10n.authValidationPasswordTooShort;
    return null;
  }

  static String? fullName(String? value, AppLocalizations l10n) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l10n.authValidationFullNameRequired;
    return null;
  }

  static final RegExp _sixDigits = RegExp(r'^\d{6}$');

  /// Şifre sıfırlama kodu: tam 6 rakam (API kuralı).
  static String? resetCode(String? value, AppLocalizations l10n) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l10n.authValidationCodeRequired;
    if (!_sixDigits.hasMatch(v)) return l10n.authValidationCodeInvalid;
    return null;
  }

  /// Yeni şifre (tekrar): boş değil + [original] ile birebir eşit.
  static String? confirmPassword(
    String? value,
    String original,
    AppLocalizations l10n,
  ) {
    final v = value ?? '';
    if (v.isEmpty) return l10n.authValidationPasswordRequired;
    if (v != original) return l10n.authValidationPasswordMismatch;
    return null;
  }
}
