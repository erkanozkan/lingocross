import '../../../core/l10n/gen/app_localizations.dart';
import '../domain/results_failure.dart';

/// [ResultsFailure]'ı kullanıcıya gösterilecek i18n metnine çevirir.
String resultsFailureMessage(Object error, AppLocalizations l10n) {
  if (error is ResultsFailure) {
    return error.when(
      network: () => l10n.resultsErrorNetwork,
      notFound: () => l10n.resultsErrorNotFound,
      forbidden: () => l10n.resultsErrorForbidden,
      unexpected: () => l10n.commonErrorGeneric,
    );
  }
  return l10n.commonErrorGeneric;
}
