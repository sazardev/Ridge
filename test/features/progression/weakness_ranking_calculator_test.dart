// Unit tests for `WeaknessRankingCalculator` — pure and stateless, every
// sample's age hand-fabricated (no clock). Covers the 14-day half-life
// recency math, slowness normalization relative to the batch average,
// the top-N cap, genericity across key types (characters vs. `Finger`s
// — the "three separate lists" the project plan calls for are just this
// same calculator called three times with different key types), and
// trend comparison across two adjacent 14-day windows.
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/progression/domain/entities/trend.dart';
import 'package:just_in_time/features/progression/domain/services/weakness_ranking_calculator.dart';

void main() {
  const calculator = WeaknessRankingCalculator();

  test(
    'recency half-life: a recent error outweighs an old correct keystroke',
    () {
      // Recent (age 0, weight 1.0) is an error; old (age 14, weight 0.5)
      // is correct. Weighted error rate = 1.0 / (1.0 + 0.5) = 2/3, so
      // score = 0.6 * 2/3 = 0.4 exactly (slowness is 0 since every
      // flight here is 0ms).
      final ranked = calculator.rank({
        'a': [
          const WeaknessSample(ageInDays: 0, isError: true, flightMs: 0),
          const WeaknessSample(ageInDays: 14, isError: false, flightMs: 0),
        ],
      });
      expect(ranked.single.score, closeTo(0.4, 1e-9));
    },
  );

  test('slowness is normalized relative to the batch average, not an '
      'absolute constant', () {
    final ranked = calculator.rank({
      'fast': [
        const WeaknessSample(ageInDays: 0, isError: false, flightMs: 100),
      ],
      'slow': [
        const WeaknessSample(ageInDays: 0, isError: false, flightMs: 300),
      ],
    });
    // Global weighted average flight = (100 + 300) / 2 = 200.
    // fast: 100 / (2*200) = 0.25 -> score = 0.4 * 0.25 = 0.1
    // slow: 300 / (2*200) = 0.75 -> score = 0.4 * 0.75 = 0.3
    final byKey = {for (final e in ranked) e.key: e.score};
    expect(byKey['fast'], closeTo(0.1, 1e-9));
    expect(byKey['slow'], closeTo(0.3, 1e-9));
    // Worst (highest score) first.
    expect(ranked.first.key, 'slow');
  });

  test('ranking is capped to topN, worst-first', () {
    final samplesByKey = {
      for (var i = 0; i < 15; i++)
        'char$i': [
          WeaknessSample(ageInDays: 0, isError: i.isEven, flightMs: 0),
        ],
    };
    final ranked = calculator.rank(samplesByKey);
    expect(ranked, hasLength(10));
    for (var i = 0; i < ranked.length - 1; i++) {
      expect(ranked[i].score, greaterThanOrEqualTo(ranked[i + 1].score));
    }
  });

  test('works generically over a non-String key type (Finger)', () {
    final ranked = calculator.rank<Finger>({
      Finger.leftPinky: [
        const WeaknessSample(ageInDays: 0, isError: true, flightMs: 0),
      ],
      Finger.rightIndex: [
        const WeaknessSample(ageInDays: 0, isError: false, flightMs: 0),
      ],
    });
    expect(ranked.first.key, Finger.leftPinky);
    expect(ranked.first.score, greaterThan(ranked.last.score));
  });

  group('trend: two adjacent 14-day windows', () {
    test('an error-free past turning into errors now is worsening', () {
      final ranked = calculator.rank({
        'a': [
          // Previous window (14-28 days ago): all correct.
          for (var i = 0; i < 3; i++)
            const WeaknessSample(ageInDays: 20, isError: false, flightMs: 0),
          // Recent window (0-14 days ago): all errors.
          for (var i = 0; i < 3; i++)
            const WeaknessSample(ageInDays: 1, isError: true, flightMs: 0),
        ],
      });
      expect(ranked.single.trend, Trend.worsening);
    });

    test('an error-prone past turning clean now is improving', () {
      final ranked = calculator.rank({
        'a': [
          for (var i = 0; i < 3; i++)
            const WeaknessSample(ageInDays: 20, isError: true, flightMs: 0),
          for (var i = 0; i < 3; i++)
            const WeaknessSample(ageInDays: 1, isError: false, flightMs: 0),
        ],
      });
      expect(ranked.single.trend, Trend.improving);
    });

    test('a similar error rate in both windows is stable', () {
      final ranked = calculator.rank({
        'a': [
          const WeaknessSample(ageInDays: 20, isError: true, flightMs: 0),
          const WeaknessSample(ageInDays: 21, isError: false, flightMs: 0),
          const WeaknessSample(ageInDays: 1, isError: true, flightMs: 0),
          const WeaknessSample(ageInDays: 2, isError: false, flightMs: 0),
        ],
      });
      expect(ranked.single.trend, Trend.stable);
    });

    test('missing data in either window is reported as stable', () {
      final ranked = calculator.rank({
        'a': [const WeaknessSample(ageInDays: 1, isError: true, flightMs: 0)],
      });
      expect(ranked.single.trend, Trend.stable);
    });
  });
}
