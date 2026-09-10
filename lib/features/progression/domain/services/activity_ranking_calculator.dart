import 'dart:math' as math;

import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/progression/domain/entities/activity_report.dart';
import 'package:just_in_time/features/progression/domain/entities/category_activity_stat.dart';
import 'package:just_in_time/features/progression/domain/entities/exercise_activity_stat.dart';
import 'package:just_in_time/features/progression/domain/entities/session_activity_sample.dart';
import 'package:just_in_time/features/progression/domain/entities/trend.dart';

/// Pure, stateless activity-ranking math: "dónde practicas más" and
/// "dónde tienes el puntaje más bajo", per category and per exercise.
///
/// "Most practiced" is computed over a profile's *entire* history — it's
/// a lifetime count, the same philosophy as the profile's own lifetime
/// character total. "Lowest scoring" is computed only over [recencyWindow]
/// (default 60 days, matching `WeaknessRankingCalculator`'s own recency
/// framing) so it reflects *current* skill, not diluted-by-history
/// performance, and requires at least [minSampleSizeForLowestScoring]
/// sessions in that window so a single bad run can't tank a ranking.
///
/// `performanceScore = 0.6 * avgAccuracyPct + 0.4 * normalizedSpeedPct`,
/// where `normalizedSpeedPct` is that key's average net speed relative to
/// the *overall* average net speed across every key in the same pass
/// (clamped to `[0, 100]`; matching your own average speed scores 50) —
/// there's no absolute "correct" typing speed, only "faster/slower than
/// your own average right now", the same relative framing
/// `WeaknessRankingCalculator` uses for slowness. Unlike a weakness
/// score, higher [CategoryActivityStat.performanceScore]/
/// [ExerciseActivityStat.performanceScore] is better, so it reads
/// literally as "puntaje".
///
/// No clock, no I/O — every sample's timestamp is supplied by the
/// caller and every window boundary is computed from the injected `now`,
/// which is what makes this unit-testable with fully fabricated data.
class ActivityRankingCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// How many entries each of the four ranked lists is capped to.
  static const topN = 5;

  /// How far back "lowest scoring" looks.
  static const recencyWindow = Duration(days: 60);

  /// Minimum sessions within [recencyWindow] a category/exercise needs
  /// before it's eligible for a "lowest scoring" list.
  static const minSampleSizeForLowestScoring = 3;

  /// Weight given to average accuracy in [_performanceScore].
  static const accuracyWeight = 0.6;

  /// Weight given to normalized speed in [_performanceScore].
  static const speedWeight = 0.4;

  /// Each trend comparison window's span, in days (half of
  /// [recencyWindow]).
  static const _trendWindowDays = 30.0;

  /// How large a relative change in score must be, between the two
  /// trend windows, to count as genuine movement rather than
  /// [Trend.stable].
  static const _stableBandFraction = 0.1;

  /// Builds the full [ActivityReport] from [samples] — every one of a
  /// profile's finished sessions, oldest or newest first, order doesn't
  /// matter.
  ActivityReport calculate(
    List<SessionActivitySample> samples, {
    required DateTime now,
  }) {
    final recent = [
      for (final s in samples)
        if (now.difference(s.occurredAtUtc) <= recencyWindow) s,
    ];

    final lifetimeCategoryStats = _categoryStats(samples, now);
    final recentCategoryStats = _categoryStats(recent, now);
    final lifetimeExerciseStats = _exerciseStats(samples);
    final recentExerciseStats = _exerciseStats(recent);

    final mostPracticedCategories = [...lifetimeCategoryStats]
      ..sort(_byCountThenTimeDesc);
    final lowestScoringCategories = [
      for (final c in recentCategoryStats)
        if (c.sessionCount >= minSampleSizeForLowestScoring) c,
    ]..sort((a, b) => a.performanceScore.compareTo(b.performanceScore));

    final mostPracticedExercises = [...lifetimeExerciseStats]
      ..sort(_byCountThenTimeDescExercise);
    final lowestScoringExercises = [
      for (final e in recentExerciseStats)
        if (e.sessionCount >= minSampleSizeForLowestScoring) e,
    ]..sort((a, b) => a.performanceScore.compareTo(b.performanceScore));

    return ActivityReport(
      mostPracticedCategories: mostPracticedCategories.take(topN).toList(),
      lowestScoringCategories: lowestScoringCategories.take(topN).toList(),
      mostPracticedExercises: mostPracticedExercises.take(topN).toList(),
      lowestScoringExercises: lowestScoringExercises.take(topN).toList(),
    );
  }

  int _byCountThenTimeDesc(CategoryActivityStat a, CategoryActivityStat b) {
    final byCount = b.sessionCount.compareTo(a.sessionCount);
    if (byCount != 0) return byCount;
    return b.totalPracticeTime.compareTo(a.totalPracticeTime);
  }

  int _byCountThenTimeDescExercise(
    ExerciseActivityStat a,
    ExerciseActivityStat b,
  ) {
    final byCount = b.sessionCount.compareTo(a.sessionCount);
    if (byCount != 0) return byCount;
    return b.totalPracticeTime.compareTo(a.totalPracticeTime);
  }

  List<CategoryActivityStat> _categoryStats(
    List<SessionActivitySample> samples,
    DateTime now,
  ) {
    final byCategory = <ContentCategory, List<SessionActivitySample>>{};
    for (final s in samples) {
      byCategory.putIfAbsent(s.category, () => []).add(s);
    }
    final overallAvgSpeed = _avgSpeed(samples);
    return [
      for (final entry in byCategory.entries)
        CategoryActivityStat(
          category: entry.key,
          sessionCount: entry.value.length,
          totalPracticeTime: entry.value
              .map((s) => s.duration)
              .reduce((a, b) => a + b),
          avgAccuracyPct: _avgAccuracy(entry.value),
          avgNetSpeedCpm: _avgSpeed(entry.value),
          performanceScore: _performanceScore(entry.value, overallAvgSpeed),
          trend: _trendFor(entry.value, now, overallAvgSpeed),
        ),
    ];
  }

  List<ExerciseActivityStat> _exerciseStats(
    List<SessionActivitySample> samples,
  ) {
    final bySnippet = <SnippetId, List<SessionActivitySample>>{};
    for (final s in samples) {
      bySnippet.putIfAbsent(s.snippetId, () => []).add(s);
    }
    final overallAvgSpeed = _avgSpeed(samples);
    return [
      for (final entry in bySnippet.entries)
        ExerciseActivityStat(
          snippetId: entry.key,
          sessionCount: entry.value.length,
          totalPracticeTime: entry.value
              .map((s) => s.duration)
              .reduce((a, b) => a + b),
          avgAccuracyPct: _avgAccuracy(entry.value),
          avgNetSpeedCpm: _avgSpeed(entry.value),
          performanceScore: _performanceScore(entry.value, overallAvgSpeed),
        ),
    ];
  }

  double _avgAccuracy(List<SessionActivitySample> group) {
    if (group.isEmpty) return 0;
    return group.map((s) => s.accuracyPct).reduce((a, b) => a + b) /
        group.length;
  }

  double _avgSpeed(List<SessionActivitySample> group) {
    if (group.isEmpty) return 0;
    return group.map((s) => s.netSpeedCpm).reduce((a, b) => a + b) /
        group.length;
  }

  double _performanceScore(
    List<SessionActivitySample> group,
    double overallAvgSpeed,
  ) {
    if (group.isEmpty) return 0;
    final normalizedSpeedPct = overallAvgSpeed <= 0
        ? 0.0
        : math.min(100, _avgSpeed(group) / overallAvgSpeed * 50);
    return accuracyWeight * _avgAccuracy(group) +
        speedWeight * normalizedSpeedPct;
  }

  /// [Trend.improving] here means `performanceScore` went **up** between
  /// the two windows — the inverse of `Trend`'s usual weakness-score
  /// direction (see `CategoryActivityStat.trend`'s doc).
  Trend _trendFor(
    List<SessionActivitySample> samples,
    DateTime now,
    double overallAvgSpeed,
  ) {
    final recentWindow = [
      for (final s in samples)
        if (_ageInDays(now, s.occurredAtUtc) < _trendWindowDays) s,
    ];
    final previousWindow = [
      for (final s in samples)
        if (_ageInDays(now, s.occurredAtUtc) >= _trendWindowDays &&
            _ageInDays(now, s.occurredAtUtc) < 2 * _trendWindowDays)
          s,
    ];
    if (recentWindow.isEmpty || previousWindow.isEmpty) return Trend.stable;

    final recentScore = _performanceScore(recentWindow, overallAvgSpeed);
    final previousScore = _performanceScore(previousWindow, overallAvgSpeed);
    if (previousScore <= 0) {
      return recentScore <= 0 ? Trend.stable : Trend.improving;
    }
    final relativeChange = (recentScore - previousScore) / previousScore;
    if (relativeChange > _stableBandFraction) return Trend.improving;
    if (relativeChange < -_stableBandFraction) return Trend.worsening;
    return Trend.stable;
  }

  double _ageInDays(DateTime now, DateTime occurredAtUtc) {
    return now.difference(occurredAtUtc).inMicroseconds /
        Duration.microsecondsPerDay;
  }
}
