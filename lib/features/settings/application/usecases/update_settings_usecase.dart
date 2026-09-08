import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  const new(this._repository);

  final SettingsRepository _repository;

  Future<Result<void, AppFailure>> call(AppSettings settings) =>
      _repository.update(settings);
}
