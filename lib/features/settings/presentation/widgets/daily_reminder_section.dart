import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/presentation/providers/daily_reminder_providers.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:ridge/features/settings/presentation/widgets/settings_section.dart';

/// The "Practice reminder" Settings section — Android only, the one
/// target platform whose scheduler can actually fire with the app closed
/// (STACK.md §3.1). Everywhere else the in-app nudge card is the whole
/// feature, so there is nothing to configure and `SettingsScreen` simply
/// omits this section (mirrors how the Permissions section is
/// Android-gated).
///
/// Turning the switch on asks for the OS notification permission first
/// (never speculatively, per the plugin's own guidance) and only persists
/// the preference once it's granted; the actual (re)scheduling is done by
/// `dailyReminderGuard`, which reacts to the settings change.
class DailyReminderSection extends ConsumerWidget {
  /// Creates the section.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    final controller = ref.read(settingsControllerProvider.notifier);
    final service = ref.read(dailyReminderServiceProvider);
    final time = _timeOfDayFor(settings.dailyReminderMinutes);

    Future<void> toggle({required bool value}) async {
      if (!value) {
        await controller.setDailyReminderEnabled(value: false);
        return;
      }
      final granted = await service.requestPermission();
      if (!context.mounted) return;
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsDailyReminderDenied)),
        );
        return;
      }
      await controller.setDailyReminderEnabled(value: true);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsDailyReminderSaved)));
    }

    Future<void> pickTime() async {
      final picked = await showTimePicker(context: context, initialTime: time);
      if (picked == null) return;
      await controller.setDailyReminderMinutes(
        picked.hour * 60 + picked.minute,
      );
    }

    return SettingsSection(
      title: l10n.settingsSectionReminder,
      children: [
        SwitchListTile(
          title: Text(l10n.settingsDailyReminderTitle),
          subtitle: Text(l10n.settingsDailyReminderSubtitle),
          value: settings.dailyReminderEnabled,
          onChanged: (value) => toggle(value: value),
        ),
        if (settings.dailyReminderEnabled) ...[
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(LucideIcons.alarmClock300),
            title: Text(l10n.settingsDailyReminderTimeLabel),
            trailing: Text(time.format(context)),
            onTap: pickTime,
          ),
        ],
      ],
    );
  }
}

/// `TimeOfDay` for [minutesSinceMidnight] — the inverse of the
/// `hour * 60 + minute` encoding persisted in
/// [AppSettings.dailyReminderMinutes].
TimeOfDay _timeOfDayFor(int minutesSinceMidnight) {
  return TimeOfDay(
    hour: minutesSinceMidnight ~/ 60,
    minute: minutesSinceMidnight % 60,
  );
}
