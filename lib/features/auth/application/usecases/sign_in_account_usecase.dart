import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

/// Signs into an existing Registered Account (SPEC.md §7.2) and reconciles
/// the on-device profile with it:
///
/// - profile exists and is unlinked: it is relinked to the account (its
///   local history joins the account timeline — SPEC.md §8.3's "events
///   are only ever appended" model), renamed to the account username when
///   they differ;
/// - no profile exists yet (a fresh install signing in): one is created
///   under the account's username and linked, so the device has a local
///   identity immediately — pulling the account's historical sessions
///   down is the sync work tracked for a later phase (STACK.md §6).
class SignInAccountUseCase {
  /// Creates the use case over the account and profile ports.
  const new(this._accounts, this._profiles);

  final AccountRepository _accounts;
  final ProfileRepository _profiles;

  /// Signs in with [username]/[password] and links the local profile.
  Future<Result<RegisteredAccount, AppFailure>> call({
    required String username,
    required String password,
  }) async {
    if (!_accounts.isSupported) {
      return const Result.err(
        UnexpectedFailure('Registered accounts are not available here'),
      );
    }
    final parsed = AccountUsername.parse(username);
    if (parsed.isErr) {
      return Result.err(parsed.failureOrNull!);
    }
    if (password.isEmpty) {
      return const Result.err(ValidationFailure('Password cannot be empty'));
    }

    final signInResult = await _accounts.signIn(
      username: parsed.valueOrNull!,
      password: password,
    );
    if (signInResult.isErr) {
      return Result.err(signInResult.failureOrNull!);
    }
    final account = signInResult.valueOrNull!;

    await _reconcileLocalProfile(account);
    return Result.ok(account);
  }

  /// Best-effort local reconciliation, mirroring
  /// `RegisterAccountUseCase`'s reasoning: the sign-in itself already
  /// succeeded and must not be reported as failed because a local write
  /// went wrong.
  Future<void> _reconcileLocalProfile(RegisteredAccount account) async {
    final current = await _profiles.watchActiveProfile().first;
    if (current == null) {
      final created = await _profiles.createGuestProfile(account.username);
      if (created.isErr) return;
    } else {
      if (current.username != account.username) {
        await _profiles.renameProfile(account.username);
      }
      if (current.accountUid == account.uid) return;
    }
    await _profiles.linkAccount(accountUid: account.uid);
  }
}
