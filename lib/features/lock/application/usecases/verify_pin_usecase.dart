import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/lock/domain/repositories/pin_repository.dart';

class VerifyPinUseCase {
  const new(this._repository);

  final PinRepository _repository;

  Future<Result<bool, AppFailure>> call(String pin) =>
      _repository.verifyPin(pin);
}
