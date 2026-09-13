import 'package:ridge/features/practice/domain/repositories/hardware_keyboard_repository.dart';

/// Watches whether a physical/Bluetooth keyboard is currently attached —
/// see [HardwareKeyboardRepository.watchConnected].
class WatchHardwareKeyboardConnectedUseCase {
  /// Creates the use case over the given [HardwareKeyboardRepository] port.
  const new(this._repository);

  final HardwareKeyboardRepository _repository;

  /// See [HardwareKeyboardRepository.watchConnected].
  Stream<bool> call() => _repository.watchConnected();
}
