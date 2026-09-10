import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart'
    show AppSettings;

part 'settings_dto.freezed.dart';
part 'settings_dto.g.dart';

/// Wire/storage shape for [AppSettings]. Kept separate from the domain
/// entity so a future storage-format change never leaks into business
/// logic — only `SettingsMapper` needs to change.
@freezed
abstract class SettingsDto with _$SettingsDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String themeMode,
    required bool expressiveColor,
    required bool appLockEnabled,
    @Default(false) bool appLockBiometricEnabled,
    @Default(true) bool windowBorderEnabled,
    @Default('medium') String windowBorderWidth,
    @Default('soft') String cornerStyle,
    @Default('ember') String palette,
    @Default('mechanical') String soundPack,
    @Default(false) bool onboardingCompleted,
    @Default(<String, String>{}) Map<String, String> shortcutBindings,
    String? languageCode,
  }) = _SettingsDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) => _$SettingsDtoFromJson(json);
}
