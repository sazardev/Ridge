import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/achievements/domain/entities/achievement.dart';
import 'package:ridge/features/achievements/domain/entities/session_achievement_input.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter — an `achievements`-owned DAO
/// issuing its own queries directly against `practice`'s
/// `typing_sessions`/`keystroke_events` tables (an allowed
/// infrastructure-to-infrastructure dependency, mirrors `progression`'s
/// `ProgressionDao`) plus this feature's own `achievements_unlocked`
/// table.
///
/// `progression`'s already-computed streak/mastery results are
/// deliberately NOT re-queried here: `EvaluateAchievementsUseCase`
/// consumes them straight off the `ProgressSnapshot` that
/// `RecomputeProgressSnapshotUseCase` itself returns (see that use
/// case's class doc), so this port only needs to cover what nothing else
/// already exposes — per-session inputs and the lifetime marathon total
/// — plus the unlocked-achievements ledger itself.
abstract interface class AchievementRepository {
  /// Emits every currently-unlocked achievement for [profileId], and
  /// every subsequent change — the Achievements screen's live view.
  Stream<List<Achievement>> watchUnlocked(ProfileId profileId);

  /// The currently-unlocked achievements for [profileId], read once —
  /// `EvaluateAchievementsUseCase`'s ratchet check (only ever unlock
  /// what isn't already unlocked).
  Future<Result<List<Achievement>, AppFailure>> getUnlocked(
    ProfileId profileId,
  );

  /// Idempotently records [achievement] as unlocked for [profileId] — a
  /// no-op (never an error, and never overwriting the original
  /// `unlockedAt`/`triggerSessionId`) if it was already unlocked.
  Future<Result<void, AppFailure>> recordUnlock({
    required ProfileId profileId,
    required Achievement achievement,
  });

  /// Per-session inputs "Cero Errores"/"Ambidiestro" need, for every one
  /// of [profileId]'s finished sessions.
  Future<Result<List<SessionAchievementInput>, AppFailure>>
  getSessionAchievementInputs(ProfileId profileId);

  /// The lifetime sum of correct-first-try characters across every one
  /// of [profileId]'s sessions, with no recency window — "Maratonista"'s
  /// true career total, unlike `progression`'s windowed weakness
  /// queries.
  Future<Result<int, AppFailure>> getLifetimeCorrectFirstTryCharCount(
    ProfileId profileId,
  );
}
