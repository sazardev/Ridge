// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [SnippetDao] bound to the shared [AppDatabase].

@ProviderFor(snippetDao)
final snippetDaoProvider = SnippetDaoProvider._();

/// Provides the [SnippetDao] bound to the shared [AppDatabase].

final class SnippetDaoProvider
    extends $FunctionalProvider<SnippetDao, SnippetDao, SnippetDao>
    with $Provider<SnippetDao> {
  /// Provides the [SnippetDao] bound to the shared [AppDatabase].
  SnippetDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snippetDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snippetDaoHash();

  @$internal
  @override
  $ProviderElement<SnippetDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SnippetDao create(Ref ref) {
    return snippetDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SnippetDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SnippetDao>(value),
    );
  }
}

String _$snippetDaoHash() => r'5445c74acf4844369aeb8af16a6f9fd7883de861';

/// Provides the [SnippetRepository] implementation used across the app.

@ProviderFor(snippetRepository)
final snippetRepositoryProvider = SnippetRepositoryProvider._();

/// Provides the [SnippetRepository] implementation used across the app.

final class SnippetRepositoryProvider
    extends
        $FunctionalProvider<
          SnippetRepository,
          SnippetRepository,
          SnippetRepository
        >
    with $Provider<SnippetRepository> {
  /// Provides the [SnippetRepository] implementation used across the app.
  SnippetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snippetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snippetRepositoryHash();

  @$internal
  @override
  $ProviderElement<SnippetRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SnippetRepository create(Ref ref) {
    return snippetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SnippetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SnippetRepository>(value),
    );
  }
}

String _$snippetRepositoryHash() => r'c331cfcc4e63db14d27df7100a3686d13d71f4b5';

/// Provides the [SnippetCatalogSource] adapter (bundled JSON asset).

@ProviderFor(snippetCatalogSource)
final snippetCatalogSourceProvider = SnippetCatalogSourceProvider._();

/// Provides the [SnippetCatalogSource] adapter (bundled JSON asset).

final class SnippetCatalogSourceProvider
    extends
        $FunctionalProvider<
          SnippetCatalogSource,
          SnippetCatalogSource,
          SnippetCatalogSource
        >
    with $Provider<SnippetCatalogSource> {
  /// Provides the [SnippetCatalogSource] adapter (bundled JSON asset).
  SnippetCatalogSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snippetCatalogSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snippetCatalogSourceHash();

  @$internal
  @override
  $ProviderElement<SnippetCatalogSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SnippetCatalogSource create(Ref ref) {
    return snippetCatalogSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SnippetCatalogSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SnippetCatalogSource>(value),
    );
  }
}

String _$snippetCatalogSourceHash() =>
    r'a22464c139be3a424c3e54450f6dd350eba10c23';

/// Provides the [SeedSnippetCatalogUseCase] used to seed the catalog at
/// app startup.

@ProviderFor(seedSnippetCatalogUseCase)
final seedSnippetCatalogUseCaseProvider = SeedSnippetCatalogUseCaseProvider._();

/// Provides the [SeedSnippetCatalogUseCase] used to seed the catalog at
/// app startup.

final class SeedSnippetCatalogUseCaseProvider
    extends
        $FunctionalProvider<
          SeedSnippetCatalogUseCase,
          SeedSnippetCatalogUseCase,
          SeedSnippetCatalogUseCase
        >
    with $Provider<SeedSnippetCatalogUseCase> {
  /// Provides the [SeedSnippetCatalogUseCase] used to seed the catalog at
  /// app startup.
  SeedSnippetCatalogUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seedSnippetCatalogUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seedSnippetCatalogUseCaseHash();

  @$internal
  @override
  $ProviderElement<SeedSnippetCatalogUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SeedSnippetCatalogUseCase create(Ref ref) {
    return seedSnippetCatalogUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeedSnippetCatalogUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeedSnippetCatalogUseCase>(value),
    );
  }
}

String _$seedSnippetCatalogUseCaseHash() =>
    r'ffd2d93b2705e38b1c1734653d688c6acf5a22ee';

/// Provides the [BrowseSnippetsUseCase] for filtered catalog lookups.

@ProviderFor(browseSnippetsUseCase)
final browseSnippetsUseCaseProvider = BrowseSnippetsUseCaseProvider._();

/// Provides the [BrowseSnippetsUseCase] for filtered catalog lookups.

final class BrowseSnippetsUseCaseProvider
    extends
        $FunctionalProvider<
          BrowseSnippetsUseCase,
          BrowseSnippetsUseCase,
          BrowseSnippetsUseCase
        >
    with $Provider<BrowseSnippetsUseCase> {
  /// Provides the [BrowseSnippetsUseCase] for filtered catalog lookups.
  BrowseSnippetsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'browseSnippetsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$browseSnippetsUseCaseHash();

  @$internal
  @override
  $ProviderElement<BrowseSnippetsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BrowseSnippetsUseCase create(Ref ref) {
    return browseSnippetsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseSnippetsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseSnippetsUseCase>(value),
    );
  }
}

