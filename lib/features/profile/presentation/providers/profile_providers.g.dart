// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [GuestProfileDao] bound to the shared [AppDatabase].

@ProviderFor(guestProfileDao)
final guestProfileDaoProvider = GuestProfileDaoProvider._();

/// Provides the [GuestProfileDao] bound to the shared [AppDatabase].

final class GuestProfileDaoProvider
    extends
        $FunctionalProvider<GuestProfileDao, GuestProfileDao, GuestProfileDao>
    with $Provider<GuestProfileDao> {
  /// Provides the [GuestProfileDao] bound to the shared [AppDatabase].
  GuestProfileDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guestProfileDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guestProfileDaoHash();

  @$internal
  @override
  $ProviderElement<GuestProfileDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuestProfileDao create(Ref ref) {
    return guestProfileDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuestProfileDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuestProfileDao>(value),
    );
  }
}

String _$guestProfileDaoHash() => r'61a44d3ece4d48ce24ea11927f09795192f56d4e';

/// Provides the [ProfileRepository] implementation used across the app.

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

/// Provides the [ProfileRepository] implementation used across the app.

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  /// Provides the [ProfileRepository] implementation used across the app.
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'e4c9d82805cb295576eca031f2bbe13005b323ea';

/// Provides the [CreateGuestProfileUseCase] for first-run profile creation.

@ProviderFor(createGuestProfileUseCase)
final createGuestProfileUseCaseProvider = CreateGuestProfileUseCaseProvider._();

/// Provides the [CreateGuestProfileUseCase] for first-run profile creation.

final class CreateGuestProfileUseCaseProvider
    extends
        $FunctionalProvider<
          CreateGuestProfileUseCase,
          CreateGuestProfileUseCase,
          CreateGuestProfileUseCase
        >
    with $Provider<CreateGuestProfileUseCase> {
  /// Provides the [CreateGuestProfileUseCase] for first-run profile creation.
  CreateGuestProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createGuestProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createGuestProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateGuestProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateGuestProfileUseCase create(Ref ref) {
    return createGuestProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateGuestProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateGuestProfileUseCase>(value),
    );
  }
}

String _$createGuestProfileUseCaseHash() =>
    r'bb0500e554846202352a88636848dea090973aba';

/// Provides the [WatchActiveProfileUseCase] for observing the Guest Profile.

@ProviderFor(watchActiveProfileUseCase)
final watchActiveProfileUseCaseProvider = WatchActiveProfileUseCaseProvider._();

/// Provides the [WatchActiveProfileUseCase] for observing the Guest Profile.

final class WatchActiveProfileUseCaseProvider
    extends
        $FunctionalProvider<
          WatchActiveProfileUseCase,
          WatchActiveProfileUseCase,
          WatchActiveProfileUseCase
        >
    with $Provider<WatchActiveProfileUseCase> {
  /// Provides the [WatchActiveProfileUseCase] for observing the Guest Profile.
  WatchActiveProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchActiveProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchActiveProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchActiveProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchActiveProfileUseCase create(Ref ref) {
    return watchActiveProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchActiveProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchActiveProfileUseCase>(value),
    );
  }
}

String _$watchActiveProfileUseCaseHash() =>
    r'092c68f53fdd9e70cf03e28d010b4845160ecd36';

/// Provides the [RenameProfileUseCase] for renaming the Guest Profile.

@ProviderFor(renameProfileUseCase)
final renameProfileUseCaseProvider = RenameProfileUseCaseProvider._();

/// Provides the [RenameProfileUseCase] for renaming the Guest Profile.

final class RenameProfileUseCaseProvider
    extends
        $FunctionalProvider<
          RenameProfileUseCase,
          RenameProfileUseCase,
          RenameProfileUseCase
        >
    with $Provider<RenameProfileUseCase> {
  /// Provides the [RenameProfileUseCase] for renaming the Guest Profile.
  RenameProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'renameProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$renameProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<RenameProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RenameProfileUseCase create(Ref ref) {
    return renameProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RenameProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RenameProfileUseCase>(value),
    );
  }
}

String _$renameProfileUseCaseHash() =>
    r'42f0e308464234f41a5229336f9194ab627f362c';

/// Provides the [UpdateProfileCustomizationUseCase] for editing the Guest
/// Profile's self-expression fields.

@ProviderFor(updateProfileCustomizationUseCase)
final updateProfileCustomizationUseCaseProvider =
    UpdateProfileCustomizationUseCaseProvider._();

/// Provides the [UpdateProfileCustomizationUseCase] for editing the Guest
/// Profile's self-expression fields.

final class UpdateProfileCustomizationUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateProfileCustomizationUseCase,
          UpdateProfileCustomizationUseCase,
          UpdateProfileCustomizationUseCase
        >
    with $Provider<UpdateProfileCustomizationUseCase> {
  /// Provides the [UpdateProfileCustomizationUseCase] for editing the Guest
  /// Profile's self-expression fields.
  UpdateProfileCustomizationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileCustomizationUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$updateProfileCustomizationUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateProfileCustomizationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateProfileCustomizationUseCase create(Ref ref) {
    return updateProfileCustomizationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfileCustomizationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProfileCustomizationUseCase>(
        value,
      ),
    );
  }
}

