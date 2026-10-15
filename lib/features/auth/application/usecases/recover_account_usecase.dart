import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/domain/value_objects/account_password.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';

/// Recovers a Registered Account with its one-time recovery code
/// (SPEC.md §7.2): validates the code server-side, sets the new password
/// and reissues a fresh code — the returned value is that new code,
/// shown to the user exactly once like the original. The old code is
/// dead the moment this succeeds.
class RecoverAccountUseCase {
  /// Creates the use case over the account port.
  const new(this._accounts);

  final AccountRepository _accounts;

  /// Recovers the account and returns the new recovery code.
  Future<Result<String, AppFailure>> call({
    required String username,
    required String recoveryCode,
    required String newPassword,
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
    if (recoveryCode.trim().isEmpty) {
      return const Result.err(
        ValidationFailure('Recovery code cannot be empty'),
      );
    }
    final passwordResult = AccountPassword.parse(newPassword);
    if (passwordResult.isErr) {
      return Result.err(passwordResult.failureOrNull!);
    }

    return await _accounts.recover(
      username: usernameResult.valueOrNull!,
      recoveryCode: recoveryCode,
      newPassword: passwordResult.valueOrNull!.value,
    );
  }
}
