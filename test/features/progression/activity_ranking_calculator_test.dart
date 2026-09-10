// Unit tests for `ActivityRankingCalculator` — pure and stateless, every
// sample's `occurredAtUtc` hand-fabricated relative to an injected `now`
// (no clock). Covers the performanceScore formula (accuracy blended with
// speed normalized to the batch average), "most practiced" staying
// lifetime-scoped while "lowest scoring" stays recency-windowed with a
// minimum sample size, the category/exercise symmetry, and trend
// comparison across two adjacent 30-day windows (inverted direction from
// `WeaknessRankingCalculator`'s, since higher performanceScore is
// better).
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/progression/domain/entities/activity_report.dart';
import 'package:just_in_time/features/progression/domain/entities/session_activity_sample.dart';
import 'package:just_in_time/features/progression/domain/entities/trend.dart';
import 'package:just_in_time/features/progression/domain/services/activity_ranking_calculator.dart';

void main() {
  const calculator = ActivityRankingCalculator();
  final now = DateTime.utc(2100);

  SessionActivitySample sample({
    ContentCategory category = ContentCategory.loops,
    String snippetId = 'snippet-1',
    double netSpeedCpm = 100,
    double accuracyPct = 90,
    int ageInDays = 0,
    int durationMinutes = 5,
  }) {
    return SessionActivitySample(
      snippetId: SnippetId(snippetId),
      category: category,
      duration: Duration(minutes: durationMinutes),
      netSpeedCpm: netSpeedCpm,
      accuracyPct: accuracyPct,
      occurredAtUtc: now.subtract(Duration(days: ageInDays)),
    );
  }

  test('empty input yields an empty report', () {
    final report = calculator.calculate([], now: now);
    expect(report, ActivityReport.empty);
  });

  test('performanceScore blends accuracy with speed normalized to the '
      'batch average', () {
    final report = calculator.calculate([
      sample(netSpeedCpm: 200, accuracyPct: 100),
      sample(category: ContentCategory.functions, accuracyPct: 100),
    ], now: now);

    // Batch average speed = (200 + 100) / 2 = 150.
    // loops: normalizedSpeedPct = min(100, 200/150*50) = 66.667
    //   -> score = 0.6*100 + 0.4*66.667 = 86.667
    // functions: normalizedSpeedPct = min(100, 100/150*50) = 33.333
    //   -> score = 0.6*100 + 0.4*33.333 = 73.333
    final byCategory = {
      for (final c in report.mostPracticedCategories)
        c.category: c.performanceScore,
    };
    expect(byCategory[ContentCategory.loops], closeTo(86.667, 1e-2));
    expect(byCategory[ContentCategory.functions], closeTo(73.333, 1e-2));
  });

  test('most practiced categories are ranked by lifetime session count, '
      'ignoring recency', () {
    final samples = [
      for (var i = 0; i < 5; i++) sample(ageInDays: 200),
      for (var i = 0; i < 2; i++)
        sample(category: ContentCategory.functions, ageInDays: 5),
    ];
    final report = calculator.calculate(samples, now: now);

    expect(report.mostPracticedCategories, hasLength(2));
    expect(
      report.mostPracticedCategories.first.category,
      ContentCategory.loops,
    );
    expect(report.mostPracticedCategories.first.sessionCount, 5);
    expect(
      report.mostPracticedCategories.last.category,
      ContentCategory.functions,
    );
    expect(report.mostPracticedCategories.last.sessionCount, 2);

    // `loops` has zero sessions within the 60-day recency window, and
    // `functions` has only 2 (below the minimum of 3) — neither is
    // eligible for "lowest scoring".
    expect(report.lowestScoringCategories, isEmpty);
  });

  test('lowest scoring categories stay within the recency window and '
      'require a minimum sample size', () {
    final samples = [
      // 3 recent sessions, poor accuracy -> low score.
      for (var i = 0; i < 3; i++) sample(accuracyPct: 50, ageInDays: 10),
      // 3 recent sessions, strong accuracy -> high score.
      for (var i = 0; i < 3; i++)
        sample(
          category: ContentCategory.functions,
          accuracyPct: 95,
          ageInDays: 10,
        ),
      // Only 2 recent sessions despite terrible accuracy -> excluded.
      for (var i = 0; i < 2; i++)
        sample(
          category: ContentCategory.conditionals,
          accuracyPct: 10,
          ageInDays: 10,
        ),
    ];
    final report = calculator.calculate(samples, now: now);

    expect(report.lowestScoringCategories, hasLength(2));
    expect(
      report.lowestScoringCategories.first.category,
      ContentCategory.loops,
    );
    expect(
      report.lowestScoringCategories.last.category,
      ContentCategory.functions,
    );
    expect(
      report.lowestScoringCategories.any(
        (c) => c.category == ContentCategory.conditionals,
      ),
      isFalse,
    );
  });

  test(
    'exercises are ranked the same way as categories, keyed by snippetId',
    () {
      final samples = [
        for (var i = 0; i < 4; i++) sample(snippetId: 'popular'),
        for (var i = 0; i < 1; i++) sample(snippetId: 'rare'),
      ];
      final report = calculator.calculate(samples, now: now);

      expect(
        report.mostPracticedExercises.first.snippetId,
        const SnippetId('popular'),
      );
      expect(report.mostPracticedExercises.first.sessionCount, 4);
    },
  );

  group('trend: two adjacent 30-day windows (higher score = improving)', () {
    test('better recent performance than past is improving', () {
      final samples = [
        for (var i = 0; i < 2; i++) sample(accuracyPct: 50, ageInDays: 45),
        for (var i = 0; i < 2; i++) sample(accuracyPct: 95, ageInDays: 10),
      ];
      final report = calculator.calculate(samples, now: now);
      expect(report.mostPracticedCategories.single.trend, Trend.improving);
    });

    test('worse recent performance than past is worsening', () {
      final samples = [
        for (var i = 0; i < 2; i++) sample(accuracyPct: 95, ageInDays: 45),
        for (var i = 0; i < 2; i++) sample(accuracyPct: 50, ageInDays: 10),
      ];
      final report = calculator.calculate(samples, now: now);
      expect(report.mostPracticedCategories.single.trend, Trend.worsening);
    });

    test('a similar performance in both windows is stable', () {
      final samples = [
        sample(ageInDays: 45),
        sample(accuracyPct: 91, ageInDays: 10),
      ];
      final report = calculator.calculate(samples, now: now);
      expect(report.mostPracticedCategories.single.trend, Trend.stable);
    });

    test('missing data in either window is reported as stable', () {
      final samples = [sample(accuracyPct: 50, ageInDays: 10)];
      final report = calculator.calculate(samples, now: now);
      expect(report.mostPracticedCategories.single.trend, Trend.stable);
    });
  });
}
