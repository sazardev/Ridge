import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_palette.dart';
import 'package:just_in_time/features/settings/domain/entities/app_sound_pack.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/domain/entities/app_window_border_width.dart';

part 'app_settings.freezed.dart';

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
    required bool windowBorderEnabled,
    required AppWindowBorderWidth windowBorderWidth,
    required AppCornerStyle cornerStyle,
    required AppPaletteId palette,
    required AppSoundPack soundPack,
    required bool onboardingCompleted,
    String? languageCode,
  }) = _AppSettings;

  /// Default preferences used before anything has been persisted.
  static const initial = AppSettings(
    themeMode: AppThemeMode.system,
    expressiveColor: true,
    appLockEnabled: false,
    windowBorderEnabled: true,
    windowBorderWidth: AppWindowBorderWidth.medium,
    cornerStyle: AppCornerStyle.soft,
    palette: AppPaletteId.ember,
    soundPack: AppSoundPack.mechanical,
    onboardingCompleted: false,
  );
}
