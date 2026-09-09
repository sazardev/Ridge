import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/data_management/domain/repositories/data_reset_repository.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Deletes every attempt a [ProfileId] has ever made at any lesson,
/// across every learning path — resetting all of them back to
/// never-attempted.
class ResetAllLessonsUseCase {
  /// Creates the use case over the given [DataResetRepository] port.
  const new(this._repository);

  final DataResetRepository _repository;

  /// Runs the reset.
  Future<Result<void, AppFailure>> call(ProfileId profileId) =>
      _repository.resetAllLessons(profileId);
}
