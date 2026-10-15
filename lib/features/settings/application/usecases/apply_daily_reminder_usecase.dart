import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/notifications/daily_reminder_scheduler.dart';
import 'package:ridge/core/utils/result.dart';

/// Re-materializes the daily practice reminder from one coherent snapshot
/// of (enabled, time of day, practiced-today, localized copy): schedules
/// the single next occurrence on a platform with a scheduler, cancels
/// otherwise. Idempotent, so every caller — app startup, a settings edit,
/// any finished session — can fire it without coordination.
class ApplyDailyReminderUseCase {
  /// Creates the use case over the reminder [DailyReminderScheduler].
  const new(this._scheduler);

  final DailyReminderScheduler _scheduler;

  /// Applies the reminder state described by the arguments. [title] and
  /// [body] arrive already localized (the caller owns the copy, keeping
  /// this use case free of Flutter/i18n imports).
  Future<Result<void, AppFailure>> call({
    required bool enabled,
    required int minutesSinceMidnight,
    required bool practicedToday,
    required String title,
    required String body,
    required DateTime now,
  }) {
    if (!enabled ||
        _scheduler.capability == DailyReminderCapability.inAppOnly) {
      return _scheduler.cancel();
    }
    return _scheduler.scheduleNext(
      occurrence: nextDailyReminderOccurrence(
        now: now,
        minutesSinceMidnight: minutesSinceMidnight,
        skipToday: practicedToday,
      ),
      title: title,
      body: body,
    );
  }
}
