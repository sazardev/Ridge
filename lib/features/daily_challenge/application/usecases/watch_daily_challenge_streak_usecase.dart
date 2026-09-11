import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/services/daily_challenge_streak_calculator.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Streams a profile's current Daily-Challenge-specific streak (SPEC.md
/// §5.4/§12) — recomputed live from the completion history on every
/// emission rather than cached, since that history is small and cheap to
/// recompute (unlike `progression`'s `ProgressSnapshotCache`).
class WatchDailyChallengeStreakUseCase {
  /// Creates the use case over the given [DailyChallengeRepository] port
  /// and an optional injected [calculator] (defaults to the real one).
  const new(
    this._repository, {
    this.calculator = const DailyChallengeStreakCalculator(),
  });

  final DailyChallengeRepository _repository;

  /// The (pure, stateless) calculator used to derive the streak length.
  final DailyChallengeStreakCalculator calculator;

  /// Emits the current streak length ending on [today], recomputed
  /// whenever [profileId]'s completion history changes.
  Stream<int> call({
    required ProfileId profileId,
    required ChallengeDate today,
  }) {
    return _repository
        .watchCompletedDates(profileId)
        .map((dates) => calculator.compute(dates, today));
  }
}
