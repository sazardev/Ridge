import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/lock/domain/repositories/pin_repository.dart';

/// Removes the app-lock PIN entirely, disabling the lock.
class ClearPinUseCase {
  /// Creates the use case over the given [PinRepository] port.
  const new(this._repository);

  final PinRepository _repository;

  /// Deletes the stored hash and salt.
  Future<Result<void, AppFailure>> call() => _repository.clearPin();
}
