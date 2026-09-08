// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsDto _$SettingsDtoFromJson(Map<String, dynamic> json) => _SettingsDto(
  themeMode: json['themeMode'] as String,
  expressiveColor: json['expressiveColor'] as bool,
  appLockEnabled: json['appLockEnabled'] as bool,
  languageCode: json['languageCode'] as String?,
);

Map<String, dynamic> _$SettingsDtoToJson(_SettingsDto instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'expressiveColor': instance.expressiveColor,
      'appLockEnabled': instance.appLockEnabled,
      'languageCode': instance.languageCode,
    };
