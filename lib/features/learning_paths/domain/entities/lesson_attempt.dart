import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';

part 'lesson_attempt.freezed.dart';

/// One raw `typing_sessions` row tagged with a `learning_paths` lesson
/// id — the read view `LessonProgressCalculator` needs, stripped of
/// every column it doesn't care about (mirrors `progression`'s
/// `PrecisionResult`/`UnprocessedSession`).
@freezed
abstract class LessonAttempt with _$LessonAttempt {
  /// Creates an immutable lesson-attempt read view.
  const factory({
    required LessonId lessonId,
    required bool passed,
    required double accuracyPct,
    required DateTime startedAtUtc,
  }) = _LessonAttempt;
}
