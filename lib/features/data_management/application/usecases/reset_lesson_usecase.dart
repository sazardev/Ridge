import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/data_management/domain/repositories/data_reset_repository.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Deletes every attempt a [ProfileId] has ever made at a [LessonId] —
/// resetting that one lesson back to never-attempted.
class ResetLessonUseCase {
  /// Creates the use case over the given [DataResetRepository] port.
  const new(this._repository);

  final DataResetRepository _repository;

  /// Runs the reset.
  Future<Result<void, AppFailure>> call({
    required ProfileId profileId,
    required LessonId lessonId,
  }) => _repository.resetLesson(profileId: profileId, lessonId: lessonId);
}