String _$browseSnippetsUseCaseHash() =>
    r'60414d729f05056f8eeddfa29dca2c011012e2d9';

/// Provides the [GetSnippetByIdUseCase] for single-entry lookups.

@ProviderFor(getSnippetByIdUseCase)
final getSnippetByIdUseCaseProvider = GetSnippetByIdUseCaseProvider._();

/// Provides the [GetSnippetByIdUseCase] for single-entry lookups.

final class GetSnippetByIdUseCaseProvider
    extends
        $FunctionalProvider<
          GetSnippetByIdUseCase,
          GetSnippetByIdUseCase,
          GetSnippetByIdUseCase
        >
    with $Provider<GetSnippetByIdUseCase> {
  /// Provides the [GetSnippetByIdUseCase] for single-entry lookups.
  GetSnippetByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSnippetByIdUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSnippetByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSnippetByIdUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetSnippetByIdUseCase create(Ref ref) {
    return getSnippetByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSnippetByIdUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSnippetByIdUseCase>(value),
    );
  }
}

String _$getSnippetByIdUseCaseHash() =>
    r'4fc856076d09d58ccffb7cfd1190ae9d6f583257';

/// Provides the [WatchSnippetCatalogUseCase] for observing the catalog.

@ProviderFor(watchSnippetCatalogUseCase)
final watchSnippetCatalogUseCaseProvider =
    WatchSnippetCatalogUseCaseProvider._();

/// Provides the [WatchSnippetCatalogUseCase] for observing the catalog.

final class WatchSnippetCatalogUseCaseProvider
    extends
        $FunctionalProvider<
          WatchSnippetCatalogUseCase,
          WatchSnippetCatalogUseCase,
          WatchSnippetCatalogUseCase
        >
    with $Provider<WatchSnippetCatalogUseCase> {
  /// Provides the [WatchSnippetCatalogUseCase] for observing the catalog.
  WatchSnippetCatalogUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchSnippetCatalogUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchSnippetCatalogUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchSnippetCatalogUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchSnippetCatalogUseCase create(Ref ref) {
    return watchSnippetCatalogUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchSnippetCatalogUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchSnippetCatalogUseCase>(value),
    );
  }
}

String _$watchSnippetCatalogUseCaseHash() =>
    r'261bc0e29e319aea0c03348feec2f045e28e1458';

/// Runs the (idempotent) catalog seed once at app startup. Watched from
/// `JustInTimeApp`'s build method so it fires as soon as the app starts,
/// regardless of which route the router lands on first — `keepAlive`
/// means it only ever runs once for the app's lifetime.

@ProviderFor(catalogSeed)
final catalogSeedProvider = CatalogSeedProvider._();

/// Runs the (idempotent) catalog seed once at app startup. Watched from
/// `JustInTimeApp`'s build method so it fires as soon as the app starts,
/// regardless of which route the router lands on first — `keepAlive`
/// means it only ever runs once for the app's lifetime.

final class CatalogSeedProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Runs the (idempotent) catalog seed once at app startup. Watched from
  /// `JustInTimeApp`'s build method so it fires as soon as the app starts,
  /// regardless of which route the router lands on first — `keepAlive`
  /// means it only ever runs once for the app's lifetime.
  CatalogSeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogSeedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogSeedHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return catalogSeed(ref);
  }
}

String _$catalogSeedHash() => r'00fb713198904127ff3978c95139087ee2383f04';

/// Exposes the full active catalog as a reactive [AsyncValue].

@ProviderFor(SnippetCatalogController)
final snippetCatalogControllerProvider = SnippetCatalogControllerProvider._();

/// Exposes the full active catalog as a reactive [AsyncValue].
final class SnippetCatalogControllerProvider
    extends $StreamNotifierProvider<SnippetCatalogController, List<Snippet>> {
  /// Exposes the full active catalog as a reactive [AsyncValue].
  SnippetCatalogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snippetCatalogControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snippetCatalogControllerHash();

  @$internal
  @override
  SnippetCatalogController create() => SnippetCatalogController();
}

String _$snippetCatalogControllerHash() =>
    r'41659c5bff2afc5b8963063dce99e6c5ffa9474a';

/// Exposes the full active catalog as a reactive [AsyncValue].

abstract class _$SnippetCatalogController
    extends $StreamNotifier<List<Snippet>> {
  Stream<List<Snippet>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Snippet>>, List<Snippet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Snippet>>, List<Snippet>>,
              AsyncValue<List<Snippet>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
