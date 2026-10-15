import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';

/// What a platform can actually do for the daily practice reminder
/// (STACK.md §3.1): Android ships the notification scheduler; Linux has
/// no scheduling API, Windows can't repeat, and browsers can't schedule
/// — on every one of those the in-app nudge card is the whole reminder.
enum DailyReminderCapability {
  /// A notification can be scheduled for a future time.
  osScheduled,

  /// No scheduler on this platform: only the in-app nudge card exists.
  inAppOnly,
}

/// The next local [DateTime] at [minutesSinceMidnight] that a daily
/// reminder should fire at (SPEC.md §12's local retention hook): today
/// when that time hasn't passed yet, tomorrow otherwise — or always
/// tomorrow when [skipToday] is set (the profile already practiced
/// today, so the next reminder should never nag about a done day).
/// Pure, so the scheduler and its tests share one definition of "the
/// next reminder".
DateTime nextDailyReminderOccurrence({
  required DateTime now,
  required int minutesSinceMidnight,
  bool skipToday = false,
}) {
  final today = DateTime(
    now.year,
    now.month,
    now.day,
  ).add(Duration(minutes: minutesSinceMidnight));
  if (!skipToday && today.isAfter(now)) return today;
  return today.add(const Duration(days: 1));
}

/// Driven port for the daily practice reminder — a *local* notification,
/// never a push: nothing leaves the device (SPEC.md §15). Implementations
/// no-op gracefully on platforms whose [capability] is
/// [DailyReminderCapability.inAppOnly].
abstract interface class DailyReminderScheduler {
  /// What this platform can do.
  DailyReminderCapability get capability;

  /// Asks the OS for notification permission when the platform requires
  /// one — `true` when notifications may be shown, also `true` on
  /// platforms without a runtime prompt. Call it in response to an
  /// explicit user action (the Settings toggle), never speculatively.
  Future<bool> ensurePermission();

  /// Schedules the single next [occurrence], replacing anything already
  /// pending. One-shot by design: the app re-schedules on startup, on
  /// settings changes and after any finished session, so a day already
  /// practiced is never nagged about.
  Future<Result<void, AppFailure>> scheduleNext({
    required DateTime occurrence,
    required String title,
    required String body,
  });

  /// Cancels anything pending (reminder disabled, or the platform has no
  /// scheduler anyway).
  Future<Result<void, AppFailure>> cancel();
}
