// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ProgressionDao] bound to the shared [AppDatabase].

@ProviderFor(progressionDao)
final progressionDaoProvider = ProgressionDaoProvider._();

/// Provides the [ProgressionDao] bound to the shared [AppDatabase].

final class ProgressionDaoProvider
    extends $FunctionalProvider<ProgressionDao, ProgressionDao, ProgressionDao>
    with $Provider<ProgressionDao> {
  /// Provides the [ProgressionDao] bound to the shared [AppDatabase].
  ProgressionDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressionDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressionDaoHash();

  @$internal
  @override
  $ProviderElement<ProgressionDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProgressionDao create(Ref ref) {
    return progressionDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressionDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressionDao>(value),
    );
  }
}

String _$progressionDaoHash() => r'99cc6d3c973dd2be2f43865c8b262fee9187e6d4';

/// Provides the [ProgressionRepository] implementation used across the
/// app.

@ProviderFor(progressionRepository)
final progressionRepositoryProvider = ProgressionRepositoryProvider._();

/// Provides the [ProgressionRepository] implementation used across the
/// app.

final class ProgressionRepositoryProvider
    extends
        $FunctionalProvider<
          ProgressionRepository,
          ProgressionRepository,
          ProgressionRepository
        >
    with $Provider<ProgressionRepository> {
  /// Provides the [ProgressionRepository] implementation used across the
  /// app.
  ProgressionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgressionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgressionRepository create(Ref ref) {
    return progressionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressionRepository>(value),
    );
  }
}

String _$progressionRepositoryHash() =>
    r'47cb64690e6d84482659edb8f556235a90ff8d69';

/// Provides the [RecomputeProgressSnapshotUseCase], fired right after
/// every finished `practice` session and again as a safety net when the
/// Progress screen first loads.

@ProviderFor(recomputeProgressSnapshotUseCase)
final recomputeProgressSnapshotUseCaseProvider =
    RecomputeProgressSnapshotUseCaseProvider._();

/// Provides the [RecomputeProgressSnapshotUseCase], fired right after
/// every finished `practice` session and again as a safety net when the
/// Progress screen first loads.

final class RecomputeProgressSnapshotUseCaseProvider
    extends
        $FunctionalProvider<
          RecomputeProgressSnapshotUseCase,
          RecomputeProgressSnapshotUseCase,
          RecomputeProgressSnapshotUseCase
        >
    with $Provider<RecomputeProgressSnapshotUseCase> {
  /// Provides the [RecomputeProgressSnapshotUseCase], fired right after
  /// every finished `practice` session and again as a safety net when the
  /// Progress screen first loads.
  RecomputeProgressSnapshotUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recomputeProgressSnapshotUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recomputeProgressSnapshotUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecomputeProgressSnapshotUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecomputeProgressSnapshotUseCase create(Ref ref) {
    return recomputeProgressSnapshotUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecomputeProgressSnapshotUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecomputeProgressSnapshotUseCase>(
        value,
      ),
    );
  }
}

String _$recomputeProgressSnapshotUseCaseHash() =>
    r'fd597cc59c43492509de864cf2591ab31b45ebe9';

/// Provides the [GetRecommendedSnippetUseCase] for weakness-based
/// snippet recommendation (SPEC.md §3.3/§6.3).

@ProviderFor(getRecommendedSnippetUseCase)
final getRecommendedSnippetUseCaseProvider =
    GetRecommendedSnippetUseCaseProvider._();

/// Provides the [GetRecommendedSnippetUseCase] for weakness-based
/// snippet recommendation (SPEC.md §3.3/§6.3).

final class GetRecommendedSnippetUseCaseProvider
    extends
        $FunctionalProvider<
          GetRecommendedSnippetUseCase,
          GetRecommendedSnippetUseCase,
          GetRecommendedSnippetUseCase
        >
    with $Provider<GetRecommendedSnippetUseCase> {
  /// Provides the [GetRecommendedSnippetUseCase] for weakness-based
  /// snippet recommendation (SPEC.md §3.3/§6.3).
  GetRecommendedSnippetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRecommendedSnippetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRecommendedSnippetUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRecommendedSnippetUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetRecommendedSnippetUseCase create(Ref ref) {
    return getRecommendedSnippetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRecommendedSnippetUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRecommendedSnippetUseCase>(value),
    );
  }
}

String _$getRecommendedSnippetUseCaseHash() =>
    r'fbf94d24d2f43e4ad8286c434fe1ce00df98c07a';

/// Provides the [GetPersonalHistoryComparisonUseCase] for the guest-only
/// "local leaderboard" (SPEC.md §7.1/§11.4).

@ProviderFor(getPersonalHistoryComparisonUseCase)
final getPersonalHistoryComparisonUseCaseProvider =
    GetPersonalHistoryComparisonUseCaseProvider._();

/// Provides the [GetPersonalHistoryComparisonUseCase] for the guest-only
/// "local leaderboard" (SPEC.md §7.1/§11.4).

