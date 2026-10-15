import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';

/// What a successful registration hands back: the freshly created
/// account plus the one-time recovery code (SPEC.md §7.2) — shown to
/// the user exactly once, never stored in clear anywhere.
typedef AccountRegistration = ({
  RegisteredAccount account,
  String recoveryCode,
});

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter (Firebase Auth + the `register`/
/// `recoverAccount`/`deleteAccount` Cloud Functions on supported
/// platforms, a no-op that reports itself unsupported on Linux).
///
/// Every method returns [Result] — never a thrown exception across the
/// port (AGENTS.md's error-handling contract).
abstract interface class AccountRepository {
  /// Whether this platform can actually back a Registered Account
  /// (Firebase has no Linux desktop client — Linux stays Guest-only).
  bool get isSupported;

  /// Emits the currently signed-in account, or `null` while signed out,
  /// and every change after it — the client SDK restores the session
  /// across app restarts, so this is also how a registered user stays
  /// signed in.
  Stream<RegisteredAccount?> watchCurrentAccount();

  /// Registers [username] with [password] server-side (the function
  /// validates uniqueness, creates the auth user with an internal
  /// synthetic email, writes the profile and mints the recovery code).
  Future<Result<AccountRegistration, AppFailure>> register({
    required AccountUsername username,
    required String password,
  });

  /// Signs into the account behind [username] with [password] — a
  /// direct client-side sign-in, no server round-trip, so login stays
  /// fast and works with intermittent connectivity (STACK.md §5.2).
  Future<Result<RegisteredAccount, AppFailure>> signIn({
    required AccountUsername username,
    required String password,
  });

  /// Signs out of the current account. The on-device profile (and its
  /// history) is left alone — callers decide whether to unlink it.
  Future<Result<void, AppFailure>> signOut();

  /// Permanently deletes the current account: the cloud identity, the
  /// remote profile and its uniqueness/recovery records.
  Future<Result<void, AppFailure>> deleteAccount();

  /// Recovers the account behind [username] with a one-time
  /// [recoveryCode], setting [newPassword] and invalidating/reissuing
  /// the recovery code — the returned value is the *new* code.
  Future<Result<String, AppFailure>> recover({
    required AccountUsername username,
    required String recoveryCode,
    required String newPassword,
  });
}
