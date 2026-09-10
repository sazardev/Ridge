import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/domain/repositories/settings_repository.dart';

/// Streams the current [AppSettings] and every subsequent update.
class WatchSettingsUseCase {
  /// Creates the use case bound to a [SettingsRepository].
  const new(this._repository);

  final SettingsRepository _repository;

  /// Returns a stream that emits whenever preferences change.
  Stream<AppSettings> call() => _repository.watch();
}
