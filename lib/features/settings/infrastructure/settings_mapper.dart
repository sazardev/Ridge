import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_dto.dart';

extension SettingsDtoMapper on SettingsDto {
  AppSettings toDomain() {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (m) => m.name == themeMode,
        orElse: () => AppThemeMode.system,
      ),
      expressiveColor: expressiveColor,
      appLockEnabled: appLockEnabled,
      languageCode: languageCode,
    );
  }
}

extension AppSettingsMapper on AppSettings {
  SettingsDto toDto() {
    return SettingsDto(
      themeMode: themeMode.name,
      expressiveColor: expressiveColor,
      appLockEnabled: appLockEnabled,
      languageCode: languageCode,
    );
  }
}
