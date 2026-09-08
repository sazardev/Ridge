import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart'
    show AppSettings;

part 'settings_dto.freezed.dart';
part 'settings_dto.g.dart';

/// Wire/storage shape for [AppSettings]. Kept separate from the domain
/// entity so a future storage-format change never leaks into business
/// logic — only `SettingsMapper` needs to change.
@freezed
abstract class SettingsDto with _$SettingsDto {
  const factory({
    required String themeMode,
    required bool expressiveColor,
    required bool appLockEnabled,
    String? languageCode,
  }) = _SettingsDto;

  factory fromJson(Map<String, Object?> json) => _$SettingsDtoFromJson(json);
}
