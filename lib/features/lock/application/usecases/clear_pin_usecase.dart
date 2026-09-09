import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/lock/domain/repositories/pin_repository.dart';

/// Removes the app-lock PIN entirely, disabling the lock.
class ClearPinUseCase {
  /// Creates the use case over the given [PinRepository] port.
  const new(this._repository);

  final PinRepository _repository;

  /// Deletes the stored hash and salt.
  Future<Result<void, AppFailure>> call() => _repository.clearPin();
}
