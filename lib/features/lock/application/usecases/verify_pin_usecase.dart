import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/lock/domain/repositories/pin_repository.dart';

/// Checks a candidate PIN against the stored salted hash.
class VerifyPinUseCase {
  /// Creates the use case over the given [PinRepository] port.
  const new(this._repository);

  final PinRepository _repository;

  /// Returns `true` on a match, `false` on a mismatch, or a failure if the
  /// stored credential couldn't be read.
  Future<Result<bool, AppFailure>> call(String pin) =>
      _repository.verifyPin(pin);
}
