/// Aggregated lesson progress for one programming language across every
/// bundled Learning Path that teaches it (SPEC.md §5.7) — the "how far am
/// I into this language" number the language catalog shows before the
/// user commits to it as their active language.
class LanguageProgress {
  /// Creates a progress summary from completed/total lesson counts.
  const new({required this.totalLessons, required this.completedLessons});

  /// Every lesson across every path of the language.
  final int totalLessons;

  /// How many of [totalLessons] are already completed.
  final int completedLessons;

  /// Completed fraction in `[0, 1]` — `0` when the language has no
  /// lessons at all, so callers can feed this straight into a progress
  /// indicator without a divide-by-zero guard.
  double get fraction =>
      totalLessons == 0 ? 0 : completedLessons / totalLessons;

  /// Whether the user has completed at least one lesson.
  bool get hasStarted => completedLessons > 0;

  /// Whether there is at least one lesson and every one is completed.
  bool get isComplete => totalLessons > 0 && completedLessons == totalLessons;
}
