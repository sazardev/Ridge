part of 'practice_session_controller.dart';

/// The exact inputs of one attempt to persist a finished session via
/// [FinishPracticeSessionUseCase] — captured so a failed local write can
/// be resubmitted byte-for-byte via [PracticeSessionController.retryPersist]
/// without the user retyping anything.
typedef _PersistAttempt = ({
  TypingSessionId id,
  ProfileId profileId,
  PracticeMode mode,
  Snippet snippet,
  DateTime startedAtUtc,
  Duration duration,
  List<Keystroke> keystrokes,
});

/// The [PracticeSessionState] to move to after one persist attempt, plus
/// whether it succeeded — so the caller knows whether to clear its
/// pending-retry bookkeeping or keep it for another retry.
typedef _PersistOutcome = ({PracticeSessionState state, bool succeeded});

/// Calls [FinishPracticeSessionUseCase] with [attempt]'s exact inputs
/// (used both for the first try and for every retry resubmission) and
/// folds the result into the next state — success fires
/// `_notifyDownstreamFeatures` fire-and-forget exactly like the first
/// attempt would have.
///
/// A top-level function taking `ref` explicitly, not a method, for the
/// same reason as `_notifyDownstreamFeatures`: `ref` is only accessible
/// from within the controller's own class body, not from another part
/// file.
Future<_PersistOutcome> _resolvePersistAttempt(
  Ref ref,
  _PersistAttempt attempt, {
  required KeystrokeStreamRecorder recorder,
  required Snippet displaySnippet,
  required Duration? remaining,
  required SurvivalRunTracker? survival,
}) async {
  final result = await ref.read(finishPracticeSessionUseCaseProvider)(
    id: attempt.id,
    profileId: attempt.profileId,
    mode: attempt.mode,
    snippet: attempt.snippet,
    startedAtUtc: attempt.startedAtUtc,
    duration: attempt.duration,
    keystrokes: attempt.keystrokes,
  );

  if (result.isOk) {
    _notifyDownstreamFeatures(
      ref,
      profileId: attempt.profileId,
      finished: result.valueOrNull!,
    );
  }

  final state = result.fold(
    (finished) => PracticeSessionState(
      status: PracticeSessionStatus.result,
      recorder: recorder,
      snippet: displaySnippet,
      remaining: remaining,
      finishedSession: finished,
      survival: survival,
    ),
    (failure) => PracticeSessionState(
      status: PracticeSessionStatus.result,
      recorder: recorder,
      snippet: displaySnippet,
      remaining: remaining,
      survival: survival,
      error: failure.message,
    ),
  );
  return (state: state, succeeded: result.isOk);
}
