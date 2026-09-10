import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';

/// Resolves a lesson's [LessonStatus] from the *cached* progress map the
/// presentation layer already has in hand — a thin, UI-facing
/// counterpart to `LessonProgressCalculator` (which derives status from
/// scratch off raw attempts for the recompute pipeline). Pure and
/// side-effect-free, so every screen that renders a path's lessons
/// shares one identical notion of "what's next" rather than each
/// re-deriving the fallback-before-first-recompute case independently —
/// the Lessons list and the Practice-tab roadmap both call this instead
/// of guessing at their own logic.
abstract final class LessonStatusResolver {
  /// The status for [lesson] within its (already-ordered)
  /// [orderedLessons], from the cached [progress] map — or, before a
  /// brand-new profile's very first recompute has landed, the same
  /// default a zero-attempt recompute would itself produce (only the
  /// first lesson is reachable).
  static LessonStatus resolve(
    Lesson lesson,
    List<Lesson> orderedLessons,
    Map<LessonId, LessonStatus> progress,
  ) {
    final cached = progress[lesson.id];
    if (cached != null) return cached;
    return lesson.order == orderedLessons.first.order
        ? LessonStatus.unlocked
        : LessonStatus.locked;
  }

  /// The index within [orderedLessons] of the next lesson to work on —
  /// the first one whose resolved status isn't [LessonStatus.completed]
  /// — or `null` if every lesson in the path is already completed.
  static int? findNextIndex(
    List<Lesson> orderedLessons,
    Map<LessonId, LessonStatus> progress,
  ) {
    for (var i = 0; i < orderedLessons.length; i++) {
      if (resolve(orderedLessons[i], orderedLessons, progress) !=
          LessonStatus.completed) {
        return i;
      }
    }
    return null;
  }
}
