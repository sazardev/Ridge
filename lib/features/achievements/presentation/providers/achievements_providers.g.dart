// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [AchievementDao] bound to the shared [AppDatabase].

@ProviderFor(achievementDao)
final achievementDaoProvider = AchievementDaoProvider._();

/// Provides the [AchievementDao] bound to the shared [AppDatabase].

final class AchievementDaoProvider
    extends $FunctionalProvider<AchievementDao, AchievementDao, AchievementDao>
    with $Provider<AchievementDao> {
  /// Provides the [AchievementDao] bound to the shared [AppDatabase].
  AchievementDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementDaoHash();

  @$internal
  @override
  $ProviderElement<AchievementDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AchievementDao create(Ref ref) {
    return achievementDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AchievementDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AchievementDao>(value),
    );
  }
}

String _$achievementDaoHash() => r'67b9e0fb30a96044b48b8918f09568fc604b9839';

/// Provides the [AchievementRepository] implementation used across the
/// app.

@ProviderFor(achievementRepository)
final achievementRepositoryProvider = AchievementRepositoryProvider._();

/// Provides the [AchievementRepository] implementation used across the
/// app.

final class AchievementRepositoryProvider
    extends
        $FunctionalProvider<
          AchievementRepository,
          AchievementRepository,
          AchievementRepository
        >
    with $Provider<AchievementRepository> {
  /// Provides the [AchievementRepository] implementation used across the
  /// app.
  AchievementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementRepositoryHash();

  @$internal
  @override
  $ProviderElement<AchievementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AchievementRepository create(Ref ref) {
    return achievementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AchievementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AchievementRepository>(value),
    );
  }
}

String _$achievementRepositoryHash() =>
    r'30dc64d8d85b97a54df14dfd94884adb284e019e';

/// Provides the [EvaluateAchievementsUseCase], fired right after every
/// finished `practice` session and again as a safety net when the
/// Achievements screen first loads.

@ProviderFor(evaluateAchievementsUseCase)
final evaluateAchievementsUseCaseProvider =
    EvaluateAchievementsUseCaseProvider._();

/// Provides the [EvaluateAchievementsUseCase], fired right after every
/// finished `practice` session and again as a safety net when the
/// Achievements screen first loads.

final class EvaluateAchievementsUseCaseProvider
    extends
        $FunctionalProvider<
          EvaluateAchievementsUseCase,
          EvaluateAchievementsUseCase,
          EvaluateAchievementsUseCase
        >
    with $Provider<EvaluateAchievementsUseCase> {
  /// Provides the [EvaluateAchievementsUseCase], fired right after every
  /// finished `practice` session and again as a safety net when the
  /// Achievements screen first loads.
  EvaluateAchievementsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evaluateAchievementsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evaluateAchievementsUseCaseHash();

  @$internal
  @override
  $ProviderElement<EvaluateAchievementsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvaluateAchievementsUseCase create(Ref ref) {
    return evaluateAchievementsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvaluateAchievementsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvaluateAchievementsUseCase>(value),
    );
  }
}

String _$evaluateAchievementsUseCaseHash() =>
    r'5657fe9ff3fc6c52607d43ac067be1d5a23c163c';

/// Exposes the active profile's unlocked achievements reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget evaluate might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`/`learning_paths`'
/// `LessonProgressController`).

@ProviderFor(UnlockedAchievementsController)
final unlockedAchievementsControllerProvider =
    UnlockedAchievementsControllerProvider._();

/// Exposes the active profile's unlocked achievements reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget evaluate might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`/`learning_paths`'
/// `LessonProgressController`).
final class UnlockedAchievementsControllerProvider
    extends
        $StreamNotifierProvider<
          UnlockedAchievementsController,
          List<Achievement>
        > {
  /// Exposes the active profile's unlocked achievements reactively,
  /// recomputing on first load as a safety net for anything a prior
  /// fire-and-forget evaluate might have missed (mirrors `progression`'s
  /// `ProgressSnapshotController`/`learning_paths`'
  /// `LessonProgressController`).
  UnlockedAchievementsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlockedAchievementsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlockedAchievementsControllerHash();

  @$internal
  @override
  UnlockedAchievementsController create() => UnlockedAchievementsController();
}

String _$unlockedAchievementsControllerHash() =>
    r'63ab812c07efd75f349aa28c2ec5b404fb06c376';

/// Exposes the active profile's unlocked achievements reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget evaluate might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`/`learning_paths`'
/// `LessonProgressController`).

abstract class _$UnlockedAchievementsController
    extends $StreamNotifier<List<Achievement>> {
  Stream<List<Achievement>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Achievement>>, List<Achievement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Achievement>>, List<Achievement>>,
              AsyncValue<List<Achievement>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
