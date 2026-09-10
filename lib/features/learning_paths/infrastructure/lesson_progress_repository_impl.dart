import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_attempt.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_progress.dart';
import 'package:ridge/features/learning_paths/domain/repositories/lesson_progress_repository.dart';
import 'package:ridge/features/learning_paths/infrastructure/lesson_progress_dao.dart';
import 'package:ridge/features/learning_paths/infrastructure/lesson_progress_mapper.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Drift-backed adapter for [LessonProgressRepository], over
/// [LessonProgressDao] (which owns every query — see its class doc for
/// why this reaches into `practice`'s own tables directly).
class LessonProgressRepositoryImpl implements LessonProgressRepository {
  /// Creates the adapter over the given [LessonProgressDao].
  const new(this._dao);

  final LessonProgressDao _dao;

  @override
  Stream<List<LessonProgress>> watchProgress(ProfileId profileId) {
    return _dao
        .watchProgressCache(profileId.value)
        .map((rows) => [for (final row in rows) row.toDomain()]);
  }

  @override
  Future<Result<List<LessonAttempt>, AppFailure>> getLessonAttempts(
    ProfileId profileId,
  ) async {
    try {
      final rows = await _dao.getLessonSessions(profileId.value);
      return Result.ok([for (final row in rows) row.toLessonAttempt()]);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not load lesson attempts', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> replaceProgress({
    required ProfileId profileId,
    required List<LessonProgress> records,
  }) async {
    try {
      await _dao.replaceProgressForProfile(
        profileId: profileId.value,
        rows: [for (final record in records) record.toCompanion(profileId)],
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not persist lesson progress', cause: e),
      );
    }
  }
}
