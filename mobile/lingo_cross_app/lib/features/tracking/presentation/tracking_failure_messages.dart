import '../../../core/l10n/gen/app_localizations.dart';
import '../domain/tracking_failure.dart';

/// [TrackingFailure]'ı kullanıcıya gösterilecek i18n metnine çevirir.
String trackingFailureMessage(Object error, AppLocalizations l10n) {
  if (error is TrackingFailure) {
    return error.when(
      network: () => l10n.trackingErrorNetwork,
      notFound: () => l10n.trackingErrorNotFound,
      forbidden: () => l10n.trackingErrorForbidden,
      unexpected: () => l10n.commonErrorGeneric,
    );
  }
  return l10n.commonErrorGeneric;
}
