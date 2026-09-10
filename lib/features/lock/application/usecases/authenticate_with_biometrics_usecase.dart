import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/lock/domain/repositories/biometric_auth_repository.dart';

/// Runs the OS biometric prompt as an alternative to typing the PIN.
class AuthenticateWithBiometricsUseCase {
  /// Creates the use case over the given [BiometricAuthRepository] port.
  const new(this._repository);

  final BiometricAuthRepository _repository;

  /// See [BiometricAuthRepository.authenticate].
  Future<Result<bool, AppFailure>> call({required String reason}) =>
      _repository.authenticate(reason: reason);
}
