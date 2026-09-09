import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/profile/application/usecases/create_guest_profile_usecase.dart';
import 'package:just_in_time/features/profile/domain/repositories/profile_repository.dart';

/// Renames the on-device Guest Profile, applying the same validation as
/// [CreateGuestProfileUseCase].
class RenameProfileUseCase {
  /// Creates the use case over the given [ProfileRepository] port.
  const new(this._repository);

  final ProfileRepository _repository;

  /// Validates and persists [newUsername] as the Guest Profile's new name.
  Future<Result<void, AppFailure>> call(String newUsername) {
    final trimmed = newUsername.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        const Result.err(ValidationFailure('Username cannot be empty')),
      );
    }
    if (trimmed.length > CreateGuestProfileUseCase.maxUsernameLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Username must be '
            '${CreateGuestProfileUseCase.maxUsernameLength} characters or '
            'fewer',
          ),
        ),
      );
    }
    return _repository.renameProfile(trimmed);
  }
}
