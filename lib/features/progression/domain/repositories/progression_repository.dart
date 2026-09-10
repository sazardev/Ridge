import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/entities/key_transition_sample.dart';
import 'package:ridge/features/progression/domain/entities/keystroke_sample.dart';
import 'package:ridge/features/progression/domain/entities/mastery_status.dart';
import 'package:ridge/features/progression/domain/entities/ngram_sample.dart';
import 'package:ridge/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:ridge/features/progression/domain/entities/precision_result.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/domain/entities/session_activity_sample.dart';
import 'package:ridge/features/progression/domain/entities/unprocessed_session.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter — a `progression`-owned DAO
/// issuing its own queries directly against `practice`'s
/// `typing_sessions`/`keystroke_events` drift tables (imported as plain
/// `Table` classes, an allowed infrastructure-to-infrastructure
/// dependency) plus `progression`'s own cache tables (see the project
/// plan). This port is deliberately a rich, specialized read/write
/// surface — `progression` computes real business logic
/// (`RecomputeProgressSnapshotUseCase`) from many small, purpose-built
/// queries rather than one opaque "recompute everything" repository
/// method.
abstract interface class ProgressionRepository {
  /// Emits the cached snapshot for [profileId] (`null` before any
  /// recompute has ever run for it), and every subsequent change.
  Stream<ProgressSnapshot?> watchSnapshot(ProfileId profileId);

  /// Every one of [profileId]'s finished sessions that hasn't yet been
  /// backfilled with real `xp_awarded`/`is_first_completion` values,
  /// oldest first — so first-completion/streak context accumulates in
  /// true chronological order as they're processed.
  Future<Result<List<UnprocessedSession>, AppFailure>> getUnprocessedSessions(
    ProfileId profileId,
  );

  /// Whether [profileId] has already completed [snippetId] (any
  /// revision) before — used to award the first-completion XP bonus at
  /// most once per snippet.
  Future<Result<bool, AppFailure>> hasCompletedSnippetBefore({
    required ProfileId profileId,
    required SnippetId snippetId,
  });

  /// Backfills the two derived columns onto an already-persisted
  /// session and marks it processed — the one narrow, intentional
  /// exception to "sessions are immutable" (SPEC.md §8.1), written once,
  /// immediately, never touched again after.
  Future<Result<void, AppFailure>> markSessionProcessed({
    required ProfileId profileId,
    required TypingSessionId sessionId,
    required int xpAwarded,
    required bool isFirstCompletion,
  });

  /// Every finished session's start time for [profileId] — raw UTC
  /// instants; local-calendar-day bucketing is the caller's job
  /// (`StreakCalculator`).
  Future<Result<List<DateTime>, AppFailure>> getSessionStartTimestamps(
    ProfileId profileId,
  );

  /// The sum of `xp_awarded` across every one of [profileId]'s sessions
  /// — only meaningful after every session has been backfilled.
  Future<Result<int, AppFailure>> getTotalXpAwarded(ProfileId profileId);

  /// Raw per-keystroke samples for [profileId] since [since], for
  /// character/finger weakness ranking.
  Future<Result<List<KeystrokeSample>, AppFailure>> getKeystrokeSamples({
    required ProfileId profileId,
    required DateTime since,
  });

  /// Raw 2-character n-gram samples for [profileId] since [since]
  /// (adjacent forward keystrokes within the same session), for n-gram
  /// weakness ranking.
  Future<Result<List<NgramSample>, AppFailure>> getNgramSamples({
    required ProfileId profileId,
    required DateTime since,
  });

  /// Raw physical key-transition samples for [profileId] since [since]
  /// (adjacent forward keystrokes within the same session, keyed by
  /// physical key pair rather than character), for key-transition
  /// weakness ranking (SPEC.md §4.1).
  Future<Result<List<KeyTransitionSample>, AppFailure>>
  getKeyTransitionSamples({
    required ProfileId profileId,
    required DateTime since,
  });

  /// Every one of [profileId]'s finished sessions, reduced to exactly
  /// what activity ranking needs — no `since` filter, since
  /// `ActivityRankingCalculator` itself partitions "most practiced"
  /// (lifetime) from "lowest scoring" (recency-windowed) internally.
  Future<Result<List<SessionActivitySample>, AppFailure>>
  getSessionActivitySamples(ProfileId profileId);

  /// The most recent Precision-mode results for [profileId] on
  /// [category]/[difficulty], newest first, capped at [limit] —
  /// `MasteryEvaluator`'s evaluation window.
  Future<Result<List<PrecisionResult>, AppFailure>> getRecentPrecisionResults({
    required ProfileId profileId,
    required ContentCategory category,
    required Difficulty difficulty,
    int limit = 5,
  });

  /// The currently cached mastery status for [profileId] on
  /// [category]/[difficulty], or `null` if it's never been evaluated —
  /// needed for `MasteryEvaluator`'s decay hysteresis.
  Future<Result<MasteryStatus?, AppFailure>> getMasteryStatus({
    required ProfileId profileId,
    required ContentCategory category,
    required Difficulty difficulty,
  });

  /// Every cached mastery status for [profileId], across every
  /// (category, difficulty) pair ever evaluated — the full picture a
  /// Progress screen renders (only the pairs touched by newly-processed
  /// sessions are re-evaluated on any given recompute; the rest are read
  /// back from cache unchanged).
  Future<Result<List<MasteryStatus>, AppFailure>> getAllMasteryStatuses(
    ProfileId profileId,
  );

  /// Persists [snapshot], replacing whatever was cached before for its
  /// profile.
  Future<Result<void, AppFailure>> persistSnapshot(ProgressSnapshot snapshot);

  /// Persists [status], replacing whatever was cached before for
  /// [profileId] on that (category, difficulty).
  Future<Result<void, AppFailure>> persistMasteryStatus({
    required ProfileId profileId,
    required MasteryStatus status,
  });

  /// A rolling comparison of [profileId]'s own last [sampleSize]
  /// sessions against [snippetId] (if given) or [category] (if given) —
  /// SPEC.md §7.1/§11.4's guest-only "local leaderboard".
  Future<Result<PersonalHistoryComparison, AppFailure>>
  getPersonalHistoryComparison({
    required ProfileId profileId,
    SnippetId? snippetId,
    ContentCategory? category,
    int sampleSize = 5,
  });
}
