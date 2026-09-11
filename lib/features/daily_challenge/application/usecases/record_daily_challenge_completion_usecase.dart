import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/practice/application/usecases/finish_practice_session_usecase.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/services/precision_score_calculator.dart';

/// Records a just-finished practice session as today's Daily Challenge
/// completion (SPEC.md §5.4), if — and only if — it actually was one.
///
/// Called unconditionally after every finished session (mirrors
/// `PracticeSessionController._persistFinishedSession`'s existing
/// fire-and-forget calls, none of which gate on `mode` themselves): a
/// session finished under any other [PracticeMode] variant is a no-op
/// here, exactly like `EvaluateAchievementsUseCase` is "self-sufficient
/// regardless of ordering/timing" with its own callers.
class RecordDailyChallengeCompletionUseCase {
  /// Creates the use case over the given [DailyChallengeRepository] port
  /// and an optional injected [scoreCalculator] (defaults to the real
  /// one, shared with [FinishPracticeSessionUseCase]'s own pass/fail
  /// decision so both agree on the same accuracy-to-score mapping).
  const new(
    this._repository, {
    this.scoreCalculator = const PrecisionScoreCalculator(),
  });

  final DailyChallengeRepository _repository;

  /// The (pure, stateless) calculator used to turn accuracy into a 1-10
  /// score.
  final PrecisionScoreCalculator scoreCalculator;

  /// Records [finished] as a Daily Challenge completion if its practice
  /// mode was `PracticeMode.dailyChallenge`; a no-op (`Result.ok(null)`)
  /// for every other mode.
  Future<Result<void, AppFailure>> call(FinishedPracticeSession finished) {
    final session = finished.session;
    final challengeDate = session.mode.maybeWhen(
      dailyChallenge: (date) => date,
      orElse: () => null,
    );
    if (challengeDate == null) return Future.value(const Result.ok(null));

    return _repository.recordCompletion(
      DailyChallengeCompletion(
        profileId: session.profileId,
        date: ChallengeDate.fromUtc(challengeDate),
        snippetId: session.snippetId,
        snippetRevision: session.snippetRevision,
        sessionId: session.id,
        score: scoreCalculator.scoreFor(finished.metrics.accuracyPct),
        passed: session.passed ?? false,
        completedAtUtc: DateTime.now().toUtc(),
      ),
    );
  }
}
