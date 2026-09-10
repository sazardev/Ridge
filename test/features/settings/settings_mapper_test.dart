// Unit tests for `SettingsMapper`'s `shortcutBindings` round-trip and its
// backward-compatibility fallback for blobs persisted before shortcuts
// became customizable.
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:just_in_time/features/settings/domain/entities/shortcut_binding.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_dto.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_mapper.dart';

void main() {
  test('toDto -> toDomain round-trips a customized binding exactly', () {
    const customized = ShortcutBinding(
      keyId: 0x41,
      control: false,
      alt: true,
      shift: true,
    );
    final settings = AppSettings.initial.copyWith(
      shortcutBindings: {
        ...AppSettings.initial.shortcutBindings,
        AppShortcutAction.goToProfile: customized,
      },
    );

    final roundTripped = settings.toDto().toDomain();

    expect(
      roundTripped.shortcutBindings[AppShortcutAction.goToProfile],
      customized,
    );
  });

  test('a DTO with no shortcutBindings at all (pre-customization blob) '
      'falls back to every default binding', () {
    const dto = SettingsDto(
      themeMode: 'system',
      expressiveColor: true,
      appLockEnabled: false,
    );

    final domain = dto.toDomain();

    expect(domain.shortcutBindings, AppSettings.initial.shortcutBindings);
  });

  test('a malformed entry for one action falls back to just that '
      "action's default, leaving the rest of the map untouched", () {
    const dto = SettingsDto(
      themeMode: 'system',
      expressiveColor: true,
      appLockEnabled: false,
      shortcutBindings: {'goToProfile': 'not-a-valid-encoding'},
    );

    final domain = dto.toDomain();

    expect(
      domain.shortcutBindings[AppShortcutAction.goToProfile],
      AppSettings.initial.shortcutBindings[AppShortcutAction.goToProfile],
    );
    expect(domain.shortcutBindings.length, AppShortcutAction.values.length);
  });
}
