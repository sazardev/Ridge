import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';

/// Driven port for OS-level biometric authentication (fingerprint/Face ID),
/// used as an optional unlock shortcut alongside the PIN. Not every device
/// or platform supports this — see [isAvailable].
abstract interface class BiometricAuthRepository {
  /// Whether this device currently exposes usable biometric authentication:
  /// supported hardware, an enrolled fingerprint/face, and a platform
  /// implementation (no Linux/Web support exists — see `STACK.md §3.2`).
  /// Never throws; returns `false` for any platform/hardware gap.
  Future<bool> isAvailable();

  /// Prompts the OS biometric UI, showing [reason] where the platform
  /// supports a custom prompt message. Resolves `false` (not an [Err]) on
  /// a user cancel or a plain non-match — an [Err] is reserved for a
  /// genuine platform-level failure.
  Future<Result<bool, AppFailure>> authenticate({required String reason});
}
