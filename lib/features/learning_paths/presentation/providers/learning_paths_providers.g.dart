// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_paths_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [LessonProgressDao] bound to the shared [AppDatabase].

@ProviderFor(lessonProgressDao)
final lessonProgressDaoProvider = LessonProgressDaoProvider._();

/// Provides the [LessonProgressDao] bound to the shared [AppDatabase].

final class LessonProgressDaoProvider
    extends
        $FunctionalProvider<
          LessonProgressDao,
          LessonProgressDao,
          LessonProgressDao
        >
    with $Provider<LessonProgressDao> {
  /// Provides the [LessonProgressDao] bound to the shared [AppDatabase].
  LessonProgressDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonProgressDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonProgressDaoHash();

  @$internal
  @override
  $ProviderElement<LessonProgressDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LessonProgressDao create(Ref ref) {
    return lessonProgressDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonProgressDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonProgressDao>(value),
    );
  }
}

String _$lessonProgressDaoHash() => r'e11a597eda67d98afde5000ed447d1e28965698e';

/// Provides the [LearningPathRepository] implementation used across the
/// app.

@ProviderFor(learningPathRepository)
final learningPathRepositoryProvider = LearningPathRepositoryProvider._();

/// Provides the [LearningPathRepository] implementation used across the
/// app.

final class LearningPathRepositoryProvider
    extends
        $FunctionalProvider<
          LearningPathRepository,
          LearningPathRepository,
          LearningPathRepository
        >
    with $Provider<LearningPathRepository> {
  /// Provides the [LearningPathRepository] implementation used across the
  /// app.
  LearningPathRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningPathRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningPathRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearningPathRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningPathRepository create(Ref ref) {
    return learningPathRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningPathRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningPathRepository>(value),
    );
  }
}

String _$learningPathRepositoryHash() =>
    r'b1bc342dd60eae80da17c8562b3cf1dbfcc58b86';

/// Provides the [LessonProgressRepository] implementation used across the
/// app.

@ProviderFor(lessonProgressRepository)
final lessonProgressRepositoryProvider = LessonProgressRepositoryProvider._();

/// Provides the [LessonProgressRepository] implementation used across the
/// app.

final class LessonProgressRepositoryProvider
    extends
        $FunctionalProvider<
          LessonProgressRepository,
          LessonProgressRepository,
          LessonProgressRepository
        >
    with $Provider<LessonProgressRepository> {
  /// Provides the [LessonProgressRepository] implementation used across the
  /// app.
  LessonProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonProgressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<LessonProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LessonProgressRepository create(Ref ref) {
    return lessonProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonProgressRepository>(value),
    );
  }
}

String _$lessonProgressRepositoryHash() =>
    r'18192ced91d51b0f384d26bcd6b8b2e83d651b1e';

/// Provides the [GetLearningPathsUseCase] for the Learning Paths screen.

@ProviderFor(getLearningPathsUseCase)
final getLearningPathsUseCaseProvider = GetLearningPathsUseCaseProvider._();

/// Provides the [GetLearningPathsUseCase] for the Learning Paths screen.

final class GetLearningPathsUseCaseProvider
    extends
        $FunctionalProvider<
          GetLearningPathsUseCase,
          GetLearningPathsUseCase,
          GetLearningPathsUseCase
        >
    with $Provider<GetLearningPathsUseCase> {
  /// Provides the [GetLearningPathsUseCase] for the Learning Paths screen.
  GetLearningPathsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getLearningPathsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getLearningPathsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetLearningPathsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetLearningPathsUseCase create(Ref ref) {
    return getLearningPathsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetLearningPathsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetLearningPathsUseCase>(value),
    );
  }
}

String _$getLearningPathsUseCaseHash() =>
    r'2687ca08a727ff42d7c1e75057dcf7368aa321f9';

/// Provides the [RecomputeLessonProgressUseCase], fired right after every
/// finished `practice` session tagged with a lesson id.

@ProviderFor(recomputeLessonProgressUseCase)
final recomputeLessonProgressUseCaseProvider =
    RecomputeLessonProgressUseCaseProvider._();

/// Provides the [RecomputeLessonProgressUseCase], fired right after every
/// finished `practice` session tagged with a lesson id.

final class RecomputeLessonProgressUseCaseProvider
    extends
        $FunctionalProvider<
          RecomputeLessonProgressUseCase,
          RecomputeLessonProgressUseCase,
          RecomputeLessonProgressUseCase
        >
    with $Provider<RecomputeLessonProgressUseCase> {
  /// Provides the [RecomputeLessonProgressUseCase], fired right after every
  /// finished `practice` session tagged with a lesson id.
  RecomputeLessonProgressUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recomputeLessonProgressUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recomputeLessonProgressUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecomputeLessonProgressUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecomputeLessonProgressUseCase create(Ref ref) {
    return recomputeLessonProgressUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecomputeLessonProgressUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecomputeLessonProgressUseCase>(
        value,
      ),
    );
  }
}

String _$recomputeLessonProgressUseCaseHash() =>
    r'32c99743434df5591c36326ac8393e01086554ef';

/// Exposes every bundled path, joined against `content`, reactively.

@ProviderFor(LearningPathsController)
final learningPathsControllerProvider = LearningPathsControllerProvider._();

/// Exposes every bundled path, joined against `content`, reactively.
final class LearningPathsControllerProvider
    extends
        $AsyncNotifierProvider<
          LearningPathsController,
          List<LearningPathOverview>
        > {
  /// Exposes every bundled path, joined against `content`, reactively.
  LearningPathsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningPathsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningPathsControllerHash();

  @$internal
  @override
  LearningPathsController create() => LearningPathsController();
}

String _$learningPathsControllerHash() =>
    r'fb232c4b77d9830c77e130fb3e0e13a5d71af810';

/// Exposes every bundled path, joined against `content`, reactively.

abstract class _$LearningPathsController
    extends $AsyncNotifier<List<LearningPathOverview>> {
  FutureOr<List<LearningPathOverview>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LearningPathOverview>>,
              List<LearningPathOverview>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LearningPathOverview>>,
                List<LearningPathOverview>
              >,
              AsyncValue<List<LearningPathOverview>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Exposes the active profile's cached lesson statuses reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget recompute might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`).

@ProviderFor(LessonProgressController)
final lessonProgressControllerProvider = LessonProgressControllerProvider._();

/// Exposes the active profile's cached lesson statuses reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget recompute might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`).
final class LessonProgressControllerProvider
    extends
        $StreamNotifierProvider<
          LessonProgressController,
          Map<LessonId, LessonStatus>
        > {
  /// Exposes the active profile's cached lesson statuses reactively,
  /// recomputing on first load as a safety net for anything a prior
  /// fire-and-forget recompute might have missed (mirrors `progression`'s
  /// `ProgressSnapshotController`).
  LessonProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonProgressControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonProgressControllerHash();

  @$internal
  @override
  LessonProgressController create() => LessonProgressController();
}

String _$lessonProgressControllerHash() =>
    r'64bf70467578bb7ee7d68642ed2804d07c4b7d76';

/// Exposes the active profile's cached lesson statuses reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget recompute might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`).

abstract class _$LessonProgressController
    extends $StreamNotifier<Map<LessonId, LessonStatus>> {
  Stream<Map<LessonId, LessonStatus>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<LessonId, LessonStatus>>,
              Map<LessonId, LessonStatus>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<LessonId, LessonStatus>>,
                Map<LessonId, LessonStatus>
              >,
              AsyncValue<Map<LessonId, LessonStatus>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
