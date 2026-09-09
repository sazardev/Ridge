import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_progress.dart';
import 'package:just_in_time/features/learning_paths/domain/repositories/learning_path_repository.dart';
import 'package:just_in_time/features/learning_paths/domain/repositories/lesson_progress_repository.dart';
import 'package:just_in_time/features/learning_paths/domain/services/lesson_progress_calculator.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Recomputes and persists every lesson's [LessonProgress] for one
/// profile, across every bundled learning path (SPEC.md §5.7) —
/// idempotent, safe to call any number of times (mirrors `progression`'s
/// `RecomputeProgressSnapshotUseCase` idempotency style, though this one
/// fully replaces the cache each run rather than incrementally
/// backfilling, since deriving every lesson's status from scratch is
/// cheap at this scale — see `LessonProgressRepository.replaceProgress`).
/// Fired right after every finished `practice` session tagged with a
/// lesson id.
class RecomputeLessonProgressUseCase {
  /// Creates the use case over the given ports and an optional injected
  /// (pure, stateless) calculator.
  const new(
    this._pathRepository,
    this._progressRepository, {
    this.calculator = const LessonProgressCalculator(),
  });

  final LearningPathRepository _pathRepository;
  final LessonProgressRepository _progressRepository;

  /// The (pure, stateless) calculator used to derive each lesson's
  /// status.
  final LessonProgressCalculator calculator;

  /// Runs the full recompute for [profileId].
  Future<Result<List<LessonProgress>, AppFailure>> call(
    ProfileId profileId,
  ) async {
    final paths = await _pathRepository.watchPaths().first;

    final attemptsResult = await _progressRepository.getLessonAttempts(
      profileId,
    );
    if (attemptsResult.isErr) {
      return Result.err(attemptsResult.failureOrNull!);
    }
    final attempts = attemptsResult.valueOrNull!;

    final records = <LessonProgress>[];
    for (final path in paths) {
      final statusByLesson = calculator.compute(
        orderedLessons: path.lessons,
        attempts: attempts,
      );
      for (final lesson in path.lessons) {
        final derived = statusByLesson[lesson.id]!;
        records.add(
          LessonProgress(
            pathId: path.id,
            lessonId: lesson.id,
            status: derived.status,
            bestAccuracyPct: derived.bestAccuracyPct,
            completedAt: derived.completedAt,
          ),
        );
      }
    }

    final persistResult = await _progressRepository.replaceProgress(
      profileId: profileId,
      records: records,
    );
    if (persistResult.isErr) return Result.err(persistResult.failureOrNull!);

    return Result.ok(records);
  }
}
