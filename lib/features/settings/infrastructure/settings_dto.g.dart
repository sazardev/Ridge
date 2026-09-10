// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsDto _$SettingsDtoFromJson(Map<String, dynamic> json) => _SettingsDto(
  themeMode: json['themeMode'] as String,
  expressiveColor: json['expressiveColor'] as bool,
  appLockEnabled: json['appLockEnabled'] as bool,
  appLockBiometricEnabled: json['appLockBiometricEnabled'] as bool? ?? false,
  windowBorderEnabled: json['windowBorderEnabled'] as bool? ?? true,
  windowBorderWidth: json['windowBorderWidth'] as String? ?? 'medium',
  cornerStyle: json['cornerStyle'] as String? ?? 'soft',
  palette: json['palette'] as String? ?? 'ember',
  soundPack: json['soundPack'] as String? ?? 'mechanical',
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  shortcutBindings:
      (json['shortcutBindings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  languageCode: json['languageCode'] as String?,
);

Map<String, dynamic> _$SettingsDtoToJson(_SettingsDto instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'expressiveColor': instance.expressiveColor,
      'appLockEnabled': instance.appLockEnabled,
      'appLockBiometricEnabled': instance.appLockBiometricEnabled,
      'windowBorderEnabled': instance.windowBorderEnabled,
      'windowBorderWidth': instance.windowBorderWidth,
      'cornerStyle': instance.cornerStyle,
      'palette': instance.palette,
      'soundPack': instance.soundPack,
      'onboardingCompleted': instance.onboardingCompleted,
      'shortcutBindings': instance.shortcutBindings,
      'languageCode': instance.languageCode,
    };
