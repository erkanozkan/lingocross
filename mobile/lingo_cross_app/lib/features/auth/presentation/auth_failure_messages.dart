import '../../../core/l10n/gen/app_localizations.dart';
import '../domain/auth_failure.dart';

/// AuthFailure → kullanıcıya gösterilecek (genel, sızdırmayan) i18n metni.
String authFailureMessage(Object error, AppLocalizations l10n) {
  if (error is AuthFailure) {
    return switch (error) {
      InvalidCredentials() => l10n.authLoginErrorInvalidCredentials,
      EmailTaken() => l10n.authRegisterErrorEmailTaken,
      WrongCurrentPassword() => l10n.accountChangePasswordWrongCurrent,
      // Backend 400 mesajı varsa onu göster; yoksa genel "kod hatalı" metni.
      ResetCodeInvalid(:final message) =>
        (message != null && message.trim().isNotEmpty)
            ? message
            : l10n.authResetErrorCodeInvalid,
      NetworkFailure() => l10n.authLoginErrorNetwork,
      UnexpectedFailure() => l10n.commonErrorGeneric,
    };
  }
  return l10n.commonErrorGeneric;
}
