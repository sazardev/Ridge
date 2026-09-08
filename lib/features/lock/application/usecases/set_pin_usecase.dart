import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/lock/domain/repositories/pin_repository.dart';

class SetPinUseCase {
  const new(this._repository);

  final PinRepository _repository;

  Future<Result<void, AppFailure>> call(String pin) {
    if (pin.length < 4) {
      return Future.value(
        const Result.err(ValidationFailure('PIN must be at least 4 digits')),
      );
    }
    return _repository.setPin(pin);
  }
}
