import 'package:ridge/core/notifications/daily_reminder_scheduler.dart';
import 'package:ridge/core/notifications/local_notifications_daily_reminder_scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';

/// Provides the app-lifetime [DailyReminderScheduler] implementation.
@Riverpod(keepAlive: true)
DailyReminderScheduler dailyReminderScheduler(Ref ref) =>
    LocalNotificationsDailyReminderScheduler();
