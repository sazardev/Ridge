import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter (currently local key-value storage).
abstract interface class SettingsRepository {
  /// Emits the current settings and every update after it.
  Stream<AppSettings> watch();

  /// Persists [settings] as the new current preferences.
  Future<Result<void, AppFailure>> update(AppSettings settings);
}
