import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';

/// One committed character in a ghost timeline: `position` is the index
/// in the snippet's code, `at` how long after the ghost session's first
/// keystroke it was typed.
typedef GhostStep = ({int position, Duration at});

/// A past (best) attempt at a snippet, folded into the timeline a ghost
/// cursor replays — the live form of SPEC.md §4.3's personal-history
/// comparison. The metadata rides along so the UI can label the race
/// ("racing your best: 84 cpm").
typedef GhostRun = ({
  TypingSessionId sessionId,
  List<GhostStep> steps,
  double netSpeedCpm,
});
