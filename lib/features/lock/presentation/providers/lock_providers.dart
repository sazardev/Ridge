import 'package:just_in_time/core/security/secure_storage_provider.dart';
import 'package:just_in_time/features/lock/application/usecases/clear_pin_usecase.dart';
import 'package:just_in_time/features/lock/application/usecases/set_pin_usecase.dart';
import 'package:just_in_time/features/lock/application/usecases/verify_pin_usecase.dart';
import 'package:just_in_time/features/lock/domain/repositories/pin_repository.dart';
import 'package:just_in_time/features/lock/infrastructure/pin_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lock_providers.g.dart';

@Riverpod(keepAlive: true)
PinRepository pinRepository(Ref ref) {
  return PinRepositoryImpl(ref.watch(secureStorageProvider));
}

@riverpod
SetPinUseCase setPinUseCase(Ref ref) {
  return SetPinUseCase(ref.watch(pinRepositoryProvider));
}

@riverpod
VerifyPinUseCase verifyPinUseCase(Ref ref) {
  return VerifyPinUseCase(ref.watch(pinRepositoryProvider));
}

@riverpod
ClearPinUseCase clearPinUseCase(Ref ref) {
  return ClearPinUseCase(ref.watch(pinRepositoryProvider));
}

@riverpod
Future<bool> hasPin(Ref ref) {
  return ref.watch(pinRepositoryProvider).hasPin();
}

/// Whether the current app session has already been unlocked. In-memory
/// only and on purpose: a fresh process launch must always re-prompt.
@Riverpod(keepAlive: true)
class AppLockSession extends _$AppLockSession {
  @override
  bool build() => false;

  void unlock() => state = true;

  void lock() => state = false;
}
