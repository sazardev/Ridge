part of 'practice_session_controller.dart';

/// Elapsed running time [controller] has accumulated, excluding every
/// backgrounded interval — frozen at the instant backgrounding began if
/// currently backgrounded, so a countdown (or the final persisted
/// duration) never advances while the app isn't on screen. A top-level
/// function so the controller file stays within the project's 500-line
/// limit; the fields it reads are private but plain (unlike `state`,
/// which is `@protected` and off-limits from here).
Duration _elapsedSoFar(PracticeSessionController controller) {
  final runningSince = controller._runningSince;
  if (runningSince == null) return Duration.zero;
  final referenceNow = controller._backgroundedAt ?? DateTime.now();
  final elapsed =
      referenceNow.difference(runningSince) - controller._totalPaused;
  return elapsed.isNegative ? Duration.zero : elapsed;
}

/// How long a just-completed session waits for the key that completed it
/// — and any key still held at that instant — to deliver its keyup, so
/// the dwell it carries isn't lost before the keystroke log is
/// snapshotted. `KeystrokeCaptureField` resolves this early the instant
/// every key it saw pressed has come back up; the timeout only covers a
/// keyup that never arrives (focus lost with a key still down).
const _dwellSettleTimeout = Duration(milliseconds: 250);

/// Owns the bounded [wait] for keyups still owed to already-classified
/// keystrokes, plus the early [conclude] signal the capture field sends
/// once nothing is held anymore. A small standalone class (not methods on
/// the controller) so the controller file stays within the project's
/// 500-line limit.
class _DwellSettle {
  /// Creates an idle settle (nothing in flight until [wait] is called).
  new();

  Completer<void>? _completer;

  /// Resolves as soon as [conclude] is called, or after
  /// [_dwellSettleTimeout] if it never is — whichever comes first.
  Future<void> wait() async {
    final settle = Completer<void>();
    _completer = settle;
    final timeout = Timer(_dwellSettleTimeout, () {
      if (!settle.isCompleted) settle.complete();
    });
    try {
      await settle.future;
    } finally {
      timeout.cancel();
      _completer = null;
    }
  }

  /// Ends an in-flight [wait] immediately. No-op when nothing is waiting.
  void conclude() {
    final settle = _completer;
    if (settle != null && !settle.isCompleted) settle.complete();
  }
}
