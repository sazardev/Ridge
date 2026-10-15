import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/notifications/daily_reminder_scheduler.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// [DailyReminderScheduler] on `flutter_local_notifications` — deliberately
/// Android-only for *scheduling* (see [capability]): it is the one target
/// platform whose plugin actually has a notification scheduler, while
/// Linux/Windows/Web degrade to the in-app nudge card (STACK.md §3.1).
/// The plugin object is created lazily: a build that never touches the
/// reminder pays nothing for the dependency.
class LocalNotificationsDailyReminderScheduler
    implements DailyReminderScheduler {
  /// Creates the scheduler.
  new();

  /// One stable id is enough — each schedule replaces the previous one.
  static const _reminderId = 1;

  /// The Android notification channel (v1 has a single reminder kind).
  static const _channelId = 'daily_reminder';

  /// Matches `android/app/src/main/res/drawable/ic_stat_ridge.xml`; kept
  /// by `res/raw/keep.xml` against R8 resource shrinking.
  static const _androidIcon = 'ic_stat_ridge';

  FlutterLocalNotificationsPlugin? _plugin;

  @override
  DailyReminderCapability get capability =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? DailyReminderCapability.osScheduled
      : DailyReminderCapability.inAppOnly;

  @override
  Future<bool> ensurePermission() async {
    if (capability != DailyReminderCapability.osScheduled) return true;
    final plugin = await _ensureInitialized();
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
  }

  @override
  Future<Result<void, AppFailure>> scheduleNext({
    required DateTime occurrence,
    required String title,
    required String body,
  }) async {
    if (capability != DailyReminderCapability.osScheduled) {
      return const Result.ok(null);
    }
    try {
      final plugin = await _ensureInitialized();
      await plugin.zonedSchedule(
        id: _reminderId,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(occurrence, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Daily reminder',
            channelDescription:
                'A local nudge to practice at your chosen time. '
                'Nothing leaves your device.',
          ),
        ),
        // Inexact on purpose: a practice nudge doesn't need an exact
        // alarm, and inexact scheduling needs no SCHEDULE_EXACT_ALARM
        // permission on Android 14+ (STACK.md §3.1).
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      return const Result.ok(null);
    } on Exception {
      return const Result.err(
        UnexpectedFailure('Could not schedule the daily reminder.'),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> cancel() async {
    if (capability != DailyReminderCapability.osScheduled) {
      return const Result.ok(null);
    }
    try {
      final plugin = await _ensureInitialized();
      await plugin.cancel(id: _reminderId);
      return const Result.ok(null);
    } on Exception {
      return const Result.err(
        UnexpectedFailure('Could not cancel the daily reminder.'),
      );
    }
  }

  Future<FlutterLocalNotificationsPlugin> _ensureInitialized() async {
    final existing = _plugin;
    if (existing != null) return existing;

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
      ),
    );
    // `zonedSchedule` needs the IANA tz database plus the device's own
    // zone resolved into it; both are cheap and only ever run once.
    tz_data.initializeTimeZones();
    final localZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localZone.identifier));

    _plugin = plugin;
    return plugin;
  }
}
