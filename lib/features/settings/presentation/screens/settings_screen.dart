import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/lock/presentation/providers/lock_providers.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:just_in_time/features/settings/presentation/widgets/settings_section.dart';

class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SettingsSection(
            title: l10n.settingsSectionAppearance,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.settingsTheme,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SegmentedButton<AppThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: AppThemeMode.system,
                      label: Text(l10n.settingsThemeSystem),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.light,
                      label: Text(l10n.settingsThemeLight),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.dark,
                      label: Text(l10n.settingsThemeDark),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (selection) =>
                      controller.setThemeMode(selection.first),
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              SwitchListTile(
                title: Text(l10n.settingsExpressiveColor),
                subtitle: Text(l10n.settingsExpressiveColorSubtitle),
                value: settings.expressiveColor,
                onChanged: (value) =>
                    controller.setExpressiveColor(value: value),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.settingsSectionLanguage,
            children: [
              RadioGroup<String?>(
                groupValue: settings.languageCode,
                onChanged: controller.setLanguageCode,
                child: Column(
                  children: [
                    RadioListTile<String?>(
                      title: Text(l10n.settingsLanguageSystem),
                      value: null,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const RadioListTile<String?>(
                      title: Text('English'),
                      value: 'en',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const RadioListTile<String?>(
                      title: Text('Español'),
                      value: 'es',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.settingsSectionSecurity,
            children: [
              SwitchListTile(
                title: Text(l10n.settingsAppLock),
                subtitle: Text(l10n.settingsAppLockSubtitle),
                value: settings.appLockEnabled,
                onChanged: (enable) async {
                  if (enable) {
                    final created = await context.push<bool>('/lock-setup');
                    if (created == true) {
                      await controller.setAppLockEnabled(value: true);
                    }
                  } else {
                    await ref.read(clearPinUseCaseProvider)();
                    await controller.setAppLockEnabled(value: false);
                  }
                },
              ),
              if (settings.appLockEnabled) ...[
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.settingsChangePin),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push<bool>('/lock-setup'),
                ),
              ],
            ],
          ),
          SettingsSection(
            title: l10n.settingsSectionAbout,
            children: [
              ListTile(
                title: Text(l10n.settingsAboutVersion('1.0.0')),
                subtitle: Text(l10n.settingsAboutArchitecture),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
