// Unit tests for `nextDailyReminderOccurrence` — pure, `now` injected
// explicitly so every scenario is deterministic.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/notifications/daily_reminder_scheduler.dart';

void main() {
  test('a time still ahead today fires today', () {
    final next = nextDailyReminderOccurrence(
      now: DateTime(2026, 1, 10, 10),
      minutesSinceMidnight: 20 * 60,
    );
    expect(next, DateTime(2026, 1, 10, 20));
  });

  test('a time already passed today fires tomorrow', () {
    final next = nextDailyReminderOccurrence(
      now: DateTime(2026, 1, 10, 21),
      minutesSinceMidnight: 20 * 60,
    );
    expect(next, DateTime(2026, 1, 11, 20));
  });

  test('the exact occurrence time is not "still ahead" — tomorrow wins', () {
    final next = nextDailyReminderOccurrence(
      now: DateTime(2026, 1, 10, 20),
      minutesSinceMidnight: 20 * 60,
    );
    expect(next, DateTime(2026, 1, 11, 20));
  });

  test('skipToday (already practiced) always fires tomorrow', () {
    final next = nextDailyReminderOccurrence(
      now: DateTime(2026, 1, 10, 10),
      minutesSinceMidnight: 20 * 60,
      skipToday: true,
    );
    expect(next, DateTime(2026, 1, 11, 20));
  });

  test('midnight is a valid time (fires tomorrow right after midnight)', () {
    final next = nextDailyReminderOccurrence(
      now: DateTime(2026, 1, 10, 0, 30),
      minutesSinceMidnight: 0,
    );
    expect(next, DateTime(2026, 1, 11));
  });
}
