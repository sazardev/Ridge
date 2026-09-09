import 'dart:async';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/features/achievements/application/usecases/evaluate_achievements_usecase.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement.dart';
import 'package:just_in_time/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:just_in_time/features/achievements/infrastructure/achievement_dao.dart';
import 'package:just_in_time/features/achievements/infrastructure/achievement_repository_impl.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:just_in_time/features/progression/presentation/providers/progression_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievements_providers.g.dart';

/// Provides the [AchievementDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
AchievementDao achievementDao(Ref ref) {
  return ref.watch(appDatabaseProvider).achievementDao;
}

/// Provides the [AchievementRepository] implementation used across the
/// app.
@Riverpod(keepAlive: true)
AchievementRepository achievementRepository(Ref ref) {
  return AchievementRepositoryImpl(ref.watch(achievementDaoProvider));
}

/// Provides the [EvaluateAchievementsUseCase], fired right after every
/// finished `practice` session and again as a safety net when the
/// Achievements screen first loads.
@riverpod
EvaluateAchievementsUseCase evaluateAchievementsUseCase(Ref ref) {
  return EvaluateAchievementsUseCase(
    ref.watch(achievementRepositoryProvider),
    ref.watch(recomputeProgressSnapshotUseCaseProvider),
  );
}

/// Exposes the active profile's unlocked achievements reactively,
/// recomputing on first load as a safety net for anything a prior
/// fire-and-forget evaluate might have missed (mirrors `progression`'s
/// `ProgressSnapshotController`/`learning_paths`'
/// `LessonProgressController`).
@Riverpod(keepAlive: true)
class UnlockedAchievementsController extends _$UnlockedAchievementsController {
  @override
  Stream<List<Achievement>> build() {
    final profile = ref.watch(activeProfileControllerProvider).value;
    if (profile == null) return const Stream.empty();

    unawaited(ref.read(evaluateAchievementsUseCaseProvider)(profile.id));

    return ref.watch(achievementRepositoryProvider).watchUnlocked(profile.id);
  }
}
