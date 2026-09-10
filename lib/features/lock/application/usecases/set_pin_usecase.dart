import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/lock/domain/repositories/pin_repository.dart';

/// Sets (or replaces) the app-lock PIN, rejecting anything too short.
class SetPinUseCase {
  /// Creates the use case over the given [PinRepository] port.
  const new(this._repository);

  final PinRepository _repository;

  /// Validates and persists [pin]. Returns a [ValidationFailure] without
  /// touching the repository if it's shorter than 4 digits.
  Future<Result<void, AppFailure>> call(String pin) {
    if (pin.length < 4) {
      return Future.value(
        const Result.err(ValidationFailure('PIN must be at least 4 digits')),
      );
    }
    return _repository.setPin(pin);
  }
}
