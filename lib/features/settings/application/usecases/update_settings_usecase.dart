import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/repositories/settings_repository.dart';

/// Persists an updated [AppSettings] snapshot through the settings port.
class UpdateSettingsUseCase {
  /// Creates the use case bound to a [SettingsRepository].
  const new(this._repository);

  final SettingsRepository _repository;

  /// Saves [settings] as the new current preferences.
  Future<Result<void, AppFailure>> call(AppSettings settings) =>
      _repository.update(settings);
}
