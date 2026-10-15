import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';

/// The no-op [AccountRepository] for platforms where Firebase has no
/// client (Linux desktop — see `firebase_bootstrap.dart`): always signed
/// out, every account-creating or account-using operation fails cleanly
/// with a localized-as-`UnexpectedFailure` message instead of throwing at
/// the plugin boundary. The UI hides the account entry points behind
/// [isSupported] anyway; this exists so the app never has to null-check
/// the port.
class UnsupportedAccountRepository implements AccountRepository {
  /// Creates the no-op adapter.
  const new();

  @override
  bool get isSupported => false;

  @override
  Stream<RegisteredAccount?> watchCurrentAccount() =>
      Stream<RegisteredAccount?>.value(null);

  @override
  Future<Result<AccountRegistration, AppFailure>> register({
    required AccountUsername username,
    required String password,
  }) async => const Result.err(
    UnexpectedFailure('Registered accounts are not available on this platform'),
  );

  @override
  Future<Result<RegisteredAccount, AppFailure>> signIn({
    required AccountUsername username,
    required String password,
  }) async => const Result.err(
    UnexpectedFailure('Registered accounts are not available on this platform'),
  );

  @override
  Future<Result<void, AppFailure>> signOut() async => const Result.ok(null);

  @override
  Future<Result<void, AppFailure>> deleteAccount() async => const Result.err(
    UnexpectedFailure('Registered accounts are not available on this platform'),
  );

  @override
  Future<Result<String, AppFailure>> recover({
    required AccountUsername username,
    required String recoveryCode,
    required String newPassword,
  }) async => const Result.err(
    UnexpectedFailure('Registered accounts are not available on this platform'),
  );
}
