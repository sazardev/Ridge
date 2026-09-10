import 'package:ridge/core/persistence/preferences_provider.dart';
import 'package:ridge/features/settings/application/usecases/update_settings_usecase.dart';
import 'package:ridge/features/settings/application/usecases/watch_settings_usecase.dart';
import 'package:ridge/features/settings/domain/entities/app_corner_style.dart';
import 'package:ridge/features/settings/domain/entities/app_palette.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:ridge/features/settings/domain/entities/app_sound_pack.dart';
import 'package:ridge/features/settings/domain/entities/app_theme_mode.dart';
import 'package:ridge/features/settings/domain/entities/app_window_border_width.dart';
import 'package:ridge/features/settings/domain/entities/shortcut_binding.dart';
import 'package:ridge/features/settings/domain/repositories/settings_repository.dart';
import 'package:ridge/features/settings/infrastructure/settings_local_data_source.dart';
import 'package:ridge/features/settings/infrastructure/settings_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Provides the [SettingsLocalDataSource] backed by shared preferences.
@Riverpod(keepAlive: true)
SettingsLocalDataSource settingsLocalDataSource(Ref ref) {
  return SettingsLocalDataSource(ref.watch(sharedPreferencesProvider));
}

/// Provides the [SettingsRepository] implementation used across the app.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider));
}

/// Provides the [WatchSettingsUseCase] for observing preference changes.
@riverpod
WatchSettingsUseCase watchSettingsUseCase(Ref ref) {
  return WatchSettingsUseCase(ref.watch(settingsRepositoryProvider));
}

/// Provides the [UpdateSettingsUseCase] for persisting preference changes.
@riverpod
UpdateSettingsUseCase updateSettingsUseCase(Ref ref) {
  return UpdateSettingsUseCase(ref.watch(settingsRepositoryProvider));
}

/// Exposes the current [AppSettings] and the mutations the UI can request.
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

  /// Switches the app's [AppThemeMode].
  Future<void> setThemeMode(AppThemeMode mode) =>
      _update((s) => s.copyWith(themeMode: mode));

  /// Toggles the expressive dynamic color scheme.
  Future<void> setExpressiveColor({required bool value}) =>
      _update((s) => s.copyWith(expressiveColor: value));

  /// Sets the UI language, or `null` to follow the system locale.
  Future<void> setLanguageCode(String? code) =>
      _update((s) => s.copyWith(languageCode: code));

  /// Enables or disables the PIN app-lock. Disabling also turns off
  /// biometric unlock, since it only ever runs as a shortcut for the PIN.
  Future<void> setAppLockEnabled({required bool value}) => _update(
    (s) => s.copyWith(
      appLockEnabled: value,
      appLockBiometricEnabled: value && s.appLockBiometricEnabled,
    ),
  );

  /// Enables or disables biometric (fingerprint/Face ID) unlock as a
  /// shortcut for the PIN — only meaningful while [AppSettings.appLockEnabled]
  /// is already on.
  Future<void> setAppLockBiometricEnabled({required bool value}) =>
      _update((s) => s.copyWith(appLockBiometricEnabled: value));

  /// Toggles the desktop window's custom rounded border and shadow.
  Future<void> setWindowBorderEnabled({required bool value}) =>
      _update((s) => s.copyWith(windowBorderEnabled: value));

  /// Changes the desktop window frame's border thickness.
  Future<void> setWindowBorderWidth(AppWindowBorderWidth width) =>
      _update((s) => s.copyWith(windowBorderWidth: width));

  /// Changes the global corner style shared by the window frame and every
  /// Material component's shape.
  Future<void> setCornerStyle(AppCornerStyle style) =>
      _update((s) => s.copyWith(cornerStyle: style));

  /// Switches the app's global color palette.
  Future<void> setPalette(AppPaletteId palette) =>
      _update((s) => s.copyWith(palette: palette));

  /// Switches the keystroke sound effects pack.
  Future<void> setSoundPack(AppSoundPack pack) =>
      _update((s) => s.copyWith(soundPack: pack));

  /// Marks the first-run onboarding flow as seen so it never shows again.
  Future<void> setOnboardingCompleted({required bool value}) =>
      _update((s) => s.copyWith(onboardingCompleted: value));

  /// Rebinds [action] to [binding], leaving every other action's
  /// shortcut untouched.
  Future<void> setShortcutBinding(
    AppShortcutAction action,
    ShortcutBinding binding,
  ) => _update(
    (s) =>
        s.copyWith(shortcutBindings: {...s.shortcutBindings, action: binding}),
  );
}
