import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';

part 'app_settings.freezed.dart';

/// Pure domain entity — no JSON, no Flutter imports. Infrastructure maps
/// this to/from its own DTO so the storage format can change without ever
/// touching this file.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory({
    required AppThemeMode themeMode,
    required bool expressiveColor,
    required bool appLockEnabled,
    String? languageCode,
  }) = _AppSettings;

  static const initial = AppSettings(
    themeMode: AppThemeMode.system,
    expressiveColor: true,
    appLockEnabled: false,
  );
}
