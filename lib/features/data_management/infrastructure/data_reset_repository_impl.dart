import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/data_management/domain/repositories/data_reset_repository.dart';
import 'package:ridge/features/data_management/infrastructure/data_reset_dao.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Drift-backed adapter for [DataResetRepository].
class DataResetRepositoryImpl implements DataResetRepository {
  /// Creates the adapter over the given [DataResetDao].
  new(this._dao);

  final DataResetDao _dao;

  @override
  Future<Result<void, AppFailure>> resetLesson({
    required ProfileId profileId,
    required LessonId lessonId,
  }) async {
    try {
      await _dao.deleteLessonSessions(
        profileId: profileId.value,
        lessonId: lessonId.value,
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not reset lesson', cause: e));
    }
  }

  @override
  Future<Result<void, AppFailure>> resetAllLessons(ProfileId profileId) async {
    try {
      await _dao.deleteAllLessonSessions(profileId.value);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not reset lessons', cause: e));
    }
  }

  @override
  Future<Result<void, AppFailure>> wipeAllData() async {
    try {
      await _dao.wipeEverything();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not erase local data', cause: e));
    }
  }
}
