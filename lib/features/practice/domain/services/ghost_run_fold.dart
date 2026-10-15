import 'package:ridge/features/practice/domain/entities/ghost_run.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';

/// Folds one session's [keystrokes] (in `seq` order) into the committed
/// character timeline a ghost replays — the exact inverse of how a live
/// session accumulates one:
///
/// - `flight` is the gap since the previous keydown, so accumulating it
///   yields each keystroke's offset from the session start (the first
///   one is anchored at zero, exactly how `PracticeSessionController`
///   clocks a live session).
/// - Only a committed (`correct`, non-correction) keystroke advances the
///   position. A rejected substitution consumed time but never moved the
///   cursor (the capture field is hard-locked), and a correction steps
///   the position back — so a retyped character correctly appears once
///   more in the timeline.
///
/// Returns an empty list for a session that committed no characters.
List<GhostStep> foldGhostSteps(List<Keystroke> keystrokes) {
  final steps = <GhostStep>[];
  var position = 0;
  var elapsed = Duration.zero;

  for (final keystroke in keystrokes) {
    final flight = keystroke.flight;
    if (flight != null) elapsed += flight;

    if (keystroke.isCorrection) {
      if (position > 0) position -= 1;
      continue;
    }
    if (keystroke.result != KeystrokeResult.correct) continue;

    steps.add((position: position, at: elapsed));
    position += 1;
  }
  return steps;
}
