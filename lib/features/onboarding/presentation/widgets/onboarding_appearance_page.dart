import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:just_in_time/features/settings/presentation/widgets/palette_picker.dart';

/// Onboarding step that doubles as a live editor for the same
/// [settingsControllerProvider] Settings itself writes to — a pick here is
/// never a one-off "onboarding only" choice with its own storage, and it
/// can always be revisited later in Settings (see this page's own copy).
class OnboardingAppearancePage extends ConsumerWidget {
  /// Creates the appearance step.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    final controller = ref.read(settingsControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        children: [
          Text(
            l10n.onboardingAppearanceTitle,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingAppearanceDescription,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.settingsSectionPalette,
              style: textTheme.labelLarge,
            ),
          ),
          PalettePicker(
            selected: settings.palette,
            expressive: settings.expressiveColor,
            onSelected: controller.setPalette,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsExpressiveColor),
            subtitle: Text(l10n.settingsExpressiveColorSubtitle),
            value: settings.expressiveColor,
            onChanged: (value) => controller.setExpressiveColor(value: value),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.settingsCornerStyle, style: textTheme.labelLarge),
          ),
          const SizedBox(height: 8),
          SegmentedButton<AppCornerStyle>(
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
        ],
      ),
    ).animate().fadeIn(
      duration: AppMotion.spatialDefault,
      curve: AppMotion.enter,
    );
  }
}
