import 'dart:convert';

import 'package:just_in_time/features/settings/infrastructure/settings_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  const new(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const _key = 'settings.v1';

  Future<SettingsDto?> read() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    return SettingsDto.fromJson(jsonDecode(raw) as Map<String, Object?>);
  }

  Future<void> write(SettingsDto dto) {
    return _prefs.setString(_key, jsonEncode(dto.toJson()));
  }
}
