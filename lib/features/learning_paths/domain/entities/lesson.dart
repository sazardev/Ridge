import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';

part 'lesson.freezed.dart';

/// One ordered step within a `LearningPath` (SPEC.md §5.7) — curated
/// content, never user-authored: [order] is this lesson's fixed position
/// among its path's other lessons, as chosen by whoever authored the
/// bundled curriculum JSON.
@freezed
abstract class Lesson with _$Lesson {
  /// Creates an immutable curriculum lesson.
  const factory({
    required LessonId id,
    required SnippetId snippetId,
    required String titleEn,
    required String titleEs,
    required int order,
  }) = _Lesson;
}
