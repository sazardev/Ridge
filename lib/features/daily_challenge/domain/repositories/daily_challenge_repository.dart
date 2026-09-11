import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Driven port: the application core depends on this abstraction only.
/// Today's only adapter is local (drift); a future online phase can add
/// a remote data source behind the same port (STACK.md §4.2's dual
/// adapter pattern) without changing any caller of this interface.
abstract interface class DailyChallengeRepository {
  /// Returns [profileId]'s completion record for [date], or `null` if
  /// that day's Daily Challenge hasn't been played yet.
  Future<Result<DailyChallengeCompletion?, AppFailure>> getCompletion({
    required ProfileId profileId,
    required ChallengeDate date,
  });

  /// Idempotently records [completion] — a no-op if that (profile, date)
  /// pair is already recorded, since only one attempt counts per day.
  Future<Result<void, AppFailure>> recordCompletion(
    DailyChallengeCompletion completion,
  );

  /// Emits every distinct [ChallengeDate] [profileId] has completed, and
  /// every subsequent change — the input to
  /// `DailyChallengeStreakCalculator`.
  Stream<List<ChallengeDate>> watchCompletedDates(ProfileId profileId);

  /// Returns [profileId]'s most recent completions, newest first, capped
  /// at [limit].
  Future<Result<List<DailyChallengeCompletion>, AppFailure>>
  getRecentCompletions({required ProfileId profileId, required int limit});
}
