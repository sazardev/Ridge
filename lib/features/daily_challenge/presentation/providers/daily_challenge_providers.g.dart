// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [DailyChallengeDao] bound to the shared [AppDatabase].

@ProviderFor(dailyChallengeDao)
final dailyChallengeDaoProvider = DailyChallengeDaoProvider._();

/// Provides the [DailyChallengeDao] bound to the shared [AppDatabase].

final class DailyChallengeDaoProvider
    extends
        $FunctionalProvider<
          DailyChallengeDao,
          DailyChallengeDao,
          DailyChallengeDao
        >
    with $Provider<DailyChallengeDao> {
  /// Provides the [DailyChallengeDao] bound to the shared [AppDatabase].
  DailyChallengeDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyChallengeDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeDaoHash();

  @$internal
  @override
  $ProviderElement<DailyChallengeDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyChallengeDao create(Ref ref) {
    return dailyChallengeDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyChallengeDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyChallengeDao>(value),
    );
  }
}

String _$dailyChallengeDaoHash() => r'46116d0fb7b4aa45819cbaa1f37c3c0fd2310fa1';

/// Provides the [DailyChallengeRepository] implementation used across
/// the app.

@ProviderFor(dailyChallengeRepository)
final dailyChallengeRepositoryProvider = DailyChallengeRepositoryProvider._();

/// Provides the [DailyChallengeRepository] implementation used across
/// the app.

final class DailyChallengeRepositoryProvider
    extends
        $FunctionalProvider<
          DailyChallengeRepository,
          DailyChallengeRepository,
          DailyChallengeRepository
        >
    with $Provider<DailyChallengeRepository> {
  /// Provides the [DailyChallengeRepository] implementation used across
  /// the app.
  DailyChallengeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyChallengeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeRepositoryHash();

  @$internal
  @override
  $ProviderElement<DailyChallengeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyChallengeRepository create(Ref ref) {
    return dailyChallengeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyChallengeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyChallengeRepository>(value),
    );
  }
}

String _$dailyChallengeRepositoryHash() =>
    r'42fb594738073b96cfab253d6a1b90cde94991ad';

/// Provides the [GetTodaysDailyChallengeUseCase] for resolving today's
/// shared snippet.

@ProviderFor(getTodaysDailyChallengeUseCase)
final getTodaysDailyChallengeUseCaseProvider =
    GetTodaysDailyChallengeUseCaseProvider._();

/// Provides the [GetTodaysDailyChallengeUseCase] for resolving today's
/// shared snippet.

final class GetTodaysDailyChallengeUseCaseProvider
    extends
        $FunctionalProvider<
          GetTodaysDailyChallengeUseCase,
          GetTodaysDailyChallengeUseCase,
          GetTodaysDailyChallengeUseCase
        >
    with $Provider<GetTodaysDailyChallengeUseCase> {
  /// Provides the [GetTodaysDailyChallengeUseCase] for resolving today's
  /// shared snippet.
  GetTodaysDailyChallengeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodaysDailyChallengeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodaysDailyChallengeUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTodaysDailyChallengeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetTodaysDailyChallengeUseCase create(Ref ref) {
    return getTodaysDailyChallengeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTodaysDailyChallengeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTodaysDailyChallengeUseCase>(
        value,
      ),
    );
  }
}

String _$getTodaysDailyChallengeUseCaseHash() =>
    r'dd41f792e69c5ca44166251c6aae7b4b06bd82ce';

/// Provides the [GetDailyChallengeStatusUseCase] for the "already played
/// today" check.

@ProviderFor(getDailyChallengeStatusUseCase)
final getDailyChallengeStatusUseCaseProvider =
    GetDailyChallengeStatusUseCaseProvider._();

/// Provides the [GetDailyChallengeStatusUseCase] for the "already played
/// today" check.

final class GetDailyChallengeStatusUseCaseProvider
    extends
        $FunctionalProvider<
          GetDailyChallengeStatusUseCase,
          GetDailyChallengeStatusUseCase,
          GetDailyChallengeStatusUseCase
        >
    with $Provider<GetDailyChallengeStatusUseCase> {
  /// Provides the [GetDailyChallengeStatusUseCase] for the "already played
  /// today" check.
  GetDailyChallengeStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDailyChallengeStatusUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDailyChallengeStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetDailyChallengeStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetDailyChallengeStatusUseCase create(Ref ref) {
    return getDailyChallengeStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDailyChallengeStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDailyChallengeStatusUseCase>(
        value,
      ),
    );
  }
}

String _$getDailyChallengeStatusUseCaseHash() =>
    r'007d525c9fc2b4fa6b3f234a464a8e3afd77a963';

/// Provides the [RecordDailyChallengeCompletionUseCase] used after a
/// practice session finishes.

@ProviderFor(recordDailyChallengeCompletionUseCase)
final recordDailyChallengeCompletionUseCaseProvider =
    RecordDailyChallengeCompletionUseCaseProvider._();

/// Provides the [RecordDailyChallengeCompletionUseCase] used after a
/// practice session finishes.

