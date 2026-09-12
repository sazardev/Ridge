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

/// Persists [controller]'s finished session — the first persist attempt
/// of a run, shared by the natural finish and Sprint's deadline finish
/// (both in `PracticeSessionController._finishNow`). A top-level function
/// (not a method) so the controller class body stays within the project's
/// 500-line file limit, matching [_resolvePersistAttempt]; the caller
/// supplies the session-clock values it froze at the finish instant.
///
/// Returns the state the controller should move to when there is no guest
/// profile to persist against, or `null` once the attempt ran (it folds
/// its own outcome into the controller's state via `_attemptPersist` —
/// the `state` setter is `@protected` to subclasses, so this helper can't
/// assign it itself).
Future<PracticeSessionState?> _persistFinishedSession(
  Ref ref,
  PracticeSessionController controller, {
  required KeystrokeStreamRecorder recorder,
  required Snippet displaySnippet,
  required Duration? remaining,
  required DateTime startedAtUtc,
  required Duration duration,
  required List<Keystroke> keystrokes,
}) async {
  final profileId = ref.read(activeProfileControllerProvider).value?.id;
  if (profileId == null) {
    return PracticeSessionState(
      status: PracticeSessionStatus.result,
      recorder: recorder,
      snippet: displaySnippet,
      remaining: remaining,
      survival: controller._survival,
      error: 'No guest profile found',
    );
  }

  await controller._attemptPersist((
    id: TypingSessionId.generate(),
    profileId: profileId,
    mode: controller.mode,
    // The *starting* snippet, always — a multi-snippet Sprint run still
    // denormalizes onto it (see the project plan's design decision);
    // `displaySnippet` may have already advanced past it.
    snippet: controller.snippet,
    startedAtUtc: startedAtUtc,
    duration: duration,
    keystrokes: keystrokes,
  ));
  return null;
}

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
