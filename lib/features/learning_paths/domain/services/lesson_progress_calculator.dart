import 'package:just_in_time/features/learning_paths/domain/entities/lesson.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_attempt.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';

/// One lesson's derived [LessonStatus] plus the summary stats
/// `RecomputeLessonProgressUseCase` caches alongside it.
typedef LessonStatusResult = ({
  LessonStatus status,
  double? bestAccuracyPct,
  DateTime? completedAt,
});

/// Pure derivation of every lesson's [LessonStatus] within one
/// `LearningPath` (SPEC.md §5.7) — no drift/clock/Flutter dependency, so
/// it's directly unit-testable with hand-fabricated attempts.
///
/// Rule (see the project plan): the first lesson in a path is always
/// unlocked (or completed, if already passed); each subsequent lesson is
/// unlocked iff the previous lesson is completed; a lesson is completed
/// iff at least one attempt against it passed.
class LessonProgressCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// Computes every lesson's [LessonStatusResult] in [orderedLessons]
  /// (already ordered by `Lesson.order`), given every attempt ever made
  /// against any lesson (not necessarily only this path's — entries for
  /// other lessons are simply ignored).
  Map<LessonId, LessonStatusResult> compute({
    required List<Lesson> orderedLessons,
    required List<LessonAttempt> attempts,
  }) {
    final attemptsByLesson = <LessonId, List<LessonAttempt>>{};
    for (final attempt in attempts) {
      attemptsByLesson.putIfAbsent(attempt.lessonId, () => []).add(attempt);
    }

    final result = <LessonId, LessonStatusResult>{};
    // The first lesson in a path is always reachable, regardless of any
    // "previous" lesson (there isn't one) — starting this `true` gives
    // exactly that behavior on the loop's first iteration.
    var previousCompleted = true;
    for (final lesson in orderedLessons) {
      final lessonAttempts = attemptsByLesson[lesson.id] ?? const [];
      final passedAttempts = [
        for (final attempt in lessonAttempts)
          if (attempt.passed) attempt,
      ];
      final isCompleted = passedAttempts.isNotEmpty;

      final status = isCompleted
          ? LessonStatus.completed
          : previousCompleted
          ? LessonStatus.unlocked
          : LessonStatus.locked;

      final bestAccuracyPct = lessonAttempts.isEmpty
          ? null
          : lessonAttempts
                .map((attempt) => attempt.accuracyPct)
                .reduce((a, b) => a > b ? a : b);

      final completedAt = passedAttempts.isEmpty
          ? null
          : passedAttempts
                .map((attempt) => attempt.startedAtUtc)
                .reduce((a, b) => a.isBefore(b) ? a : b);

      result[lesson.id] = (
        status: status,
        bestAccuracyPct: bestAccuracyPct,
        completedAt: completedAt,
      );
      previousCompleted = isCompleted;
    }
    return result;
  }
}
