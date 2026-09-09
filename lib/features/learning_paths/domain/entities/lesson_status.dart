/// Where one `Lesson` sits in its path's unlock gate (SPEC.md §5.7) —
/// always a **derived** value, never stored as raw truth: only cached in
/// `lesson_progress_cache`, fully rebuildable at any time from
/// `practice`'s `typing_sessions` (see `LessonProgressCalculator`).
enum LessonStatus {
  /// Not yet reachable: the previous lesson in the path hasn't been
  /// completed yet.
  locked,

  /// Reachable, but not yet passed.
  unlocked,

  /// At least one session tagged with this lesson's id has passed, per
  /// the Precision-test-style threshold SPEC.md §5.3/§5.7 call for.
  completed,
}
