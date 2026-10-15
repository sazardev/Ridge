import 'package:flutter/scheduler.dart';

import 'package:ridge/features/practice/domain/entities/ghost_run.dart';

/// Drives a ghost race's cursor for `KeystrokeCaptureField`: owns the
/// ghost's own clock (started with the session's first classified
/// keystroke, so the race is relative to typing time) and the ticker that
/// advances the committed count, invoking [onAdvance] only when the
/// cursor actually moves. Extracted from the field for the file-size
/// budget; the field supplies the `vsync` and repaints from [onAdvance].
class GhostCursorController {
  /// Creates the controller; [onAdvance] fires whenever [cursorIndex] or
  /// [committed] changed on a tick (and once when the ghost finishes).
  new({required TickerProvider vsync, required this.onAdvance}) {
    _ticker = vsync.createTicker(_onTick);
  }

  /// Called after every tick that moved the cursor.
  final VoidCallback onAdvance;

  late final Ticker _ticker;
  final _stopwatch = Stopwatch();

  /// The ghost run currently attached, if any — mirrored by the field on
  /// every build; `null` clears the race's data (the cursor resets on the
  /// next [reconcile]).
  GhostRun? ghost;

  bool _started = false;
  int _committed = 0;
  int _cursorIndex = 0;

  /// How many of the ghost's steps have been replayed so far.
  int get committed => _committed;

  /// The code index the ghost cursor marks — the next expected position
  /// (a correction in the ghost's own session can make it step back).
  int get cursorIndex => _cursorIndex;

  /// Starts the clock on the session's first classified keystroke — the
  /// same moment `PracticeSessionController` starts timing. A no-op until
  /// a ghost is attached.
  void start() {
    if (_started || ghost == null) return;
    _started = true;
    _stopwatch.start();
    _ticker.start();
  }

  /// Reconciles with the session's state: a retry (back to `idle`) resets
  /// everything for a fresh race, and a ghost that resolved only after
  /// typing had begun starts late rather than never.
  void reconcile({required bool sessionIdle, required bool sessionRunning}) {
    if (sessionIdle && _started) {
      _ticker.stop();
      _stopwatch
        ..stop()
        ..reset();
      _started = false;
      _committed = 0;
      _cursorIndex = 0;
    } else if (sessionRunning && !_started && ghost != null) {
      start();
    }
  }

  /// Disposes the ticker.
  void dispose() {
    _ticker.dispose();
  }

  void _onTick(Duration _) {
    final ghost = this.ghost;
    if (ghost == null) return;

    var committed = 0;
    for (final step in ghost.steps) {
      if (step.at > _stopwatch.elapsed) break;
      committed += 1;
    }
    final index = committed == 0 ? 0 : ghost.steps[committed - 1].position + 1;
    if (index != _cursorIndex || committed != _committed) {
      _committed = committed;
      _cursorIndex = index;
      onAdvance();
    }
    if (committed >= ghost.steps.length) _ticker.stop();
  }
}
