import 'dart:async';

import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/settings/presentation/providers/daily_reminder_providers.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_reminder_guard.g.dart';

/// Keeps the daily practice reminder in sync with reality: fires once the
/// app's settings and session history first load, and again whenever the
/// reminder-relevant settings or the session list change (any finished
/// session included) — so the scheduled ping always targets the next
/// sensible occurrence and never nags about a day already practiced.
///
/// Watched unconditionally in `RidgeApp.build`, the same fire-on-start
/// shape as `catalogSeedProvider`/`deepLinkListenerProvider`. Deliberately
/// lives in `practice` rather than `settings`: it needs the session
/// history, and `practice -> settings` is an established direction while
/// the reverse would be a new cycle.
@Riverpod(keepAlive: true)
Future<void> dailyReminderGuard(Ref ref) async {
  ref.listen(settingsControllerProvider, (previous, next) {
    final before = previous?.value;
    final after = next.value;
    if (after == null) return;
    final reminderChanged =
        before?.dailyReminderEnabled != after.dailyReminderEnabled ||
        before?.dailyReminderMinutes != after.dailyReminderMinutes ||
        before?.languageCode != after.languageCode;
    if (before == null || reminderChanged) _syncReminder(ref);
  });

  ref.listen(typingSessionsProvider, (previous, next) {
    if (next.hasValue) _syncReminder(ref);
  });
}

/// Re-applies the reminder from the profile's finished sessions — "today"
/// is the *local* calendar day, matching the reminder's own local-time
/// nature (the Daily Challenge's UTC day is its own separate concern).
void _syncReminder(Ref ref) {
  final sessions =
      ref.read(typingSessionsProvider).value ?? const <TypingSession>[];
  final now = DateTime.now();
  final practicedToday = sessions.any((session) {
    final local = session.startedAtUtc.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  });
  unawaited(
    ref.read(dailyReminderServiceProvider).sync(practicedToday: practicedToday),
  );
}
