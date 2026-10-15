import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';

/// Maps an [AppFailure] from any account operation to a localized,
/// user-facing message — the only translation seam for the `auth`
/// feature (the failures themselves deliberately carry English,
/// developer-facing messages).
String accountErrorMessage(AppFailure failure, AppLocalizations l10n) {
  return switch (failure) {
    ValidationFailure() => l10n.accountErrorInvalidInput,
    UnauthorizedFailure() => l10n.accountErrorBadCredentials,
    NotFoundFailure() => l10n.accountErrorNoSuchAccount,
    StorageFailure() || UnexpectedFailure() => l10n.accountErrorConnection,
  };
}
