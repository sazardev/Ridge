import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_palette.dart';
import 'package:just_in_time/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:just_in_time/features/settings/domain/entities/app_sound_pack.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/domain/entities/app_window_border_width.dart';
import 'package:just_in_time/features/settings/domain/entities/shortcut_binding.dart';

part 'app_settings.freezed.dart';

/// The 9 default keyboard-shortcut bindings, before any user
/// customization — mirrors what `AppNavigationShortcuts`/`ProgressScreen`
/// hardcoded before shortcuts became rebindable. `keyId` values are
/// `LogicalKeyboardKey.digit1`/`.tab`/`.pageDown`/`.pageUp`'s own
/// `keyId`s, copied as plain integers so this domain file stays
/// Flutter-free (see `ShortcutBinding`'s own doc for why).
const Map<AppShortcutAction, ShortcutBinding> _defaultShortcutBindings = {
  AppShortcutAction.goToPractice: ShortcutBinding(
    keyId: 0x31,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToProgress: ShortcutBinding(
    keyId: 0x32,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToFreePractice: ShortcutBinding(
    keyId: 0x33,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToProfile: ShortcutBinding(
    keyId: 0x34,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToSettings: ShortcutBinding(
    keyId: 0x35,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.cycleNextSection: ShortcutBinding(
    keyId: 0x100000009,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.cyclePreviousSection: ShortcutBinding(
    keyId: 0x100000009,
    control: true,
    alt: false,
    shift: true,
  ),
  AppShortcutAction.cycleNextTab: ShortcutBinding(
    keyId: 0x100000307,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.cyclePreviousTab: ShortcutBinding(
    keyId: 0x100000308,
    control: true,
    alt: false,
    shift: false,
  ),
};

/// Pure domain entity — no JSON, no Flutter imports. Infrastructure maps
/// this to/from its own DTO so the storage format can change without ever
/// touching this file.
@freezed
abstract class AppSettings with _$AppSettings {
  /// Creates an immutable settings snapshot.
  const factory({
    required AppThemeMode themeMode,
    required bool expressiveColor,
    required bool appLockEnabled,
    required bool appLockBiometricEnabled,
    required bool windowBorderEnabled,
    required AppWindowBorderWidth windowBorderWidth,
    required AppCornerStyle cornerStyle,
    required AppPaletteId palette,
    required AppSoundPack soundPack,
    required bool onboardingCompleted,
    required Map<AppShortcutAction, ShortcutBinding> shortcutBindings,
    String? languageCode,
  }) = _AppSettings;

  /// Default preferences used before anything has been persisted.
  static const initial = AppSettings(
    themeMode: AppThemeMode.system,
    expressiveColor: true,
    appLockEnabled: false,
    appLockBiometricEnabled: false,
    windowBorderEnabled: true,
    windowBorderWidth: AppWindowBorderWidth.medium,
    cornerStyle: AppCornerStyle.soft,
    palette: AppPaletteId.ember,
    soundPack: AppSoundPack.mechanical,
    onboardingCompleted: false,
    shortcutBindings: _defaultShortcutBindings,
  );
}
