import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_palette.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_sound_pack.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/domain/entities/app_window_border_width.dart';
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
      languageCode: languageCode,
    );
  }
}
