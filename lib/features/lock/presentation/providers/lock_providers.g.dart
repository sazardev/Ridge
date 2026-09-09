// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lock_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [PinRepository] implementation used across the app.

@ProviderFor(pinRepository)
final pinRepositoryProvider = PinRepositoryProvider._();

/// Provides the [PinRepository] implementation used across the app.

final class PinRepositoryProvider
    extends $FunctionalProvider<PinRepository, PinRepository, PinRepository>
    with $Provider<PinRepository> {
  /// Provides the [PinRepository] implementation used across the app.
  PinRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinRepositoryHash();

  @$internal
  @override
  $ProviderElement<PinRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinRepository create(Ref ref) {
    return pinRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinRepository>(value),
    );
  }
}

String _$pinRepositoryHash() => r'cccf06dadc3f69d1da32a5397dc0f5f20b2fc4fb';

/// Provides the [SetPinUseCase] for setting/replacing the app-lock PIN.

@ProviderFor(setPinUseCase)
final setPinUseCaseProvider = SetPinUseCaseProvider._();

/// Provides the [SetPinUseCase] for setting/replacing the app-lock PIN.

final class SetPinUseCaseProvider
    extends $FunctionalProvider<SetPinUseCase, SetPinUseCase, SetPinUseCase>
    with $Provider<SetPinUseCase> {
  /// Provides the [SetPinUseCase] for setting/replacing the app-lock PIN.
  SetPinUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setPinUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setPinUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetPinUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetPinUseCase create(Ref ref) {
    return setPinUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetPinUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetPinUseCase>(value),
    );
  }
}

String _$setPinUseCaseHash() => r'9d22b633a7f9b98f9d2a97281a11ae4929e2bb72';

/// Provides the [VerifyPinUseCase] for checking a candidate PIN.

@ProviderFor(verifyPinUseCase)
final verifyPinUseCaseProvider = VerifyPinUseCaseProvider._();

/// Provides the [VerifyPinUseCase] for checking a candidate PIN.

final class VerifyPinUseCaseProvider
    extends
        $FunctionalProvider<
          VerifyPinUseCase,
          VerifyPinUseCase,
          VerifyPinUseCase
        >
    with $Provider<VerifyPinUseCase> {
  /// Provides the [VerifyPinUseCase] for checking a candidate PIN.
  VerifyPinUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyPinUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyPinUseCaseHash();

  @$internal
  @override
  $ProviderElement<VerifyPinUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerifyPinUseCase create(Ref ref) {
    return verifyPinUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerifyPinUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerifyPinUseCase>(value),
    );
  }
}

String _$verifyPinUseCaseHash() => r'fa30d12892a992101d7a04d7f8b11c19039530bc';

/// Provides the [ClearPinUseCase] for disabling the app-lock.

@ProviderFor(clearPinUseCase)
final clearPinUseCaseProvider = ClearPinUseCaseProvider._();

/// Provides the [ClearPinUseCase] for disabling the app-lock.

final class ClearPinUseCaseProvider
    extends
        $FunctionalProvider<ClearPinUseCase, ClearPinUseCase, ClearPinUseCase>
    with $Provider<ClearPinUseCase> {
  /// Provides the [ClearPinUseCase] for disabling the app-lock.
  ClearPinUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearPinUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clearPinUseCaseHash();

  @$internal
  @override
  $ProviderElement<ClearPinUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClearPinUseCase create(Ref ref) {
    return clearPinUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClearPinUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClearPinUseCase>(value),
    );
  }
}

String _$clearPinUseCaseHash() => r'59a8f0115a25041065340ea1f12b4ffdeb427783';

/// Whether an app-lock PIN has already been set.

@ProviderFor(hasPin)
final hasPinProvider = HasPinProvider._();

/// Whether an app-lock PIN has already been set.

final class HasPinProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether an app-lock PIN has already been set.
  HasPinProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasPinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasPinHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return hasPin(ref);
  }
}

String _$hasPinHash() => r'9fa555c98b1969568963c4d3e212b1d40e163405';

/// Whether the current app session has already been unlocked. In-memory
/// only and on purpose: a fresh process launch must always re-prompt.

@ProviderFor(AppLockSession)
final appLockSessionProvider = AppLockSessionProvider._();

/// Whether the current app session has already been unlocked. In-memory
/// only and on purpose: a fresh process launch must always re-prompt.
final class AppLockSessionProvider
    extends $NotifierProvider<AppLockSession, bool> {
  /// Whether the current app session has already been unlocked. In-memory
  /// only and on purpose: a fresh process launch must always re-prompt.
  AppLockSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockSessionHash();

  @$internal
  @override
  AppLockSession create() => AppLockSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appLockSessionHash() => r'5567d784419388d53015f649ad07d78b3e1d03fc';

/// Whether the current app session has already been unlocked. In-memory
/// only and on purpose: a fresh process launch must always re-prompt.

abstract class _$AppLockSession extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
