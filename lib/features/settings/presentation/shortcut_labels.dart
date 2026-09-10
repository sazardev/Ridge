import 'package:flutter/services.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:just_in_time/features/settings/domain/entities/shortcut_binding.dart';

/// Localized display label for an [AppShortcutAction], shared by every
/// widget that renders one so the mapping lives in exactly one place
/// (mirrors `content`'s `ContentCategoryLabel`).
extension AppShortcutActionLabel on AppShortcutAction {
  /// Returns this action's localized display label.
  String label(AppLocalizations l10n) => switch (this) {
    AppShortcutAction.goToPractice => l10n.shortcutActionGoToPractice,
    AppShortcutAction.goToProgress => l10n.shortcutActionGoToProgress,
    AppShortcutAction.goToFreePractice => l10n.shortcutActionGoToFreePractice,
    AppShortcutAction.goToProfile => l10n.shortcutActionGoToProfile,
    AppShortcutAction.goToSettings => l10n.shortcutActionGoToSettings,
    AppShortcutAction.cycleNextSection => l10n.shortcutActionCycleNextSection,
    AppShortcutAction.cyclePreviousSection =>
      l10n.shortcutActionCyclePreviousSection,
    AppShortcutAction.cycleNextTab => l10n.shortcutActionCycleNextTab,
    AppShortcutAction.cyclePreviousTab => l10n.shortcutActionCyclePreviousTab,
  };
}

/// Human-readable rendering of a [ShortcutBinding], e.g. "Ctrl+1" or
/// "Ctrl+Shift+Tab" — order and casing match the common desktop
/// convention (modifiers first, always capitalized).
extension ShortcutBindingLabel on ShortcutBinding {
  /// Returns this binding's display label.
  String get displayLabel {
    final parts = <String>[
      if (control) 'Ctrl',
      if (alt) 'Alt',
      if (shift) 'Shift',
      LogicalKeyboardKey(keyId).keyLabel,
    ];
    return parts.join('+');
  }
}
