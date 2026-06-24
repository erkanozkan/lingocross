import '../../../core/l10n/gen/app_localizations.dart';
import '../domain/games_failure.dart';

/// GamesFailure → kullanıcıya gösterilecek i18n metni.
String gamesFailureMessage(Object error, AppLocalizations l10n) {
  if (error is GamesFailure) {
    return error.when(
      network: () => l10n.gameStartErrorNetwork,
      notFound: () => l10n.gameStartErrorNotFound,
      forbidden: () => l10n.gameStartErrorForbidden,
      insufficientWords: () => l10n.gameStartErrorInsufficientWords,
      unexpected: () => l10n.commonErrorGeneric,
    );
  }
  return l10n.commonErrorGeneric;
}
