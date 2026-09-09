/// Consecutive-day streak achievement tiers (SPEC.md §12), read directly
/// from `progression`'s already-computed current streak (`progress_
/// snapshot_cache`) — never a reimplementation of `StreakCalculator`.
enum StreakTier {
  /// 3 consecutive local-calendar days.
  threeDays(3),

  /// 7 consecutive local-calendar days.
  sevenDays(7),

  /// 30 consecutive local-calendar days.
  thirtyDays(30),

  /// 100 consecutive local-calendar days.
  hundredDays(100);

  new(this.requiredConsecutiveDays);

  /// How many consecutive local-calendar days this tier requires.
  final int requiredConsecutiveDays;
}
