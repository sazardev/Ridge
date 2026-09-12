// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_language_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ActiveLanguageLocalDataSource] backed by shared
/// preferences.

@ProviderFor(activeLanguageLocalDataSource)
final activeLanguageLocalDataSourceProvider =
    ActiveLanguageLocalDataSourceProvider._();

/// Provides the [ActiveLanguageLocalDataSource] backed by shared
/// preferences.

final class ActiveLanguageLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ActiveLanguageLocalDataSource,
          ActiveLanguageLocalDataSource,
          ActiveLanguageLocalDataSource
        >
    with $Provider<ActiveLanguageLocalDataSource> {
  /// Provides the [ActiveLanguageLocalDataSource] backed by shared
  /// preferences.
  ActiveLanguageLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLanguageLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLanguageLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ActiveLanguageLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActiveLanguageLocalDataSource create(Ref ref) {
    return activeLanguageLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveLanguageLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveLanguageLocalDataSource>(
        value,
      ),
    );
  }
}

String _$activeLanguageLocalDataSourceHash() =>
    r'a8f967d70f91d140ef7e192e1af1511f3b9eb28f';

/// Provides the [ActiveLanguageRepository] implementation used across the
/// app.

@ProviderFor(activeLanguageRepository)
final activeLanguageRepositoryProvider = ActiveLanguageRepositoryProvider._();

/// Provides the [ActiveLanguageRepository] implementation used across the
/// app.

final class ActiveLanguageRepositoryProvider
    extends
        $FunctionalProvider<
          ActiveLanguageRepository,
          ActiveLanguageRepository,
          ActiveLanguageRepository
        >
    with $Provider<ActiveLanguageRepository> {
  /// Provides the [ActiveLanguageRepository] implementation used across the
  /// app.
  ActiveLanguageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLanguageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLanguageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActiveLanguageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActiveLanguageRepository create(Ref ref) {
    return activeLanguageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveLanguageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveLanguageRepository>(value),
    );
  }
}

String _$activeLanguageRepositoryHash() =>
    r'f4fe420bb261b298f7b63cbf50caddd5f61d8542';

/// Provides the [GetActiveLanguageUseCase].

@ProviderFor(getActiveLanguageUseCase)
final getActiveLanguageUseCaseProvider = GetActiveLanguageUseCaseProvider._();

/// Provides the [GetActiveLanguageUseCase].

final class GetActiveLanguageUseCaseProvider
    extends
        $FunctionalProvider<
          GetActiveLanguageUseCase,
          GetActiveLanguageUseCase,
          GetActiveLanguageUseCase
        >
    with $Provider<GetActiveLanguageUseCase> {
  /// Provides the [GetActiveLanguageUseCase].
  GetActiveLanguageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getActiveLanguageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getActiveLanguageUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetActiveLanguageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetActiveLanguageUseCase create(Ref ref) {
    return getActiveLanguageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetActiveLanguageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetActiveLanguageUseCase>(value),
    );
  }
}

String _$getActiveLanguageUseCaseHash() =>
    r'64d48f0437c5a9769ee6c132dec63872fb2a7052';

/// Provides the [SetActiveLanguageUseCase].

@ProviderFor(setActiveLanguageUseCase)
final setActiveLanguageUseCaseProvider = SetActiveLanguageUseCaseProvider._();

/// Provides the [SetActiveLanguageUseCase].

final class SetActiveLanguageUseCaseProvider
    extends
        $FunctionalProvider<
          SetActiveLanguageUseCase,
          SetActiveLanguageUseCase,
          SetActiveLanguageUseCase
        >
    with $Provider<SetActiveLanguageUseCase> {
  /// Provides the [SetActiveLanguageUseCase].
  SetActiveLanguageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setActiveLanguageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setActiveLanguageUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetActiveLanguageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetActiveLanguageUseCase create(Ref ref) {
    return setActiveLanguageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetActiveLanguageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetActiveLanguageUseCase>(value),
    );
  }
}

String _$setActiveLanguageUseCaseHash() =>
    r'c661170c7796cfaa7730e5460061fa70a4bec6a0';

/// Exposes the persisted active learning language and the mutation the
/// language catalog requests (SPEC.md §5.7). `null` means "no language
/// chosen yet" — the Practice tab shows its catalog in that case.

@ProviderFor(ActiveLanguageController)
final activeLanguageControllerProvider = ActiveLanguageControllerProvider._();

/// Exposes the persisted active learning language and the mutation the
/// language catalog requests (SPEC.md §5.7). `null` means "no language
/// chosen yet" — the Practice tab shows its catalog in that case.
final class ActiveLanguageControllerProvider
    extends
        $AsyncNotifierProvider<ActiveLanguageController, ProgrammingLanguage?> {
  /// Exposes the persisted active learning language and the mutation the
  /// language catalog requests (SPEC.md §5.7). `null` means "no language
  /// chosen yet" — the Practice tab shows its catalog in that case.
  ActiveLanguageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLanguageControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLanguageControllerHash();

  @$internal
  @override
  ActiveLanguageController create() => ActiveLanguageController();
}

String _$activeLanguageControllerHash() =>
    r'13baac0356dc6e9e7690aef58483e00e7a5cfaa0';

/// Exposes the persisted active learning language and the mutation the
/// language catalog requests (SPEC.md §5.7). `null` means "no language
/// chosen yet" — the Practice tab shows its catalog in that case.

abstract class _$ActiveLanguageController
    extends $AsyncNotifier<ProgrammingLanguage?> {
  FutureOr<ProgrammingLanguage?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ProgrammingLanguage?>, ProgrammingLanguage?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ProgrammingLanguage?>,
                ProgrammingLanguage?
              >,
              AsyncValue<ProgrammingLanguage?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
