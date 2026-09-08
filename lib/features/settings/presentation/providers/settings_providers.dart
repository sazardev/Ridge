import 'package:just_in_time/core/persistence/preferences_provider.dart';
import 'package:just_in_time/features/settings/application/usecases/update_settings_usecase.dart';
import 'package:just_in_time/features/settings/application/usecases/watch_settings_usecase.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_theme_mode.dart';
import 'package:just_in_time/features/settings/domain/repositories/settings_repository.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_local_data_source.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsLocalDataSource settingsLocalDataSource(Ref ref) {
  return SettingsLocalDataSource(ref.watch(sharedPreferencesProvider));
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider));
}

@riverpod
WatchSettingsUseCase watchSettingsUseCase(Ref ref) {
  return WatchSettingsUseCase(ref.watch(settingsRepositoryProvider));
}

@riverpod
UpdateSettingsUseCase updateSettingsUseCase(Ref ref) {
  return UpdateSettingsUseCase(ref.watch(settingsRepositoryProvider));
}

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Stream<AppSettings> build() {
    return ref.watch(watchSettingsUseCaseProvider)();
  }

  Future<void> _update(AppSettings Function(AppSettings current) transform) {
    final current = state.value ?? AppSettings.initial;
    return ref.read(updateSettingsUseCaseProvider)(transform(current));
  }

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update((s) => s.copyWith(themeMode: mode));

  Future<void> setExpressiveColor({required bool value}) =>
      _update((s) => s.copyWith(expressiveColor: value));

  Future<void> setLanguageCode(String? code) =>
      _update((s) => s.copyWith(languageCode: code));

  Future<void> setAppLockEnabled({required bool value}) =>
      _update((s) => s.copyWith(appLockEnabled: value));
}
