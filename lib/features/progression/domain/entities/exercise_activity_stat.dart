import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';

part 'exercise_activity_stat.freezed.dart';

/// One entry in a "most practiced"/"lowest scoring" exercise ranking —
/// the per-`SnippetId` counterpart to `CategoryActivityStat`. No
/// `trend`: an individual snippet's own sample size is usually too small
/// to split into two comparison windows meaningfully.
@freezed
abstract class ExerciseActivityStat with _$ExerciseActivityStat {
  /// Creates an immutable exercise-activity snapshot.
  const factory({
    required SnippetId snippetId,
    required int sessionCount,
    required Duration totalPracticeTime,
    required double avgAccuracyPct,
    required double avgNetSpeedCpm,
    required double performanceScore,
  }) = _ExerciseActivityStat;
}
