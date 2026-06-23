import '../../../core/l10n/gen/app_localizations.dart';
import '../domain/lessons_failure.dart';

/// LessonsFailure → kullanıcıya gösterilecek i18n metni.
String lessonsFailureMessage(Object error, AppLocalizations l10n) {
  if (error is LessonsFailure) {
    return error.when(
      network: () => l10n.lessonsErrorNetwork,
      notFound: () => l10n.lessonsErrorNotFound,
      forbidden: () => l10n.lessonsErrorForbidden,
      validation: () => l10n.lessonsErrorValidation,
      unexpected: () => l10n.commonErrorGeneric,
    );
  }
  return l10n.commonErrorGeneric;
}
