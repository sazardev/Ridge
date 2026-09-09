import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:just_in_time/features/profile/domain/repositories/profile_repository.dart';

/// Streams the on-device Guest Profile and every subsequent update.
class WatchActiveProfileUseCase {
  /// Creates the use case over the given [ProfileRepository] port.
  const new(this._repository);

  final ProfileRepository _repository;

  /// Returns a stream that emits whenever the Guest Profile changes.
  Stream<GuestProfile?> call() => _repository.watchActiveProfile();
}
