import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/learning_paths/domain/entities/language_progress.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';

/// Pure aggregation of one language's lesson progress across every
/// bundled path that teaches it (SPEC.md §5.7) — no drift/clock/Flutter
/// dependency, so it's directly unit-testable with hand-fabricated paths
/// and progress maps.
class LanguageProgressCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// Computes [language]'s [LanguageProgress] from every bundled [paths]
  /// entry (entries for other languages are ignored) and the cached
  /// per-lesson [progress] statuses.
  LanguageProgress compute({
    required ProgrammingLanguage language,
    required List<LearningPath> paths,
    required Map<LessonId, LessonStatus> progress,
  }) {
    var totalLessons = 0;
    var completedLessons = 0;
    for (final path in paths) {
      if (path.language != language) continue;
      for (final lesson in path.lessons) {
        totalLessons++;
        if (progress[lesson.id] == LessonStatus.completed) completedLessons++;
      }
    }
    return LanguageProgress(
      totalLessons: totalLessons,
      completedLessons: completedLessons,
    );
  }
}
