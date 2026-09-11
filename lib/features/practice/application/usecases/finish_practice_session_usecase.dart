import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/session_metrics.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/domain/services/metrics_calculator.dart';
import 'package:ridge/features/practice/domain/services/precision_score_calculator.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// The result of successfully finishing and persisting a practice
/// session: the immutable record that was written, and the full derived
/// metrics the result screen needs (some of which — per-character/
/// finger/n-gram breakdowns — aren't their own persisted columns).
typedef FinishedPracticeSession = ({
  TypingSession session,
  SessionMetrics metrics,
});

/// Computes [SessionMetrics] from a finished session's captured
/// keystrokes and persists the closed, immutable session record
/// (SPEC.md §8.1).
///
/// `xpAwarded` and `isFirstCompletion` are written as placeholders (`0`/
/// `false`) — `practice` must not depend on `progression` (this
/// project's one-directional dependency graph runs the other way);
/// `progression`'s `RecomputeProgressSnapshotUseCase` backfills both
/// columns on this same row right after computing them. `passed` is
/// only ever non-`null` for [PracticeMode.precision]/
/// [PracticeMode.learningRouteLesson]/[PracticeMode.dailyChallenge],
/// where it is [PrecisionScoreCalculator.passes] applied to the
/// just-computed [SessionMetrics.accuracyPct] (SPEC.md §5.3, §5.4); Zen,
/// Sprint and Survival sessions always persist `passed: null` — pass/
/// fail is meaningless without a score to evaluate.
class FinishPracticeSessionUseCase {
  /// Creates the use case over the given [SessionRepository] port and
  /// optional injected calculators (both default to the real ones —
  /// tests can supply a fake for isolation, though both are already pure
  /// and cheap enough that most tests just use the defaults).
  const new(
    this._repository, {
    this.calculator = const MetricsCalculator(),
    this.scoreCalculator = const PrecisionScoreCalculator(),
  });

  final SessionRepository _repository;

  /// The (pure, stateless) calculator used to derive [SessionMetrics].
  final MetricsCalculator calculator;

  /// The (pure, stateless) calculator used to turn accuracy into a
  /// pass/fail decision for Precision-shaped modes.
  final PrecisionScoreCalculator scoreCalculator;

  /// Finishes the session described by the given parameters: computes
  /// metrics, builds the persisted record, and writes both through
  /// [SessionRepository.persistSession] in one transaction.
  Future<Result<FinishedPracticeSession, AppFailure>> call({
    required TypingSessionId id,
    required ProfileId profileId,
    required PracticeMode mode,
    required Snippet snippet,
    required DateTime startedAtUtc,
    required Duration duration,
    required List<Keystroke> keystrokes,
  }) {
    final metrics = calculator.calculate(
      keystrokes: keystrokes,
      expectedSnippet: snippet.code,
      totalDuration: duration,
    );
    // Only Precision-shaped modes (its Learning Route lesson variant, and
    // the Daily Challenge, SPEC.md §5.4) ever have a pass/fail threshold
    // to evaluate against; every other mode — including Survival, whose
    // score is run-local flavor — leaves `passed` at its `null` default
    // (SPEC.md §5.1/§5.2/§5.8).
    final passed = mode.maybeWhen(
      precision: () => scoreCalculator.passes(metrics.accuracyPct),
      learningRouteLesson: (_) => scoreCalculator.passes(metrics.accuracyPct),
      dailyChallenge: (_) => scoreCalculator.passes(metrics.accuracyPct),
      orElse: () => null,
    );
    final session = TypingSession(
      id: id,
      profileId: profileId,
      mode: mode,
      snippetId: snippet.id,
      snippetRevision: snippet.revision,
      category: snippet.category,
      difficulty: snippet.difficulty,
      startedAtUtc: startedAtUtc,
      duration: duration,
      rawSpeedCpm: metrics.rawSpeedCpm,
      netSpeedCpm: metrics.netSpeedCpm,
      accuracyPct: metrics.accuracyPct,
      consistencyScore: metrics.consistencyScore,
      maxStreak: metrics.maxStreak,
      fatigueFirstThirdCpm: metrics.fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm: metrics.fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: metrics.fatigueLastThirdCpm,
      handBalanceRatio: metrics.handBalanceRatio,
      passed: passed,
    );

    return _repository
        .persistSession(session: session, keystrokes: keystrokes)
        .then(
          (persisted) => persisted.fold(
            (_) => Result.ok((session: session, metrics: metrics)),
            Result.err,
          ),
        );
  }
}
