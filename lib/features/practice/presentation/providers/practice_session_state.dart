part of 'practice_session_controller.dart';

/// Snapshot of one practice session's state-machine position, exposed by
/// `PracticeSessionController`. [recorder] is intentionally the same
/// mutable engine across every emission — what changes is [status] (and,
/// once finished, [finishedSession]); the recorder's own buffer/keystroke
/// log is read fresh off it whenever the UI rebuilds.
class PracticeSessionState {
  /// Creates a state snapshot.
  const new({
    required this.status,
    required this.recorder,
    required this.snippet,
    this.remaining,
    this.finishedSession,
    this.error,
  });

  /// Where this session currently sits in `idle -> running -> finished ->
  /// result`.
  final PracticeSessionStatus status;

  /// The live capture/classification engine for this session.
  final KeystrokeStreamRecorder recorder;

  /// The snippet currently being typed. Equal to the controller's
  /// starting snippet for every mode except Sprint, which swaps this
  /// mid-session as the countdown allows advancing through a
  /// same-difficulty queue (SPEC.md §5.2) — the persisted `TypingSession`
  /// still denormalizes onto the *starting* snippet regardless (see the
  /// project plan's single-row-per-Sprint-run design decision).
  final Snippet snippet;

  /// Time left in a Sprint countdown, or `null` for every other mode.
  /// Frozen (not updated) while the app is backgrounded, exactly like the
  /// elapsed-time clock used for the final persisted duration.
  final Duration? remaining;

  /// The persisted session + computed metrics, once [status] reaches
  /// [PracticeSessionStatus.result].
  final FinishedPracticeSession? finishedSession;

  /// A human-readable message if finishing failed, for the UI to show.
  final String? error;
}
