import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/notifications/daily_reminder_scheduler.dart';
import 'package:ridge/core/notifications/notification_providers.dart';
import 'package:ridge/features/settings/application/usecases/apply_daily_reminder_usecase.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_reminder_providers.g.dart';

/// Provides the [ApplyDailyReminderUseCase] over the platform scheduler.
@Riverpod(keepAlive: true)
ApplyDailyReminderUseCase applyDailyReminderUseCase(Ref ref) =>
    ApplyDailyReminderUseCase(ref.watch(dailyReminderSchedulerProvider));

/// Coordinates the daily practice reminder across its moving parts —
/// the settings snapshot, the platform's [DailyReminderCapability] and
/// the localized notification copy. Kept alive so its `Ref` stays valid
/// across `sync`'s awaits (callers fire it from provider listeners, not
/// from widget builds).
@Riverpod(keepAlive: true)
DailyReminderService dailyReminderService(Ref ref) => DailyReminderService(ref);

/// See [dailyReminderService].
class DailyReminderService {
  /// Creates the service over the given ref.
  const new(this._ref);

  final Ref _ref;

  /// What the current platform can do (drives the Settings copy: a
  /// scheduled reminder vs. the in-app-only degradation).
  DailyReminderCapability get capability =>
      _ref.read(dailyReminderSchedulerProvider).capability;

  /// Requests OS notification permission for an explicit user action
  /// (turning the Settings toggle on) — `true` when the reminder may be
  /// shown. Never prompts on platforms without a runtime permission.
  Future<bool> requestPermission() =>
      _ref.read(dailyReminderSchedulerProvider).ensurePermission();

  /// Re-applies the reminder from the current settings and whether the
  /// profile already practiced today. A no-op state (disabled, or a
  /// platform without a scheduler) still cancels any pending schedule,
  /// so this is always safe to fire — see [ApplyDailyReminderUseCase].
  Future<void> sync({required bool practicedToday}) async {
    final scheduler = _ref.read(dailyReminderSchedulerProvider);
    final settings =
        _ref.read(settingsControllerProvider).value ?? AppSettings.initial;
    if (!settings.dailyReminderEnabled ||
        scheduler.capability == DailyReminderCapability.inAppOnly) {
      await scheduler.cancel();
      return;
    }

    final l10n = await _loadLocalizations(settings.languageCode);
    await _ref.read(applyDailyReminderUseCaseProvider)(
      enabled: true,
      minutesSinceMidnight: settings.dailyReminderMinutes,
      practicedToday: practicedToday,
      title: l10n.dailyReminderNotificationTitle,
      body: l10n.dailyReminderNotificationBody,
      now: DateTime.now(),
    );
  }

  /// The app's current locale (settings override, else the platform's),
  /// resolved to one of the bundled translations — the notification is
  /// composed outside any widget build, so it can't read the localizations
  /// off a `BuildContext`.
  Future<AppLocalizations> _loadLocalizations(String? languageCode) {
    final language =
        languageCode ?? PlatformDispatcher.instance.locale.languageCode;
    return AppLocalizations.delegate.load(Locale(language));
  }
}
