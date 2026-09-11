import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Checks whether a profile has already played the Daily Challenge for a
/// given [ChallengeDate] (SPEC.md §5.4) — the "already played today"
/// gate the entry-point card uses to disable itself.
class GetDailyChallengeStatusUseCase {
  /// Creates the use case over the given [DailyChallengeRepository] port.
  const new(this._repository);

  final DailyChallengeRepository _repository;

  /// Returns [profileId]'s completion record for [date], or `null` if
  /// it hasn't been played yet.
  Future<Result<DailyChallengeCompletion?, AppFailure>> call({
    required ProfileId profileId,
    required ChallengeDate date,
  }) {
    return _repository.getCompletion(profileId: profileId, date: date);
  }
}
