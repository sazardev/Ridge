import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_history_comparison.freezed.dart';

/// SPEC.md §7.1/§11.4's guest-only "local leaderboard": a rolling
/// comparison of the user's own last-N sessions of the same snippet or
/// category — a read view over already-persisted sessions, never a
/// separate aggregate computed a different way.
///
/// [recentNetSpeedCpm]/[recentAccuracyPct] carry the individual samples
/// (oldest first) alongside their own averages, so a presentation-layer
/// sparkline has real per-session values to plot, not just the mean.
@freezed
abstract class PersonalHistoryComparison with _$PersonalHistoryComparison {
  /// Creates an immutable personal-history comparison snapshot.
  const factory({
    required int sampleSize,
    required double averageNetSpeedCpm,
    required double averageAccuracyPct,
    required List<double> recentNetSpeedCpm,
    required List<double> recentAccuracyPct,
  }) = _PersonalHistoryComparison;

  /// No qualifying session history yet.
  static const empty = PersonalHistoryComparison(
    sampleSize: 0,
    averageNetSpeedCpm: 0,
    averageAccuracyPct: 0,
    recentNetSpeedCpm: [],
    recentAccuracyPct: [],
  );
}
