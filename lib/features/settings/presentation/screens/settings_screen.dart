import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/app_info/app_info_provider.dart';
import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/core/window/desktop_platform.dart';
import 'package:just_in_time/features/data_management/presentation/widgets/data_management_section.dart';
import 'package:just_in_time/features/lock/presentation/providers/lock_providers.dart';
import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/domain/entities/app_window_border_width.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:just_in_time/features/settings/presentation/widgets/palette_picker.dart';
import 'package:just_in_time/features/settings/presentation/widgets/settings_section.dart';
import 'package:just_in_time/features/settings/presentation/widgets/sound_pack_picker.dart';

/// The Settings screen: theme, expressive color, language, and app-lock.
class SettingsScreen extends ConsumerStatefulWidget {
  /// Creates the settings screen.
  const new({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: KeyboardScrollShortcuts(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
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
                const Divider(height: 1, indent: 16, endIndent: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.settingsCornerStyle,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Text(
                    l10n.settingsCornerStyleSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SegmentedButton<AppCornerStyle>(
                    segments: [
                      ButtonSegment(
                        value: AppCornerStyle.sharp,
                        label: Text(l10n.cornerStyleSharp),
                      ),
                      ButtonSegment(
                        value: AppCornerStyle.soft,
                        label: Text(l10n.cornerStyleSoft),
                      ),
                      ButtonSegment(
                        value: AppCornerStyle.round,
                        label: Text(l10n.cornerStyleRound),
                      ),
                      ButtonSegment(
                        value: AppCornerStyle.pill,
                        label: Text(l10n.cornerStylePill),
                      ),
                    ],
                    selected: {settings.cornerStyle},
                    onSelectionChanged: (selection) =>
                        controller.setCornerStyle(selection.first),
                  ),
                ),
                if (isDesktopPlatform) ...[
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: Text(l10n.settingsWindowBorder),
                    subtitle: Text(l10n.settingsWindowBorderSubtitle),
                    value: settings.windowBorderEnabled,
                    onChanged: (value) =>
                        controller.setWindowBorderEnabled(value: value),
                  ),
                  if (settings.windowBorderEnabled) ...[
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.settingsWindowBorderWidth,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SegmentedButton<AppWindowBorderWidth>(
                        segments: [
                          ButtonSegment(
                            value: AppWindowBorderWidth.thin,
                            label: Text(l10n.windowBorderWidthThin),
                          ),
                          ButtonSegment(
                            value: AppWindowBorderWidth.medium,
                            label: Text(l10n.windowBorderWidthMedium),
                          ),
                          ButtonSegment(
                            value: AppWindowBorderWidth.thick,
                            label: Text(l10n.windowBorderWidthThick),
                          ),
                        ],
                        selected: {settings.windowBorderWidth},
                        onSelectionChanged: (selection) =>
                            controller.setWindowBorderWidth(selection.first),
                      ),
                    ),
                  ],
                ],
              ],
            ),
            SettingsSection(
              title: l10n.settingsSectionPalette,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.settingsPaletteSubtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                PalettePicker(
                  selected: settings.palette,
                  expressive: settings.expressiveColor,
                  onSelected: controller.setPalette,
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsSectionSound,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.settingsSoundSubtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                SoundPackPicker(
                  selected: settings.soundPack,
                  onSelected: controller.setSoundPack,
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
              title: l10n.settingsSectionShortcuts,
              children: [
                ListTile(
                  title: Text(l10n.settingsShortcutsTitle),
                  subtitle: Text(l10n.settingsShortcutsSubtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/shortcuts'),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsSectionAbout,
              children: [
                ListTile(
                  title: Text(
                    l10n.settingsAboutVersion(switch (ref.watch(
                      appInfoProvider,
                    )) {
                      AsyncData(:final value) =>
                        '${value.version}+${value.buildNumber}',
                      _ => '…',
                    }),
                  ),
                  subtitle: Text(l10n.settingsAboutArchitecture),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(l10n.settingsAboutChangelog),
                  subtitle: Text(l10n.settingsAboutChangelogSubtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/changelog'),
                ),
              ],
            ),
            const DataManagementSection(),
          ],
        ),
      ),
    );
  }
}
