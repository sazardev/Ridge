import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/repositories/settings_repository.dart';

class WatchSettingsUseCase {
  const new(this._repository);

  final SettingsRepository _repository;

  Stream<AppSettings> call() => _repository.watch();
}
