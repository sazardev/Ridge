import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';

part 'lesson_progress.freezed.dart';

/// One lesson's fully-recomputed, cached progress record (SPEC.md §5.7)
/// — rebuildable at any time from `practice`'s `typing_sessions` (see
/// `lesson_progress_cache`'s class doc), never itself authoritative.
@freezed
abstract class LessonProgress with _$LessonProgress {
  /// Creates an immutable lesson-progress record.
  const factory({
    required LearningPathId pathId,
    required LessonId lessonId,
    required LessonStatus status,
    // `null` until at least one attempt has ever been made at this
    // lesson.
    double? bestAccuracyPct,
    // `null` until [status] first reaches `LessonStatus.completed`.
    DateTime? completedAt,
  }) = _LessonProgress;
}
