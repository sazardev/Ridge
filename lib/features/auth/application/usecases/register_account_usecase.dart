import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/domain/value_objects/account_password.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

/// Registers a Registered Account (SPEC.md §7.2) and converts the
/// on-device Guest Profile into it — the "Migración desde Invitado" the
/// spec promises: the account is created remotely, then the local
/// profile is renamed to the (validated) account username and linked to
/// the new uid, so its whole history travels with it from now on.
///
/// The remote half is the `register` Cloud Function: it validates
/// uniqueness, creates the Firebase Auth user behind the internal
/// synthetic email, writes the profile document and mints the one-time
/// recovery code, returned here for the UI to show exactly once.
class RegisterAccountUseCase {
  /// Creates the use case over the account and profile ports.
  const new(this._accounts, this._profiles);

  final AccountRepository _accounts;
  final ProfileRepository _profiles;

  /// Validates the credentials and registers the account.
  Future<Result<AccountRegistration, AppFailure>> call({
    required String username,
    required String password,
  }) async {
    if (!_accounts.isSupported) {
      return const Result.err(
        UnexpectedFailure('Registered accounts are not available here'),
      );
    }
    final usernameResult = AccountUsername.parse(username);
    if (usernameResult.isErr) {
      return Result.err(usernameResult.failureOrNull!);
    }
    final passwordResult = AccountPassword.parse(password);
    if (passwordResult.isErr) {
      return Result.err(passwordResult.failureOrNull!);
    }

    final registrationResult = await _accounts.register(
      username: usernameResult.valueOrNull!,
      password: passwordResult.valueOrNull!.value,
    );
    if (registrationResult.isErr) {
      return Result.err(registrationResult.failureOrNull!);
    }
    final registration = registrationResult.valueOrNull!;

    // Local conversion is best-effort *after* the critical part: the
    // account exists remotely and the recovery code must reach the
    // user, so a local write failure here never fails the whole flow —
    // a later sign-in re-links the profile anyway.
    await _profiles.renameProfile(registration.account.username);
    await _profiles.linkAccount(accountUid: registration.account.uid);
    return Result.ok(registration);
  }
}
