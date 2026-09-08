import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter (currently local key-value storage).
abstract interface class SettingsRepository {
  Stream<AppSettings> watch();

  Future<Result<void, AppFailure>> update(AppSettings settings);
}
