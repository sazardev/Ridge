import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';

/// Driven port for app-lock credentials. Implementations must never
/// persist the raw PIN — only a salted hash.
abstract interface class PinRepository {
  Future<bool> hasPin();

  Future<Result<void, AppFailure>> setPin(String pin);

  Future<Result<bool, AppFailure>> verifyPin(String pin);

  Future<Result<void, AppFailure>> clearPin();
}
