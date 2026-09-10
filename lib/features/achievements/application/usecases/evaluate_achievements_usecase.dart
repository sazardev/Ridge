import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/achievements/domain/entities/achievement.dart';
import 'package:ridge/features/achievements/domain/entities/achievement_id.dart';
import 'package:ridge/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:ridge/features/achievements/domain/entities/streak_tier.dart';
import 'package:ridge/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:ridge/features/achievements/domain/services/achievement_rules.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/application/usecases/recompute_progress_snapshot_usecase.dart';

/// Evaluates every SPEC.md §12 achievement rule for one profile and
/// unlocks whatever newly qualifies — idempotent, safe to call after
/// every finished `practice` session, and again as a safety net when the
/// Achievements screen loads (mirrors `progression`/`learning_paths`'
/// recompute use cases).
///
/// **Design** (see the project plan's "avoiding a fragile ordering
/// dependency" note): the two other fire-and-forget recomputes
/// `practice`'s controller fires after a finish
/// (`RecomputeProgressSnapshotUseCase`/`RecomputeLessonProgressUseCase`)
/// run concurrently with this one, so this use case cannot assume
/// `progression`'s caches are already fresh by the time it runs. Instead
/// it calls [_recomputeProgressSnapshot] itself, first — idempotent and
/// cheap per that use case's own design — and consumes the
/// `ProgressSnapshot` it returns directly (current streak, per-
/// (category, difficulty) mastery) rather than re-querying
/// `progression`'s cache tables a second time: this use case doesn't own
/// a copy of `MasteryEvaluator`/`StreakCalculator` logic, it only ever
/// *observes* what `progression` already computed (SPEC.md §12: "no
/// recomputation of the mastery logic itself").
class EvaluateAchievementsUseCase {
  /// Creates the use case over the given [AchievementRepository] port,
  /// `progression`'s [RecomputeProgressSnapshotUseCase] (an allowed
  /// cross-feature application-layer dependency — see the project plan's
  /// feature dependency order: `achievements` depends on `progression`'s
  /// snapshot and `practice`'s session data), and an optional injected
  /// (pure, stateless) [AchievementRules].
  const new(
    this._repository,
    this._recomputeProgressSnapshot, {
    this.rules = const AchievementRules(),
  });

  final AchievementRepository _repository;
  final RecomputeProgressSnapshotUseCase _recomputeProgressSnapshot;

  /// The (pure, stateless) rules evaluated against each already-computed
  /// input.
  final AchievementRules rules;

  /// Runs every rule for [profileId] and unlocks whatever newly
  /// qualifies, returning only the achievements unlocked by *this* call
  /// (empty if everything that currently qualifies was already
  /// unlocked). [now] is injected for deterministic testing, mirroring
  /// `RecomputeProgressSnapshotUseCase.call`.
  Future<Result<List<Achievement>, AppFailure>> call(
    ProfileId profileId, {
    DateTime? now,
  }) async {
    final nowUtc = (now ?? DateTime.now()).toUtc();

    final snapshotResult = await _recomputeProgressSnapshot(
      profileId: profileId,
      now: nowUtc,
    );
    if (snapshotResult.isErr) return Result.err(snapshotResult.failureOrNull!);
    final snapshot = snapshotResult.valueOrNull!;

    final unlockedResult = await _repository.getUnlocked(profileId);
    if (unlockedResult.isErr) return Result.err(unlockedResult.failureOrNull!);
    final alreadyUnlocked = {
      for (final a in unlockedResult.valueOrNull!) a.id.storageKey,
    };

    final newlyUnlocked = <Achievement>[];

    Future<Result<void, AppFailure>> unlockIfNew(
      AchievementId id, {
      TypingSessionId? triggerSessionId,
    }) async {
      if (alreadyUnlocked.contains(id.storageKey)) {
        return const Result.ok(null);
      }
      final achievement = Achievement(
        id: id,
        unlockedAt: nowUtc,
        triggerSessionId: triggerSessionId,
      );
      final recordResult = await _repository.recordUnlock(
        profileId: profileId,
        achievement: achievement,
      );
      if (recordResult.isErr) return recordResult;
      alreadyUnlocked.add(id.storageKey);
      newlyUnlocked.add(achievement);
      return const Result.ok(null);
    }

    // --- Rule 4: category mastery — observe `progression`'s
    // already-computed result, never recompute mastery here. ---
    for (final status in snapshot.masteryStatuses) {
      if (!rules.categoryMastery(isMastered: status.isMastered)) continue;
      final result = await unlockIfNew(
        AchievementId.categoryMastery(
          category: status.category,
          difficulty: status.difficulty,
        ),
      );
      if (result.isErr) return Result.err(result.failureOrNull!);
    }

    // --- Rule 5: streak badges. ---
    for (final tier in StreakTier.values) {
      if (!rules.streak(
        tier: tier,
        currentStreakDays: snapshot.currentStreakDays,
      )) {
        continue;
      }
      final result = await unlockIfNew(AchievementId.streak(tier));
      if (result.isErr) return Result.err(result.failureOrNull!);
    }

    // --- Rules 1 & 3: per-session milestones. ---
    final sessionInputsResult = await _repository.getSessionAchievementInputs(
      profileId,
    );
    if (sessionInputsResult.isErr) {
      return Result.err(sessionInputsResult.failureOrNull!);
    }
    for (final input in sessionInputsResult.valueOrNull!) {
      if (rules.ceroErrores(
        accuracyPct: input.accuracyPct,
        correctionsCount: input.correctionsCount,
      )) {
        final result = await unlockIfNew(
          const AchievementId.ceroErrores(),
          triggerSessionId: input.sessionId,
        );
        if (result.isErr) return Result.err(result.failureOrNull!);
      }
      if (rules.ambidiestro(
        charCount: input.forwardKeystrokeCount,
        handBalanceRatio: input.handBalanceRatio,
      )) {
        final result = await unlockIfNew(
          const AchievementId.ambidiestro(),
          triggerSessionId: input.sessionId,
        );
        if (result.isErr) return Result.err(result.failureOrNull!);
      }
    }

    // --- Rule 2: lifetime marathon tiers. ---
    final lifetimeCharsResult = await _repository
        .getLifetimeCorrectFirstTryCharCount(profileId);
    if (lifetimeCharsResult.isErr) {
      return Result.err(lifetimeCharsResult.failureOrNull!);
    }
    final lifetimeChars = lifetimeCharsResult.valueOrNull!;
    for (final tier in MaratonistaTier.values) {
      if (!rules.maratonista(
        tier: tier,
        lifetimeCorrectFirstTryChars: lifetimeChars,
      )) {
        continue;
      }
      final result = await unlockIfNew(AchievementId.maratonista(tier));
      if (result.isErr) return Result.err(result.failureOrNull!);
    }

    return Result.ok(newlyUnlocked);
  }
}
