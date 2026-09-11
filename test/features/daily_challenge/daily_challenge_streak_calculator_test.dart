// Unit tests for `DailyChallengeStreakCalculator` — pure and stateless,
// `today` injected explicitly so every scenario is deterministic.
// Mirrors `progression`'s `streak_calculator_test.dart` case-for-case,
// keyed on `ChallengeDate` (UTC) instead of a local calendar date.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/daily_challenge/domain/services/daily_challenge_streak_calculator.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

ChallengeDate _date(int year, int month, int day) =>
    ChallengeDate(DateTime.utc(year, month, day));

void main() {
  const calculator = DailyChallengeStreakCalculator();

  test('no completion history at all is a 0-day streak', () {
    expect(calculator.compute(const [], _date(2026, 1, 10)), 0);
  });

  test("today's completion alone is a 1-day streak", () {
    final today = _date(2026, 1, 10);
    expect(calculator.compute([today], today), 1);
  });

  test('consecutive days through today count fully', () {
    final today = _date(2026, 1, 10);
    final dates = [today, _date(2026, 1, 9), _date(2026, 1, 8)];
    expect(calculator.compute(dates, today), 3);
  });

  test('not having played today yet still counts the streak alive through '
      'yesterday', () {
    final today = _date(2026, 1, 10);
    final dates = [_date(2026, 1, 9), _date(2026, 1, 8)];
    expect(calculator.compute(dates, today), 2);
  });

  test('a broken streak (missing both today and yesterday) resets to 0', () {
    final today = _date(2026, 1, 10);
    final dates = [_date(2026, 1, 8)];
    expect(calculator.compute(dates, today), 0);
  });

  test(
    'a gap in the middle disconnects the run — only the recent side counts',
    () {
      final today = _date(2026, 1, 10);
      // 01-09 (yesterday) is missing, so 01-08/01-07 don't connect to today.
      final dates = [today, _date(2026, 1, 8), _date(2026, 1, 7)];
      expect(calculator.compute(dates, today), 1);
    },
  );

  test('duplicate same-day entries do not inflate the streak', () {
    final today = _date(2026, 1, 10);
    final dates = [today, today, _date(2026, 1, 9)];
    expect(calculator.compute(dates, today), 2);
  });

  test('a streak crossing a month/year boundary still counts correctly', () {
    final today = _date(2026, 1, 1);
    final dates = [today, _date(2025, 12, 31), _date(2025, 12, 30)];
    expect(calculator.compute(dates, today), 3);
  });
}
