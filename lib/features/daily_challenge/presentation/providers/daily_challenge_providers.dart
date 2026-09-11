import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/daily_challenge/application/usecases/get_daily_challenge_status_usecase.dart';
import 'package:ridge/features/daily_challenge/application/usecases/get_todays_daily_challenge_usecase.dart';
import 'package:ridge/features/daily_challenge/application/usecases/record_daily_challenge_completion_usecase.dart';
import 'package:ridge/features/daily_challenge/application/usecases/watch_daily_challenge_streak_usecase.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/daily_challenge/infrastructure/daily_challenge_dao.dart';
import 'package:ridge/features/daily_challenge/infrastructure/daily_challenge_repository_impl.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_challenge_providers.g.dart';

/// The entry-point card's fully-resolved data: today's shared snippet,
/// whether the active profile has already completed it, and the
/// current Daily-Challenge streak.
typedef DailyChallengeCardData = ({
  Snippet snippet,
  ChallengeDate challengeDate,
  DailyChallengeCompletion? completion,
  int streak,
});

/// Provides the [DailyChallengeDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
DailyChallengeDao dailyChallengeDao(Ref ref) {
  return ref.watch(appDatabaseProvider).dailyChallengeDao;
}

/// Provides the [DailyChallengeRepository] implementation used across
/// the app.
@Riverpod(keepAlive: true)
DailyChallengeRepository dailyChallengeRepository(Ref ref) {
  return DailyChallengeRepositoryImpl(ref.watch(dailyChallengeDaoProvider));
}

/// Provides the [GetTodaysDailyChallengeUseCase] for resolving today's
/// shared snippet.
@riverpod
GetTodaysDailyChallengeUseCase getTodaysDailyChallengeUseCase(Ref ref) {
  return GetTodaysDailyChallengeUseCase(ref.watch(snippetRepositoryProvider));
}

/// Provides the [GetDailyChallengeStatusUseCase] for the "already played
/// today" check.
@riverpod
GetDailyChallengeStatusUseCase getDailyChallengeStatusUseCase(Ref ref) {
  return GetDailyChallengeStatusUseCase(
    ref.watch(dailyChallengeRepositoryProvider),
  );
}

/// Provides the [RecordDailyChallengeCompletionUseCase] used after a
/// practice session finishes.
@riverpod
RecordDailyChallengeCompletionUseCase recordDailyChallengeCompletionUseCase(
  Ref ref,
) {
  return RecordDailyChallengeCompletionUseCase(
    ref.watch(dailyChallengeRepositoryProvider),
  );
}

/// Provides the [WatchDailyChallengeStreakUseCase] for observing the
/// streak.
@riverpod
WatchDailyChallengeStreakUseCase watchDailyChallengeStreakUseCase(Ref ref) {
  return WatchDailyChallengeStreakUseCase(
    ref.watch(dailyChallengeRepositoryProvider),
  );
}

/// Streams [profileId]'s current Daily Challenge streak, evaluated
/// against today's UTC date.
@riverpod
Stream<int> dailyChallengeStreak(Ref ref, ProfileId profileId) {
  return ref.watch(watchDailyChallengeStreakUseCaseProvider)(
    profileId: profileId,
    today: ChallengeDate.fromUtc(DateTime.now().toUtc()),
  );
}

/// Resolves the entry-point card's full data, or `null` when there's
/// nothing to show — no Guest Profile yet, or no eligible Go snippet
/// available (the surrounding `FreePracticeScreen` already surfaces its
/// own "no snippets available" message in that same situation, so the
/// card just stays hidden rather than repeating it).
@riverpod
Future<DailyChallengeCardData?> dailyChallengeCard(Ref ref) async {
  final profile = ref.watch(activeProfileControllerProvider).value;
  if (profile == null) return null;

  final todayResult = await ref.watch(getTodaysDailyChallengeUseCaseProvider)(
    nowUtc: DateTime.now().toUtc(),
  );
  final today = todayResult.valueOrNull;
  if (today == null) return null;

  final completionResult = await ref.watch(
    getDailyChallengeStatusUseCaseProvider,
  )(profileId: profile.id, date: today.challenge.date);
  final streak = ref.watch(dailyChallengeStreakProvider(profile.id)).value ?? 0;

  return (
    snippet: today.snippet,
    challengeDate: today.challenge.date,
    completion: completionResult.valueOrNull,
    streak: streak,
  );
}
