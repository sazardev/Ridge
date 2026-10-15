// Unit tests for `ApplyDailyReminderUseCase` — a fake scheduler records
// every schedule/cancel so each branch (disabled, in-app-only platform,
// practiced-today, next-occurrence math) is asserted exactly.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/notifications/daily_reminder_scheduler.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/settings/application/usecases/apply_daily_reminder_usecase.dart';

class _FakeScheduler implements DailyReminderScheduler {
  new(this.capability);

  @override
  final DailyReminderCapability capability;

  final List<DateTime> scheduledAt = [];
  int cancelCalls = 0;

  @override
  Future<bool> ensurePermission() async => true;

  @override
  Future<Result<void, AppFailure>> scheduleNext({
    required DateTime occurrence,
    required String title,
    required String body,
  }) async {
    scheduledAt.add(occurrence);
    return const Result.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> cancel() async {
    cancelCalls += 1;
    return const Result.ok(null);
  }
}

void main() {
  final now = DateTime(2026, 1, 10, 10);

  Future<Result<void, AppFailure>> run(
    _FakeScheduler scheduler, {
    bool enabled = true,
    bool practicedToday = false,
    int minutesSinceMidnight = 20 * 60,
  }) {
    return ApplyDailyReminderUseCase(scheduler)(
      enabled: enabled,
      minutesSinceMidnight: minutesSinceMidnight,
      practicedToday: practicedToday,
      title: 'Title',
      body: 'Body',
      now: now,
    );
  }

  test('disabled cancels and never schedules', () async {
    final scheduler = _FakeScheduler(DailyReminderCapability.osScheduled);
    await run(scheduler, enabled: false);

    expect(scheduler.scheduledAt, isEmpty);
    expect(scheduler.cancelCalls, 1);
  });

  test('an in-app-only platform cancels instead of scheduling', () async {
    final scheduler = _FakeScheduler(DailyReminderCapability.inAppOnly);
    await run(scheduler);

    expect(scheduler.scheduledAt, isEmpty);
    expect(scheduler.cancelCalls, 1);
  });

  test('enabled schedules the next occurrence through the scheduler', () async {
    final scheduler = _FakeScheduler(DailyReminderCapability.osScheduled);
    final result = await run(scheduler);

    expect(result.isOk, isTrue);
    expect(scheduler.scheduledAt, [DateTime(2026, 1, 10, 20)]);
    expect(scheduler.cancelCalls, 0);
  });

  test('already practiced today schedules tomorrow', () async {
    final scheduler = _FakeScheduler(DailyReminderCapability.osScheduled);
    await run(scheduler, practicedToday: true);

    expect(scheduler.scheduledAt, [DateTime(2026, 1, 11, 20)]);
  });
}
