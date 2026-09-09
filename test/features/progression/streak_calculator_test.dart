// Unit tests for `StreakCalculator` — pure and stateless, `today`
// injected explicitly so every scenario is deterministic. Covers a
// broken streak, the alive-through-yesterday edge case, and
// timezone-safe local-date handling (dates with a time-of-day component
// must still bucket correctly by calendar day).
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/progression/domain/services/streak_calculator.dart';

void main() {
  const calculator = StreakCalculator();

  test('no session history at all is a 0-day streak', () {
    expect(calculator.compute(const [], DateTime(2026, 1, 10)), 0);
  });

  test('a session today alone is a 1-day streak', () {
    final today = DateTime(2026, 1, 10);
    expect(calculator.compute([today], today), 1);
  });

  test('consecutive days through today count fully', () {
    final today = DateTime(2026, 1, 10);
    final dates = [today, DateTime(2026, 1, 9), DateTime(2026, 1, 8)];
    expect(calculator.compute(dates, today), 3);
  });

  test(
    'no session today yet still counts the streak alive through yesterday',
    () {
      final today = DateTime(2026, 1, 10);
      final dates = [DateTime(2026, 1, 9), DateTime(2026, 1, 8)];
      expect(calculator.compute(dates, today), 2);
    },
  );

  test('a broken streak (missing both today and yesterday) resets to 0', () {
    final today = DateTime(2026, 1, 10);
    final dates = [DateTime(2026, 1, 8)];
    expect(calculator.compute(dates, today), 0);
  });

  test(
    'a gap in the middle disconnects the run — only the recent side counts',
    () {
      final today = DateTime(2026, 1, 10);
      // 01-09 (yesterday) is missing, so 01-08/01-07 don't connect to today.
      final dates = [today, DateTime(2026, 1, 8), DateTime(2026, 1, 7)];
      expect(calculator.compute(dates, today), 1);
    },
  );

  test('dates with a time-of-day component still bucket by calendar day '
      '(timezone/local-date safety)', () {
    final today = DateTime(2026, 1, 5, 0, 1);
    final dates = [DateTime(2026, 1, 5, 23, 59), DateTime(2026, 1, 4, 6)];
    expect(calculator.compute(dates, today), 2);
  });

  test('duplicate same-day entries do not inflate the streak', () {
    final today = DateTime(2026, 1, 10);
    final dates = [
      today,
      DateTime(2026, 1, 10, 8),
      DateTime(2026, 1, 10, 20),
      DateTime(2026, 1, 9),
    ];
    expect(calculator.compute(dates, today), 2);
  });
}
