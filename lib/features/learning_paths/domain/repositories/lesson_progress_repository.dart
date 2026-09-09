import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_attempt.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_progress.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter — a `learning_paths`-owned DAO
/// issuing its own queries directly against `practice`'s
/// `typing_sessions` table (an allowed infrastructure-to-infrastructure
/// import — the same pattern `progression`'s `ProgressionRepository`
/// already establishes) plus `learning_paths`' own
/// `lesson_progress_cache` table.
abstract interface class LessonProgressRepository {
  /// Emits every cached [LessonProgress] record for [profileId], and
  /// every subsequent change.
  Stream<List<LessonProgress>> watchProgress(ProfileId profileId);

  /// Every one of [profileId]'s attempts against any `learning_paths`
  /// lesson — passed or not — the raw input `LessonProgressCalculator`
  /// needs to derive each lesson's status.
  Future<Result<List<LessonAttempt>, AppFailure>> getLessonAttempts(
    ProfileId profileId,
  );

  /// Idempotently replaces every cached record for [profileId] with
  /// [records] — the full, freshly recomputed picture, safe to call any
  /// number of times.
  Future<Result<void, AppFailure>> replaceProgress({
    required ProfileId profileId,
    required List<LessonProgress> records,
  });
}
