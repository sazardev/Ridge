part of 'practice_session_controller.dart';

/// The fire-and-forget calls [PracticeSessionController] triggers after a
/// session finishes successfully — split into its own part file to keep
/// the controller focused on the session state machine itself. A
/// top-level function (not a method on the controller) since `ref` is a
/// protected member only accessible from within the controller's own
/// class body; the caller passes its own `ref` in explicitly.
///
/// None of these block the finish -> result transition: each is
/// idempotent/cheap, and self-sufficient regardless of the others'
/// ordering or timing.
///
/// - `progression`'s recompute (SPEC.md §6) — a failure here is silently
///   caught by the Progress screen's own safety-net recompute on next
///   load.
/// - `learning_paths`' lesson-progress recompute (SPEC.md §5.7) — a
///   no-op unless [finished] was tagged with a lesson id.
/// - `achievements`' evaluation (SPEC.md §12) — see
///   `EvaluateAchievementsUseCase`'s class doc.
/// - `daily_challenge`'s completion recording (SPEC.md §5.4) — a no-op
///   unless [finished]'s mode was `PracticeMode.dailyChallenge`, see
///   `RecordDailyChallengeCompletionUseCase`'s class doc.
void _notifyDownstreamFeatures(
  Ref ref, {
  required ProfileId profileId,
  required FinishedPracticeSession finished,
}) {
  unawaited(
    ref.read(recomputeProgressSnapshotUseCaseProvider)(
      profileId: profileId,
      now: DateTime.now(),
    ),
  );
  unawaited(ref.read(recomputeLessonProgressUseCaseProvider)(profileId));
  unawaited(ref.read(evaluateAchievementsUseCaseProvider)(profileId));
  unawaited(ref.read(recordDailyChallengeCompletionUseCaseProvider)(finished));
}