final class GetPersonalHistoryComparisonUseCaseProvider
    extends
        $FunctionalProvider<
          GetPersonalHistoryComparisonUseCase,
          GetPersonalHistoryComparisonUseCase,
          GetPersonalHistoryComparisonUseCase
        >
    with $Provider<GetPersonalHistoryComparisonUseCase> {
  /// Provides the [GetPersonalHistoryComparisonUseCase] for the guest-only
  /// "local leaderboard" (SPEC.md §7.1/§11.4).
  GetPersonalHistoryComparisonUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPersonalHistoryComparisonUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$getPersonalHistoryComparisonUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPersonalHistoryComparisonUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPersonalHistoryComparisonUseCase create(Ref ref) {
    return getPersonalHistoryComparisonUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPersonalHistoryComparisonUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPersonalHistoryComparisonUseCase>(
        value,
      ),
    );
  }
}

String _$getPersonalHistoryComparisonUseCaseHash() =>
    r'28f56e8ddf9374cb542ea05c0b6812f17cd25614';

/// The active profile's personal-history comparison for [category] —
/// SPEC.md §7.1/§11.4's guest-only "local leaderboard".

@ProviderFor(personalHistoryForCategory)
final personalHistoryForCategoryProvider = PersonalHistoryForCategoryFamily._();

/// The active profile's personal-history comparison for [category] —
/// SPEC.md §7.1/§11.4's guest-only "local leaderboard".

final class PersonalHistoryForCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PersonalHistoryComparison>,
          PersonalHistoryComparison,
          FutureOr<PersonalHistoryComparison>
        >
    with
        $FutureModifier<PersonalHistoryComparison>,
        $FutureProvider<PersonalHistoryComparison> {
  /// The active profile's personal-history comparison for [category] —
  /// SPEC.md §7.1/§11.4's guest-only "local leaderboard".
  PersonalHistoryForCategoryProvider._({
    required PersonalHistoryForCategoryFamily super.from,
    required ContentCategory super.argument,
  }) : super(
         retry: null,
         name: r'personalHistoryForCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personalHistoryForCategoryHash();

  @override
  String toString() {
    return r'personalHistoryForCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PersonalHistoryComparison> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PersonalHistoryComparison> create(Ref ref) {
    final argument = this.argument as ContentCategory;
    return personalHistoryForCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalHistoryForCategoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personalHistoryForCategoryHash() =>
    r'a7485997f26071a476a14ed0f7acf8a552548ac3';

/// The active profile's personal-history comparison for [category] —
/// SPEC.md §7.1/§11.4's guest-only "local leaderboard".

final class PersonalHistoryForCategoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PersonalHistoryComparison>,
          ContentCategory
        > {
  PersonalHistoryForCategoryFamily._()
    : super(
        retry: null,
        name: r'personalHistoryForCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The active profile's personal-history comparison for [category] —
  /// SPEC.md §7.1/§11.4's guest-only "local leaderboard".

  PersonalHistoryForCategoryProvider call(ContentCategory category) =>
      PersonalHistoryForCategoryProvider._(argument: category, from: this);

  @override
  String toString() => r'personalHistoryForCategoryProvider';
}

/// Exposes the active profile's cached [ProgressSnapshot] reactively,
/// recomputing/backfilling on first load as a safety net for anything a
/// prior fire-and-forget recompute might have missed (e.g. an app crash
/// between a session finishing and that call completing) — cheap and
/// idempotent, so re-running it here is never wasted work.

@ProviderFor(ProgressSnapshotController)
final progressSnapshotControllerProvider =
    ProgressSnapshotControllerProvider._();

/// Exposes the active profile's cached [ProgressSnapshot] reactively,
/// recomputing/backfilling on first load as a safety net for anything a
/// prior fire-and-forget recompute might have missed (e.g. an app crash
/// between a session finishing and that call completing) — cheap and
/// idempotent, so re-running it here is never wasted work.
final class ProgressSnapshotControllerProvider
    extends
        $StreamNotifierProvider<ProgressSnapshotController, ProgressSnapshot?> {
  /// Exposes the active profile's cached [ProgressSnapshot] reactively,
  /// recomputing/backfilling on first load as a safety net for anything a
  /// prior fire-and-forget recompute might have missed (e.g. an app crash
  /// between a session finishing and that call completing) — cheap and
  /// idempotent, so re-running it here is never wasted work.
  ProgressSnapshotControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressSnapshotControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressSnapshotControllerHash();

  @$internal
  @override
  ProgressSnapshotController create() => ProgressSnapshotController();
}

String _$progressSnapshotControllerHash() =>
    r'0ebeb8bdde873b333ae0c6993274456787d5a1aa';

/// Exposes the active profile's cached [ProgressSnapshot] reactively,
/// recomputing/backfilling on first load as a safety net for anything a
/// prior fire-and-forget recompute might have missed (e.g. an app crash
/// between a session finishing and that call completing) — cheap and
/// idempotent, so re-running it here is never wasted work.

abstract class _$ProgressSnapshotController
    extends $StreamNotifier<ProgressSnapshot?> {
  Stream<ProgressSnapshot?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProgressSnapshot?>, ProgressSnapshot?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProgressSnapshot?>, ProgressSnapshot?>,
              AsyncValue<ProgressSnapshot?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
