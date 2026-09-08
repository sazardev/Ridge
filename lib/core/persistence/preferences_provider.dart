import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_provider.g.dart';

/// Shared local key-value store used by feature-level infrastructure
/// adapters (never by domain/application code, and never by widgets
/// directly). `SharedPreferencesAsync` talks straight to the platform
/// channel on every call — no stale in-memory cache to reason about.
@Riverpod(keepAlive: true)
SharedPreferencesAsync sharedPreferences(Ref ref) {
  return SharedPreferencesAsync();
}
