import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';

/// Driven port for app-lock credentials. Implementations must never
/// persist the raw PIN — only a salted hash.
abstract interface class PinRepository {
  /// Whether an app-lock PIN has been set.
  Future<bool> hasPin();

  /// Hashes and persists [pin] as the new app-lock credential.
  Future<Result<void, AppFailure>> setPin(String pin);

  /// Compares [pin] against the stored hash.
  Future<Result<bool, AppFailure>> verifyPin(String pin);

  /// Deletes the stored PIN credential.
  Future<Result<void, AppFailure>> clearPin();
}
