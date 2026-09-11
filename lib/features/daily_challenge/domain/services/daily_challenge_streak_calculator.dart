import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

/// Pure, stateless consecutive-days streak calculation for the Daily
/// Challenge specifically (SPEC.md §5.4/§12) — deliberately separate
/// from `progression`'s `StreakCalculator`, which counts *any* finished
/// session on a *local* calendar day. This one counts only days the
/// shared Daily Challenge was completed, keyed on the same UTC
/// [ChallengeDate] the challenge itself is selected by.
///
/// `today` is an explicit parameter (never read from the system clock
/// internally) so this stays deterministic and unit-testable.
class DailyChallengeStreakCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// Computes the streak length ending on (or, if today's challenge
  /// hasn't been played yet, ending yesterday) given [completedDates] —
  /// the distinct [ChallengeDate]s a Daily Challenge was completed on, in
  /// any order.
  int compute(List<ChallengeDate> completedDates, ChallengeDate today) {
    if (completedDates.isEmpty) return 0;
    final dateKeys = {for (final date in completedDates) date.isoKey};

    var cursor = today;
    if (!dateKeys.contains(cursor.isoKey)) {
      cursor = cursor.yesterday;
      if (!dateKeys.contains(cursor.isoKey)) {
        // Neither today nor yesterday was played — the streak is dead,
        // not just paused.
        return 0;
      }
    }

    var streak = 0;
    while (dateKeys.contains(cursor.isoKey)) {
      streak += 1;
      cursor = cursor.yesterday;
    }
    return streak;
  }
}
