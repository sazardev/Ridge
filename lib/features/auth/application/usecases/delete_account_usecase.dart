import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/data_management/domain/repositories/data_reset_repository.dart';

/// Permanently deletes the current Registered Account (SPEC.md §7.2 —
/// and the store requirement that account creation inside an app always
/// has an in-app deletion path): the cloud identity goes first, and only
/// once that succeeded is the whole local dataset wiped, exactly like
/// the Settings > "delete all data" reset. If the remote deletion fails
/// (e.g. offline), nothing local is touched so the user can retry — no
/// half-deleted state where the account still exists remotely but its
/// device copy is gone.
class DeleteAccountUseCase {
  /// Creates the use case over the account and data-reset ports.
  const new(this._accounts, this._dataReset);

  final AccountRepository _accounts;
  final DataResetRepository _dataReset;

  /// Deletes the account remotely, then wipes every local table.
  Future<Result<void, AppFailure>> call() async {
    if (!_accounts.isSupported) {
      return const Result.err(
        UnexpectedFailure('Registered accounts are not available here'),
      );
    }
    final deleteResult = await _accounts.deleteAccount();
    if (deleteResult.isErr) {
      return Result.err(deleteResult.failureOrNull!);
    }
    return await _dataReset.wipeAllData();
  }
}
