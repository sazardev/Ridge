// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_management_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [DataResetDao] bound to the shared [AppDatabase].

@ProviderFor(dataResetDao)
final dataResetDaoProvider = DataResetDaoProvider._();

/// Provides the [DataResetDao] bound to the shared [AppDatabase].

final class DataResetDaoProvider
    extends $FunctionalProvider<DataResetDao, DataResetDao, DataResetDao>
    with $Provider<DataResetDao> {
  /// Provides the [DataResetDao] bound to the shared [AppDatabase].
  DataResetDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataResetDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataResetDaoHash();

  @$internal
  @override
  $ProviderElement<DataResetDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataResetDao create(Ref ref) {
    return dataResetDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataResetDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataResetDao>(value),
    );
  }
}

String _$dataResetDaoHash() => r'a089574a0490e0051ce7a1b8541176626afe4631';

/// Provides the [DataResetRepository] implementation used across the app.

@ProviderFor(dataResetRepository)
final dataResetRepositoryProvider = DataResetRepositoryProvider._();

/// Provides the [DataResetRepository] implementation used across the app.

final class DataResetRepositoryProvider
    extends
        $FunctionalProvider<
          DataResetRepository,
          DataResetRepository,
          DataResetRepository
        >
    with $Provider<DataResetRepository> {
  /// Provides the [DataResetRepository] implementation used across the app.
  DataResetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataResetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataResetRepositoryHash();

  @$internal
  @override
  $ProviderElement<DataResetRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DataResetRepository create(Ref ref) {
    return dataResetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataResetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataResetRepository>(value),
    );
  }
}

String _$dataResetRepositoryHash() =>
    r'bc2f7f03805b8739887096d0b178606b6d2b26b7';

/// Provides the [ResetLessonUseCase].

@ProviderFor(resetLessonUseCase)
final resetLessonUseCaseProvider = ResetLessonUseCaseProvider._();

/// Provides the [ResetLessonUseCase].

final class ResetLessonUseCaseProvider
    extends
        $FunctionalProvider<
          ResetLessonUseCase,
          ResetLessonUseCase,
          ResetLessonUseCase
        >
    with $Provider<ResetLessonUseCase> {
  /// Provides the [ResetLessonUseCase].
  ResetLessonUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetLessonUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetLessonUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResetLessonUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResetLessonUseCase create(Ref ref) {
    return resetLessonUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetLessonUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetLessonUseCase>(value),
    );
  }
}

String _$resetLessonUseCaseHash() =>
    r'840f543072e8cb0bee120b9ad47c3a40c25a606d';

/// Provides the [ResetAllLessonsUseCase].

@ProviderFor(resetAllLessonsUseCase)
final resetAllLessonsUseCaseProvider = ResetAllLessonsUseCaseProvider._();

/// Provides the [ResetAllLessonsUseCase].

final class ResetAllLessonsUseCaseProvider
    extends
        $FunctionalProvider<
          ResetAllLessonsUseCase,
          ResetAllLessonsUseCase,
          ResetAllLessonsUseCase
        >
    with $Provider<ResetAllLessonsUseCase> {
  /// Provides the [ResetAllLessonsUseCase].
  ResetAllLessonsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetAllLessonsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetAllLessonsUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResetAllLessonsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResetAllLessonsUseCase create(Ref ref) {
    return resetAllLessonsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetAllLessonsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetAllLessonsUseCase>(value),
    );
  }
}

String _$resetAllLessonsUseCaseHash() =>
    r'84aee3738499c1caa5ec71852abc8350fd7c9081';

/// Provides the [WipeAllDataUseCase].

@ProviderFor(wipeAllDataUseCase)
final wipeAllDataUseCaseProvider = WipeAllDataUseCaseProvider._();

/// Provides the [WipeAllDataUseCase].

final class WipeAllDataUseCaseProvider
    extends
        $FunctionalProvider<
          WipeAllDataUseCase,
          WipeAllDataUseCase,
          WipeAllDataUseCase
        >
    with $Provider<WipeAllDataUseCase> {
  /// Provides the [WipeAllDataUseCase].
  WipeAllDataUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wipeAllDataUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wipeAllDataUseCaseHash();

  @$internal
  @override
  $ProviderElement<WipeAllDataUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WipeAllDataUseCase create(Ref ref) {
    return wipeAllDataUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WipeAllDataUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WipeAllDataUseCase>(value),
    );
  }
}

String _$wipeAllDataUseCaseHash() =>
    r'b14e01e3742840153fbaf70c978bb56cd74bc4c6';

