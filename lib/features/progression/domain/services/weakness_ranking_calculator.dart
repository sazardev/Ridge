import 'dart:math' as math;

import 'package:ridge/features/progression/domain/entities/trend.dart';

/// One raw observation feeding a weakness ranking for a single key
/// (character, finger, or n-gram text) — already reduced to exactly what
/// the ranking math needs.
class WeaknessSample {
  /// Creates an immutable sample.
  const new({
    required this.ageInDays,
    required this.isError,
    required this.flightMs,
  });

  /// How many days before "now" this observation happened. Not a
  /// monotonic measurement — this is wall-clock "how long ago", computed
  /// by the caller from persisted session timestamps (SPEC.md's
  /// reporting-only exception to the monotonic-clock rule).
  final double ageInDays;

  /// Whether this observation was an error.
  final bool isError;

  /// How long (in ms) this observation took.
  final double flightMs;
}

/// One ranked entry for a key of type [K] (a `String` character/n-gram,
/// or a `Finger`).
class WeaknessRankEntry<K> {
  /// Creates an immutable ranked entry.
  const new({required this.key, required this.score, required this.trend});

  /// The character, n-gram text, or `Finger` this entry ranks.
  final K key;

  /// Higher means worse — see [WeaknessRankingCalculator]'s class doc for
  /// the formula.
  final double score;

  /// How this key's score has moved between the two most recent 14-day
  /// windows.
  final Trend trend;
}

/// Pure, stateless weakness-ranking math (SPEC.md §4.2/§4.3): for each
/// key (character, finger, or n-gram), a recency-weighted blend of error
/// rate and relative slowness, so a `progression`-phase DAO's raw,
/// window-bounded keystroke samples become three separately ranked
/// "what's holding you back" lists.
///
/// `score = 0.6 * recencyWeightedErrorRate + 0.4 * normalizedSlowness`,
/// where recency itself is folded into the weighted error rate/average
/// flight time (not applied as a separate final multiplier) — an
/// observation from today counts fully, one 14 days old counts at half
/// weight (`0.5 ^ (ageInDays / 14)`), and so on. `normalizedSlowness` is
/// each key's recency-weighted average flight time relative to the
/// *overall* recency-weighted average across every key in the same
/// batch, clamped to `[0, 1]` (average speed -> 0.5; twice the average or
/// slower -> 1.0) — there's no absolute "correct" typing speed to
/// normalize against, only "slower than your own average right now".
///
/// No clock, no I/O — every sample's age is precomputed by the caller,
/// which is what makes this unit-testable with fully fabricated data.
class WeaknessRankingCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// The recency weight's half-life, in days.
  static const halfLifeDays = 14.0;

  /// Weight given to (recency-weighted) error rate in the score.
  static const errorRateWeight = 0.6;

  /// Weight given to normalized slowness in the score.
  static const slownessWeight = 0.4;

  /// How large a relative change in score must be, between two adjacent
  /// windows, to count as a genuine [Trend.improving]/[Trend.worsening]
  /// rather than [Trend.stable].
  static const _stableBandFraction = 0.1;

  /// How many days a "window" (for both the overall score and the
  /// trend's two adjacent comparison windows) spans.
  static const windowDays = 14.0;

  /// Ranks every key in [samplesByKey] worst-first, capped to [topN].
  List<WeaknessRankEntry<K>> rank<K>(
    Map<K, List<WeaknessSample>> samplesByKey, {
    int topN = 10,
  }) {
    final allSamples = [for (final list in samplesByKey.values) ...list];
    final globalAvgFlight = _weightedAvgFlight(allSamples);
    final entries = [
      for (final entry in samplesByKey.entries)
        WeaknessRankEntry<K>(
          key: entry.key,
          score: _scoreFor(entry.value, globalAvgFlight),
          trend: _trendFor(entry.value),
        ),
    ]..sort((a, b) => b.score.compareTo(a.score));
    return entries.take(topN).toList();
  }

  double _recencyWeight(double ageInDays) {
    return math.pow(0.5, ageInDays / halfLifeDays).toDouble();
  }

  double _weightedAvgFlight(List<WeaknessSample> samples) {
    var weightSum = 0.0;
    var flightWeightSum = 0.0;
    for (final sample in samples) {
      final weight = _recencyWeight(sample.ageInDays);
      weightSum += weight;
      flightWeightSum += weight * sample.flightMs;
    }
    return weightSum <= 0 ? 0 : flightWeightSum / weightSum;
  }

  double _scoreFor(List<WeaknessSample> samples, double globalAvgFlight) {
    if (samples.isEmpty) return 0;
    var weightSum = 0.0;
    var errorWeightSum = 0.0;
    for (final sample in samples) {
      final weight = _recencyWeight(sample.ageInDays);
      weightSum += weight;
      if (sample.isError) errorWeightSum += weight;
    }
    if (weightSum <= 0) return 0;
    final errorRate = errorWeightSum / weightSum;
    final avgFlight = _weightedAvgFlight(samples);
    final normalizedSlowness = globalAvgFlight <= 0
        ? 0.0
        : (avgFlight / (2 * globalAvgFlight)).clamp(0.0, 1.0);
    return errorRateWeight * errorRate + slownessWeight * normalizedSlowness;
  }

  Trend _trendFor(List<WeaknessSample> samples) {
    final recent = [
      for (final sample in samples)
        if (sample.ageInDays < windowDays) sample,
    ];
    final previous = [
      for (final sample in samples)
        if (sample.ageInDays >= windowDays && sample.ageInDays < 2 * windowDays)
          sample,
    ];
    if (recent.isEmpty || previous.isEmpty) return Trend.stable;

    final recentScore = _scoreFor(recent, _weightedAvgFlight(recent));
    final previousScore = _scoreFor(previous, _weightedAvgFlight(previous));
    if (previousScore <= 0) {
      return recentScore <= 0 ? Trend.stable : Trend.worsening;
    }
    final relativeChange = (recentScore - previousScore) / previousScore;
    if (relativeChange > _stableBandFraction) return Trend.worsening;
    if (relativeChange < -_stableBandFraction) return Trend.improving;
    return Trend.stable;
  }
}
