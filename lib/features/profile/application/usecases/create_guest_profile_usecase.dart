import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

/// Creates the on-device Guest Profile (SPEC.md §7.1), rejecting an empty
/// or overly long username before ever touching the repository.
class CreateGuestProfileUseCase {
  /// Creates the use case over the given [ProfileRepository] port.
  const new(this._repository);

  final ProfileRepository _repository;

  /// The longest username this app accepts.
  static const maxUsernameLength = 24;

  /// Validates and persists [username] as the new Guest Profile.
  Future<Result<GuestProfile, AppFailure>> call(String username) {
    final trimmed = username.trim();
    if (trimmed.isEmpty) {
      return Future.value(
        const Result.err(ValidationFailure('Username cannot be empty')),
      );
    }
    if (trimmed.length > maxUsernameLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Username must be $maxUsernameLength characters or fewer',
          ),
        ),
      );
    }
    return _repository.createGuestProfile(trimmed);
  }
}