final class RecordDailyChallengeCompletionUseCaseProvider
    extends
        $FunctionalProvider<
          RecordDailyChallengeCompletionUseCase,
          RecordDailyChallengeCompletionUseCase,
          RecordDailyChallengeCompletionUseCase
        >
    with $Provider<RecordDailyChallengeCompletionUseCase> {
  /// Provides the [RecordDailyChallengeCompletionUseCase] used after a
  /// practice session finishes.
  RecordDailyChallengeCompletionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordDailyChallengeCompletionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$recordDailyChallengeCompletionUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecordDailyChallengeCompletionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordDailyChallengeCompletionUseCase create(Ref ref) {
    return recordDailyChallengeCompletionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordDailyChallengeCompletionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<RecordDailyChallengeCompletionUseCase>(value),
    );
  }
}

String _$recordDailyChallengeCompletionUseCaseHash() =>
    r'6bcba7535322d31e7ff0402f43269771804eb9d5';

/// Provides the [WatchDailyChallengeStreakUseCase] for observing the
/// streak.

@ProviderFor(watchDailyChallengeStreakUseCase)
final watchDailyChallengeStreakUseCaseProvider =
    WatchDailyChallengeStreakUseCaseProvider._();

/// Provides the [WatchDailyChallengeStreakUseCase] for observing the
/// streak.

final class WatchDailyChallengeStreakUseCaseProvider
    extends
        $FunctionalProvider<
          WatchDailyChallengeStreakUseCase,
          WatchDailyChallengeStreakUseCase,
          WatchDailyChallengeStreakUseCase
        >
    with $Provider<WatchDailyChallengeStreakUseCase> {
  /// Provides the [WatchDailyChallengeStreakUseCase] for observing the
  /// streak.
  WatchDailyChallengeStreakUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchDailyChallengeStreakUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchDailyChallengeStreakUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchDailyChallengeStreakUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchDailyChallengeStreakUseCase create(Ref ref) {
    return watchDailyChallengeStreakUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchDailyChallengeStreakUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchDailyChallengeStreakUseCase>(
        value,
      ),
    );
  }
}

String _$watchDailyChallengeStreakUseCaseHash() =>
    r'5ce827f32d2476076a5eb2115a98a08dc301f329';

/// Streams [profileId]'s current Daily Challenge streak, evaluated
/// against today's UTC date.

@ProviderFor(dailyChallengeStreak)
final dailyChallengeStreakProvider = DailyChallengeStreakFamily._();

/// Streams [profileId]'s current Daily Challenge streak, evaluated
/// against today's UTC date.

final class DailyChallengeStreakProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Streams [profileId]'s current Daily Challenge streak, evaluated
  /// against today's UTC date.
  DailyChallengeStreakProvider._({
    required DailyChallengeStreakFamily super.from,
    required ProfileId super.argument,
  }) : super(
         retry: null,
         name: r'dailyChallengeStreakProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeStreakHash();

  @override
  String toString() {
    return r'dailyChallengeStreakProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as ProfileId;
    return dailyChallengeStreak(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyChallengeStreakProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyChallengeStreakHash() =>
    r'4452ac4fd839acbbf1f0e6cf4ca4ea1190f7e758';

/// Streams [profileId]'s current Daily Challenge streak, evaluated
/// against today's UTC date.

final class DailyChallengeStreakFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, ProfileId> {
  DailyChallengeStreakFamily._()
    : super(
        retry: null,
        name: r'dailyChallengeStreakProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams [profileId]'s current Daily Challenge streak, evaluated
  /// against today's UTC date.

  DailyChallengeStreakProvider call(ProfileId profileId) =>
      DailyChallengeStreakProvider._(argument: profileId, from: this);

  @override
  String toString() => r'dailyChallengeStreakProvider';
}

/// Resolves the entry-point card's full data, or `null` when there's
/// nothing to show — no Guest Profile yet, or no eligible Go snippet
/// available (the surrounding `FreePracticeScreen` already surfaces its
/// own "no snippets available" message in that same situation, so the
/// card just stays hidden rather than repeating it).

@ProviderFor(dailyChallengeCard)
final dailyChallengeCardProvider = DailyChallengeCardProvider._();

/// Resolves the entry-point card's full data, or `null` when there's
/// nothing to show — no Guest Profile yet, or no eligible Go snippet
/// available (the surrounding `FreePracticeScreen` already surfaces its
/// own "no snippets available" message in that same situation, so the
/// card just stays hidden rather than repeating it).

final class DailyChallengeCardProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyChallengeCardData?>,
          DailyChallengeCardData?,
          FutureOr<DailyChallengeCardData?>
        >
    with
        $FutureModifier<DailyChallengeCardData?>,
        $FutureProvider<DailyChallengeCardData?> {
  /// Resolves the entry-point card's full data, or `null` when there's
  /// nothing to show — no Guest Profile yet, or no eligible Go snippet
  /// available (the surrounding `FreePracticeScreen` already surfaces its
  /// own "no snippets available" message in that same situation, so the
  /// card just stays hidden rather than repeating it).
  DailyChallengeCardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyChallengeCardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyChallengeCardHash();

  @$internal
  @override
  $FutureProviderElement<DailyChallengeCardData?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailyChallengeCardData?> create(Ref ref) {
    return dailyChallengeCard(ref);
  }
}

String _$dailyChallengeCardHash() =>
    r'b20bfbaa2ad536e7f0fc6aa89b78d07149557746';
