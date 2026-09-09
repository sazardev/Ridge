// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [SettingsLocalDataSource] backed by shared preferences.

@ProviderFor(settingsLocalDataSource)
final settingsLocalDataSourceProvider = SettingsLocalDataSourceProvider._();

/// Provides the [SettingsLocalDataSource] backed by shared preferences.

final class SettingsLocalDataSourceProvider
    extends
        $FunctionalProvider<
          SettingsLocalDataSource,
          SettingsLocalDataSource,
          SettingsLocalDataSource
        >
    with $Provider<SettingsLocalDataSource> {
  /// Provides the [SettingsLocalDataSource] backed by shared preferences.
  SettingsLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<SettingsLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsLocalDataSource create(Ref ref) {
    return settingsLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsLocalDataSource>(value),
    );
  }
}

String _$settingsLocalDataSourceHash() =>
    r'1f12d9020fc66019fa70d90b573c70abc5cb1a76';

/// Provides the [SettingsRepository] implementation used across the app.

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

/// Provides the [SettingsRepository] implementation used across the app.

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  /// Provides the [SettingsRepository] implementation used across the app.
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'84dd9cce65defe3e281a05ff8c1d0a5c60c2a0c0';

/// Provides the [WatchSettingsUseCase] for observing preference changes.

@ProviderFor(watchSettingsUseCase)
final watchSettingsUseCaseProvider = WatchSettingsUseCaseProvider._();

/// Provides the [WatchSettingsUseCase] for observing preference changes.

final class WatchSettingsUseCaseProvider
    extends
        $FunctionalProvider<
          WatchSettingsUseCase,
          WatchSettingsUseCase,
          WatchSettingsUseCase
        >
    with $Provider<WatchSettingsUseCase> {
  /// Provides the [WatchSettingsUseCase] for observing preference changes.
  WatchSettingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchSettingsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchSettingsUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchSettingsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchSettingsUseCase create(Ref ref) {
    return watchSettingsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchSettingsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchSettingsUseCase>(value),
    );
  }
}

String _$watchSettingsUseCaseHash() =>
    r'f7bf670dc3d4843a8460740751df3c94d41f0c1f';

/// Provides the [UpdateSettingsUseCase] for persisting preference changes.

@ProviderFor(updateSettingsUseCase)
final updateSettingsUseCaseProvider = UpdateSettingsUseCaseProvider._();

/// Provides the [UpdateSettingsUseCase] for persisting preference changes.

final class UpdateSettingsUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateSettingsUseCase,
          UpdateSettingsUseCase,
          UpdateSettingsUseCase
        >
    with $Provider<UpdateSettingsUseCase> {
  /// Provides the [UpdateSettingsUseCase] for persisting preference changes.
  UpdateSettingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateSettingsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateSettingsUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateSettingsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateSettingsUseCase create(Ref ref) {
    return updateSettingsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateSettingsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateSettingsUseCase>(value),
    );
  }
}

String _$updateSettingsUseCaseHash() =>
    r'c79b153335835237122e5ad3d54568bb9ff85848';

/// Exposes the current [AppSettings] and the mutations the UI can request.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Exposes the current [AppSettings] and the mutations the UI can request.
final class SettingsControllerProvider
    extends $StreamNotifierProvider<SettingsController, AppSettings> {
  /// Exposes the current [AppSettings] and the mutations the UI can request.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'f38b12cd6305ce75683f696f9d81d96cf4ace960';

/// Exposes the current [AppSettings] and the mutations the UI can request.

abstract class _$SettingsController extends $StreamNotifier<AppSettings> {
  Stream<AppSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppSettings>, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppSettings>, AppSettings>,
              AsyncValue<AppSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
