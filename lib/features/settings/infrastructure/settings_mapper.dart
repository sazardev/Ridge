import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_palette.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:just_in_time/features/settings/domain/entities/app_sound_pack.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/domain/entities/app_window_border_width.dart';
import 'package:just_in_time/features/settings/domain/entities/shortcut_binding.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_dto.dart';

/// Converts a [SettingsDto] into its domain [AppSettings] representation.
extension SettingsDtoMapper on SettingsDto {
  /// Maps this DTO to the domain entity, defaulting an unrecognized theme
  /// name to [AppThemeMode.system].
  AppSettings toDomain() {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (m) => m.name == themeMode,
        orElse: () => AppThemeMode.system,
      ),
      expressiveColor: expressiveColor,
      appLockEnabled: appLockEnabled,
      windowBorderEnabled: windowBorderEnabled,
      windowBorderWidth: AppWindowBorderWidth.values.firstWhere(
        (w) => w.name == windowBorderWidth,
        orElse: () => AppWindowBorderWidth.medium,
      ),
      cornerStyle: AppCornerStyle.values.firstWhere(
        (c) => c.name == cornerStyle,
        orElse: () => AppCornerStyle.soft,
      ),
      palette: AppPaletteId.values.firstWhere(
        (p) => p.name == palette,
        orElse: () => AppPaletteId.ember,
      ),
      soundPack: AppSoundPack.values.firstWhere(
        (s) => s.name == soundPack,
        orElse: () => AppSoundPack.mechanical,
      ),
      onboardingCompleted: onboardingCompleted,
      shortcutBindings: {
        for (final action in AppShortcutAction.values)
          action:
              _decodeBinding(shortcutBindings[action.name]) ??
              AppSettings.initial.shortcutBindings[action]!,
      },
      languageCode: languageCode,
    );
  }
}

/// Converts an [AppSettings] domain entity into its storage [SettingsDto].
extension AppSettingsMapper on AppSettings {
  /// Maps this entity to its wire/storage shape.
  SettingsDto toDto() {
    return SettingsDto(
      themeMode: themeMode.name,
      expressiveColor: expressiveColor,
      appLockEnabled: appLockEnabled,
      windowBorderEnabled: windowBorderEnabled,
      windowBorderWidth: windowBorderWidth.name,
      cornerStyle: cornerStyle.name,
      palette: palette.name,
      soundPack: soundPack.name,
      onboardingCompleted: onboardingCompleted,
      shortcutBindings: {
        for (final entry in shortcutBindings.entries)
          entry.key.name: _encodeBinding(entry.value),
      },
      languageCode: languageCode,
    );
  }
}

/// Encodes [binding] as a compact `"keyId|control|alt|shift"` string —
/// plain enough that `SettingsDto.shortcutBindings` stays a native
/// `Map<String, String>` json_serializable already knows how to
/// (de)serialize, no nested-object schema needed.
String _encodeBinding(ShortcutBinding binding) {
  return '${binding.keyId}|${binding.control}|${binding.alt}|${binding.shift}';
}

/// Decodes a string produced by [_encodeBinding], or `null` if [raw] is
/// absent or malformed (a missing action — e.g. an older persisted blob
/// from before shortcuts were customizable — or corrupted data) so the
/// caller can fall back to [AppSettings.initial]'s default for that
/// action instead of crashing.
ShortcutBinding? _decodeBinding(String? raw) {
  if (raw == null) return null;
  final parts = raw.split('|');
  if (parts.length != 4) return null;
  final keyId = int.tryParse(parts[0]);
  if (keyId == null) return null;
  return ShortcutBinding(
    keyId: keyId,
    control: parts[1] == 'true',
    alt: parts[2] == 'true',
    shift: parts[3] == 'true',
  );
}