String _$updateProfileCustomizationUseCaseHash() =>
    r'14d0c39feecca4ef7bd06f4d1c69e623cff4526e';

/// Provides the [UpdateKeyboardSetupUseCase] for editing the Guest
/// Profile's keyboard (brand, model, character layout and advanced
/// customization) from the dedicated keyboard editor.

@ProviderFor(updateKeyboardSetupUseCase)
final updateKeyboardSetupUseCaseProvider =
    UpdateKeyboardSetupUseCaseProvider._();

/// Provides the [UpdateKeyboardSetupUseCase] for editing the Guest
/// Profile's keyboard (brand, model, character layout and advanced
/// customization) from the dedicated keyboard editor.

final class UpdateKeyboardSetupUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateKeyboardSetupUseCase,
          UpdateKeyboardSetupUseCase,
          UpdateKeyboardSetupUseCase
        >
    with $Provider<UpdateKeyboardSetupUseCase> {
  /// Provides the [UpdateKeyboardSetupUseCase] for editing the Guest
  /// Profile's keyboard (brand, model, character layout and advanced
  /// customization) from the dedicated keyboard editor.
  UpdateKeyboardSetupUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateKeyboardSetupUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateKeyboardSetupUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateKeyboardSetupUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateKeyboardSetupUseCase create(Ref ref) {
    return updateKeyboardSetupUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateKeyboardSetupUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateKeyboardSetupUseCase>(value),
    );
  }
}

String _$updateKeyboardSetupUseCaseHash() =>
    r'6eaccbb8457b8aa38339ce629cc01c3f847a7461';

/// Provides the [DeviceInfoSource] adapter.

@ProviderFor(deviceInfoSource)
final deviceInfoSourceProvider = DeviceInfoSourceProvider._();

/// Provides the [DeviceInfoSource] adapter.

final class DeviceInfoSourceProvider
    extends
        $FunctionalProvider<
          DeviceInfoSource,
          DeviceInfoSource,
          DeviceInfoSource
        >
    with $Provider<DeviceInfoSource> {
  /// Provides the [DeviceInfoSource] adapter.
  DeviceInfoSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoSourceHash();

  @$internal
  @override
  $ProviderElement<DeviceInfoSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceInfoSource create(Ref ref) {
    return deviceInfoSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceInfoSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceInfoSource>(value),
    );
  }
}

String _$deviceInfoSourceHash() => r'58e5d2e736ba7bc914dd4f90d5483caabc9bce20';

/// Provides the [EnsureDeviceInfoUseCase] for auto-detecting device info.

@ProviderFor(ensureDeviceInfoUseCase)
final ensureDeviceInfoUseCaseProvider = EnsureDeviceInfoUseCaseProvider._();

/// Provides the [EnsureDeviceInfoUseCase] for auto-detecting device info.

final class EnsureDeviceInfoUseCaseProvider
    extends
        $FunctionalProvider<
          EnsureDeviceInfoUseCase,
          EnsureDeviceInfoUseCase,
          EnsureDeviceInfoUseCase
        >
    with $Provider<EnsureDeviceInfoUseCase> {
  /// Provides the [EnsureDeviceInfoUseCase] for auto-detecting device info.
  EnsureDeviceInfoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ensureDeviceInfoUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ensureDeviceInfoUseCaseHash();

  @$internal
  @override
  $ProviderElement<EnsureDeviceInfoUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EnsureDeviceInfoUseCase create(Ref ref) {
    return ensureDeviceInfoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnsureDeviceInfoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnsureDeviceInfoUseCase>(value),
    );
  }
}

String _$ensureDeviceInfoUseCaseHash() =>
    r'7ebd211e70a6093cd5afb2412dfbf0bc132fcbb5';

/// Detects and persists device info onto the active Guest Profile,
/// watched unconditionally from `app.dart` (same fire-and-forget-on-start
/// shape as `content_providers.dart`'s `catalogSeed`). A no-op while no
/// profile exists yet, and idempotent once one does — see
/// [EnsureDeviceInfoUseCase] — so re-running on every subsequent profile
/// update (rename, customization) is harmless.

@ProviderFor(deviceInfoSync)
final deviceInfoSyncProvider = DeviceInfoSyncProvider._();

/// Detects and persists device info onto the active Guest Profile,
/// watched unconditionally from `app.dart` (same fire-and-forget-on-start
/// shape as `content_providers.dart`'s `catalogSeed`). A no-op while no
/// profile exists yet, and idempotent once one does — see
/// [EnsureDeviceInfoUseCase] — so re-running on every subsequent profile
/// update (rename, customization) is harmless.

final class DeviceInfoSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Detects and persists device info onto the active Guest Profile,
  /// watched unconditionally from `app.dart` (same fire-and-forget-on-start
  /// shape as `content_providers.dart`'s `catalogSeed`). A no-op while no
  /// profile exists yet, and idempotent once one does — see
  /// [EnsureDeviceInfoUseCase] — so re-running on every subsequent profile
  /// update (rename, customization) is harmless.
  DeviceInfoSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceInfoSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceInfoSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return deviceInfoSync(ref);
  }
}

