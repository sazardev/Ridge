import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/lock/domain/repositories/biometric_auth_repository.dart';
import 'package:local_auth/local_auth.dart';

/// `local_auth` adapter for [BiometricAuthRepository]. Android, iOS/macOS
/// and Windows each ship their own native implementation behind this same
/// API; Linux and Web have none, so every call is wrapped defensively and
/// degrades to "unavailable" rather than throwing (`STACK.md §3.2`).
class LocalAuthBiometricRepository implements BiometricAuthRepository {
  /// Creates the adapter over the given `local_auth` plugin instance.
  new(this._auth);

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.canCheckBiometrics) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on Exception {
      return false;
    }
  }

  @override
  Future<Result<bool, AppFailure>> authenticate({
    required String reason,
  }) async {
    try {
      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
      return Result.ok(didAuthenticate);
    } on LocalAuthException catch (e) {
      if (_isBenign(e.code)) return const Result.ok(false);
      return Result.err(
        UnexpectedFailure('Biometric authentication failed', cause: e),
      );
    } on Exception catch (e) {
      return Result.err(
        UnexpectedFailure('Biometric authentication failed', cause: e),
      );
    }
  }

  /// Codes that mean "biometrics just isn't happening right now" (user
  /// canceled, backgrounded, temporarily unavailable, nothing enrolled) —
  /// these resolve to a plain `false` so the caller falls back to the PIN
  /// keypad in silence instead of surfacing an error. Everything else
  /// (lockouts, device errors, unrecognized future codes) is a real
  /// failure worth telling the user about.
  bool _isBenign(LocalAuthExceptionCode code) => switch (code) {
    LocalAuthExceptionCode.userCanceled ||
    LocalAuthExceptionCode.systemCanceled ||
    LocalAuthExceptionCode.timeout ||
    LocalAuthExceptionCode.userRequestedFallback ||
    LocalAuthExceptionCode.uiUnavailable ||
    LocalAuthExceptionCode.authInProgress ||
    LocalAuthExceptionCode.noBiometricsEnrolled ||
    LocalAuthExceptionCode.noBiometricHardware ||
    LocalAuthExceptionCode.noCredentialsSet ||
    LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable => true,
    _ => false,
  };
}
