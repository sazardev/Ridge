import 'package:shared_preferences/shared_preferences.dart';

/// Reads and writes the active learning language's enum name behind
/// `shared_preferences` — kept as a raw string so this adapter knows
/// nothing about `content`'s enum (the name↔enum mapping lives in the
/// repository).
class ActiveLanguageLocalDataSource {
  /// Creates the data source backed by a `SharedPreferencesAsync` instance.
  const new(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const _key = 'learning_paths.active_language.v1';

  /// Returns the persisted language name, or `null` if nothing is saved.
  Future<String?> read() => _prefs.getString(_key);

  /// Persists [name] as the active language, or removes the preference
  /// when `null`.
  Future<void> write(String? name) =>
      name == null ? _prefs.remove(_key) : _prefs.setString(_key, name);
}
