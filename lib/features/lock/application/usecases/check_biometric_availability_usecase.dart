import 'package:just_in_time/features/lock/domain/repositories/biometric_auth_repository.dart';

/// Checks whether biometric unlock can be offered on this device at all.
class CheckBiometricAvailabilityUseCase {
  /// Creates the use case over the given [BiometricAuthRepository] port.
  const new(this._repository);

  final BiometricAuthRepository _repository;

  /// See [BiometricAuthRepository.isAvailable].
  Future<bool> call() => _repository.isAvailable();
}
