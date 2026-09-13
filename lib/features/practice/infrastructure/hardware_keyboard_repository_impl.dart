import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ridge/features/practice/domain/repositories/hardware_keyboard_repository.dart';

/// [HardwareKeyboardRepository] adapter. Android is the only platform
/// where a physical keyboard isn't a given (STACK.md §1) — a small native
/// `MethodChannel` (`MainActivity.kt`) answers whether any
/// currently-attached `InputDevice` is a real, non-virtual alphabetic
/// keyboard. Polled rather than pushed from the native side — simpler
/// than a second `EventChannel` for a check this cheap, and frequent
/// enough (every [_pollInterval]) that pairing or dropping a Bluetooth
/// keyboard mid-session is picked up without perceptible delay.
class HardwareKeyboardRepositoryImpl implements HardwareKeyboardRepository {
  /// Creates the adapter.
  const new();

  static const _channel = MethodChannel(
    'dev.omarcodes.ridge/hardware_keyboard',
  );
  static const _pollInterval = Duration(seconds: 2);

  @override
  Stream<bool> watchConnected() async* {
    if (!Platform.isAndroid) {
      yield true;
      return;
    }
    while (true) {
      yield await _isConnected();
      await Future<void>.delayed(_pollInterval);
    }
  }

  Future<bool> _isConnected() async {
    try {
      return await _channel.invokeMethod<bool>('isConnected') ?? true;
    } on Exception {
      return true;
    }
  }
}
