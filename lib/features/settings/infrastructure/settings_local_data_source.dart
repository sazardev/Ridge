import 'dart:convert';

import 'package:ridge/features/settings/infrastructure/settings_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads and writes the persisted [SettingsDto] behind `shared_preferences`.
class SettingsLocalDataSource {
  /// Creates the data source backed by a `SharedPreferencesAsync` instance.
  const new(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const _key = 'settings.v1';

  /// Returns the persisted DTO, or `null` if nothing has been saved yet.
  Future<SettingsDto?> read() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return null;
    return SettingsDto.fromJson(jsonDecode(raw) as Map<String, Object?>);
  }

  /// Persists [dto] as the current settings snapshot.
  Future<void> write(SettingsDto dto) {
    return _prefs.setString(_key, jsonEncode(dto.toJson()));
  }
}
