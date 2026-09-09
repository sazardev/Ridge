import 'package:drift/drift.dart';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_attempt.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_progress.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Converts a raw [TypingSessionRow] tagged with a lesson id into a
/// [LessonAttempt] — drops every column `learning_paths` doesn't care
/// about.
extension TypingSessionRowLessonAttemptMapper on TypingSessionRow {
  /// Maps this row to a [LessonAttempt]. Only ever called for rows this
  /// DAO already filtered to `lessonId IS NOT NULL`, so the `!` is safe.
  LessonAttempt toLessonAttempt() {
    return LessonAttempt(
      lessonId: LessonId(lessonId!),
      passed: passed ?? false,
      accuracyPct: accuracyPct,
      startedAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        startedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a cached [LessonProgressCacheRow] into its domain
/// [LessonProgress].
extension LessonProgressCacheRowMapper on LessonProgressCacheRow {
  /// Maps this row to the domain [LessonProgress].
  LessonProgress toDomain() {
    return LessonProgress(
      pathId: LearningPathId(pathId),
      lessonId: LessonId(lessonId),
      status: LessonStatus.values.byName(status),
      bestAccuracyPct: bestAccuracyPct,
      completedAt: completedAtUtcMicros == null
          ? null
          : DateTime.fromMicrosecondsSinceEpoch(
              completedAtUtcMicros!,
              isUtc: true,
            ),
    );
  }
}

/// Converts a [LessonProgress] into its cache-table companion.
extension LessonProgressMapper on LessonProgress {
  /// Maps this entity to a row-insert companion for [profileId].
  LessonProgressCacheCompanion toCompanion(ProfileId profileId) {
    return LessonProgressCacheCompanion.insert(
      profileId: profileId.value,
      pathId: pathId.value,
      lessonId: lessonId.value,
      status: status.name,
      bestAccuracyPct: Value(bestAccuracyPct),
      completedAtUtcMicros: Value(completedAt?.toUtc().microsecondsSinceEpoch),
    );
  }
}