/// Composes the Settings screen's "danger zone" actions: each one is more
/// than a single repository call — a reset must also refresh the derived
/// caches it just invalidated, and a full wipe must also disarm the app
/// lock (a stale `appLockEnabled: true` with no PIN left behind would
/// strand the very next launch on an unpassable lock screen). Mirrors how
/// `practice_session_controller.dart` composes `progression`/
/// `learning_paths`/`achievements` use cases after finishing a session,
/// rather than folding that orchestration into any one repository.
///
/// `keepAlive: true` on purpose — every method here awaits several
/// steps (a repository call, then one or two recomputes), and an
/// autoDispose controller can be torn down mid-flight the moment
/// nothing is left `ref.watch`ing it (a widget's `ref.read(...)` alone
/// doesn't keep it alive across an async gap), which throws on the next
/// `ref.read` inside the very method that's still running. Mirrors
/// every other stateful controller in the app
/// (`ActiveProfileController`, `SettingsController`,
/// `ProgressSnapshotController`, ...) — all `keepAlive: true` for the
/// same reason.

@ProviderFor(DataManagementController)
final dataManagementControllerProvider = DataManagementControllerProvider._();

/// Composes the Settings screen's "danger zone" actions: each one is more
/// than a single repository call — a reset must also refresh the derived
/// caches it just invalidated, and a full wipe must also disarm the app
/// lock (a stale `appLockEnabled: true` with no PIN left behind would
/// strand the very next launch on an unpassable lock screen). Mirrors how
/// `practice_session_controller.dart` composes `progression`/
/// `learning_paths`/`achievements` use cases after finishing a session,
/// rather than folding that orchestration into any one repository.
///
/// `keepAlive: true` on purpose — every method here awaits several
/// steps (a repository call, then one or two recomputes), and an
/// autoDispose controller can be torn down mid-flight the moment
/// nothing is left `ref.watch`ing it (a widget's `ref.read(...)` alone
/// doesn't keep it alive across an async gap), which throws on the next
/// `ref.read` inside the very method that's still running. Mirrors
/// every other stateful controller in the app
/// (`ActiveProfileController`, `SettingsController`,
/// `ProgressSnapshotController`, ...) — all `keepAlive: true` for the
/// same reason.
final class DataManagementControllerProvider
    extends $NotifierProvider<DataManagementController, void> {
  /// Composes the Settings screen's "danger zone" actions: each one is more
  /// than a single repository call — a reset must also refresh the derived
  /// caches it just invalidated, and a full wipe must also disarm the app
  /// lock (a stale `appLockEnabled: true` with no PIN left behind would
  /// strand the very next launch on an unpassable lock screen). Mirrors how
  /// `practice_session_controller.dart` composes `progression`/
  /// `learning_paths`/`achievements` use cases after finishing a session,
  /// rather than folding that orchestration into any one repository.
  ///
  /// `keepAlive: true` on purpose — every method here awaits several
  /// steps (a repository call, then one or two recomputes), and an
  /// autoDispose controller can be torn down mid-flight the moment
  /// nothing is left `ref.watch`ing it (a widget's `ref.read(...)` alone
  /// doesn't keep it alive across an async gap), which throws on the next
  /// `ref.read` inside the very method that's still running. Mirrors
  /// every other stateful controller in the app
  /// (`ActiveProfileController`, `SettingsController`,
  /// `ProgressSnapshotController`, ...) — all `keepAlive: true` for the
  /// same reason.
  DataManagementControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataManagementControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataManagementControllerHash();

  @$internal
  @override
  DataManagementController create() => DataManagementController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$dataManagementControllerHash() =>
    r'87b7025edf9a397e64c0a247d567ccaeb657a494';

/// Composes the Settings screen's "danger zone" actions: each one is more
/// than a single repository call — a reset must also refresh the derived
/// caches it just invalidated, and a full wipe must also disarm the app
/// lock (a stale `appLockEnabled: true` with no PIN left behind would
/// strand the very next launch on an unpassable lock screen). Mirrors how
/// `practice_session_controller.dart` composes `progression`/
/// `learning_paths`/`achievements` use cases after finishing a session,
/// rather than folding that orchestration into any one repository.
///
/// `keepAlive: true` on purpose — every method here awaits several
/// steps (a repository call, then one or two recomputes), and an
/// autoDispose controller can be torn down mid-flight the moment
/// nothing is left `ref.watch`ing it (a widget's `ref.read(...)` alone
/// doesn't keep it alive across an async gap), which throws on the next
/// `ref.read` inside the very method that's still running. Mirrors
/// every other stateful controller in the app
/// (`ActiveProfileController`, `SettingsController`,
/// `ProgressSnapshotController`, ...) — all `keepAlive: true` for the
/// same reason.

abstract class _$DataManagementController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