String _$deviceInfoSyncHash() => r'4d2d68a65b1cb3789b8584fdc5a08f7b570bf557';

/// Exposes the current [GuestProfile] (or `null` before one exists) and
/// the mutations the UI can request.

@ProviderFor(ActiveProfileController)
final activeProfileControllerProvider = ActiveProfileControllerProvider._();

/// Exposes the current [GuestProfile] (or `null` before one exists) and
/// the mutations the UI can request.
final class ActiveProfileControllerProvider
    extends $StreamNotifierProvider<ActiveProfileController, GuestProfile?> {
  /// Exposes the current [GuestProfile] (or `null` before one exists) and
  /// the mutations the UI can request.
  ActiveProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeProfileControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeProfileControllerHash();

  @$internal
  @override
  ActiveProfileController create() => ActiveProfileController();
}

String _$activeProfileControllerHash() =>
    r'ff6c2b4ac247dba3ad6f87e8d0353cbd046bf420';

/// Exposes the current [GuestProfile] (or `null` before one exists) and
/// the mutations the UI can request.

abstract class _$ActiveProfileController
    extends $StreamNotifier<GuestProfile?> {
  Stream<GuestProfile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GuestProfile?>, GuestProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GuestProfile?>, GuestProfile?>,
              AsyncValue<GuestProfile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether a Guest Profile is known to exist, for the router's redirect.
///
/// `true` while [ActiveProfileController] hasn't emitted its first value
/// yet — so a cold start never flashes the create-profile screen before
/// drift finishes its first query. The moment the real answer arrives,
/// this value changes and `_RouterRefreshNotifier` re-evaluates the
/// redirect (mirrors how `settingsControllerProvider`'s nullable `.value`
/// is read defensively in `app_router.dart`).

@ProviderFor(hasGuestProfile)
final hasGuestProfileProvider = HasGuestProfileProvider._();

/// Whether a Guest Profile is known to exist, for the router's redirect.
///
/// `true` while [ActiveProfileController] hasn't emitted its first value
/// yet — so a cold start never flashes the create-profile screen before
/// drift finishes its first query. The moment the real answer arrives,
/// this value changes and `_RouterRefreshNotifier` re-evaluates the
/// redirect (mirrors how `settingsControllerProvider`'s nullable `.value`
/// is read defensively in `app_router.dart`).

final class HasGuestProfileProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether a Guest Profile is known to exist, for the router's redirect.
  ///
  /// `true` while [ActiveProfileController] hasn't emitted its first value
  /// yet — so a cold start never flashes the create-profile screen before
  /// drift finishes its first query. The moment the real answer arrives,
  /// this value changes and `_RouterRefreshNotifier` re-evaluates the
  /// redirect (mirrors how `settingsControllerProvider`'s nullable `.value`
  /// is read defensively in `app_router.dart`).
  HasGuestProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasGuestProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasGuestProfileHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasGuestProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasGuestProfileHash() => r'01abfa2108420060e0f75d31d0028769314077e3';

/// The active profile's functional keyboard remaps, indexed by
/// `PhysicalKeyId.name` — read by `practice`'s capture engine on every
/// keydown (a deliberately narrow cross-feature read: the keyboard being
/// remapped is the profile's own). Empty while no profile or no remap
/// exists; kept alive and recomputed from the profile stream, so a saved
/// remap takes effect live, without restarting the session.

@ProviderFor(keyboardRemapsByName)
final keyboardRemapsByNameProvider = KeyboardRemapsByNameProvider._();

/// The active profile's functional keyboard remaps, indexed by
/// `PhysicalKeyId.name` — read by `practice`'s capture engine on every
/// keydown (a deliberately narrow cross-feature read: the keyboard being
/// remapped is the profile's own). Empty while no profile or no remap
/// exists; kept alive and recomputed from the profile stream, so a saved
/// remap takes effect live, without restarting the session.

final class KeyboardRemapsByNameProvider
    extends
        $FunctionalProvider<
          Map<String, KeyboardKeyRemap>,
          Map<String, KeyboardKeyRemap>,
          Map<String, KeyboardKeyRemap>
        >
    with $Provider<Map<String, KeyboardKeyRemap>> {
  /// The active profile's functional keyboard remaps, indexed by
  /// `PhysicalKeyId.name` — read by `practice`'s capture engine on every
  /// keydown (a deliberately narrow cross-feature read: the keyboard being
  /// remapped is the profile's own). Empty while no profile or no remap
  /// exists; kept alive and recomputed from the profile stream, so a saved
  /// remap takes effect live, without restarting the session.
  KeyboardRemapsByNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardRemapsByNameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyboardRemapsByNameHash();

  @$internal
  @override
  $ProviderElement<Map<String, KeyboardKeyRemap>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, KeyboardKeyRemap> create(Ref ref) {
    return keyboardRemapsByName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, KeyboardKeyRemap> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, KeyboardKeyRemap>>(
        value,
      ),
    );
  }
}

String _$keyboardRemapsByNameHash() =>
    r'fff07a604a89eebfab0d9c42443582f870020e21';
