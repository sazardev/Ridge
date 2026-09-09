import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_id.freezed.dart';

/// Type-safe identifier for a `Lesson`.
///
/// Like `SnippetId`/`LearningPathId`, never randomly generated: lesson
/// ids are stable, human-assigned strings chosen by whoever curates the
/// bundled curriculum JSON (SPEC.md §5.7) — this is also the value
/// persisted onto `typing_sessions.lesson_id` whenever a session's mode
/// is `learningRouteLesson`.
@freezed
abstract class LessonId with _$LessonId {
  /// Wraps the raw identifier [value].
  const factory(String value) = _LessonId;
}
