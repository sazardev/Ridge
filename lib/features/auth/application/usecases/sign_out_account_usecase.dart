import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

/// Signs out of the Registered Account and unlinks the on-device profile,
/// which goes back to being a Guest Profile — history included, since
/// nothing local is deleted on sign-out (SPEC.md §7.1: a Guest Profile's
/// data lives and dies with the device; signing out just stops syncing
/// it to the account).
class SignOutAccountUseCase {
  /// Creates the use case over the account and profile ports.
  const new(this._accounts, this._profiles);

  final AccountRepository _accounts;
  final ProfileRepository _profiles;

  /// Signs out and unlinks the local profile, if any.
  Future<Result<void, AppFailure>> call() async {
    final signOutResult = await _accounts.signOut();
    if (signOutResult.isErr) {
      return Result.err(signOutResult.failureOrNull!);
    }
    await _profiles.unlinkAccount();
    return const Result.ok(null);
  }
}
