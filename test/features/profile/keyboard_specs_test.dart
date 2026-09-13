// Unit tests for the shared keyboard spec-row source behind the profile
// card's summary line and the viewer's spec sheet.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/keyboard_specs.dart';

GuestProfile _profile({KeyboardCustomization? customization}) => GuestProfile(
  id: ProfileId.generate(),
  username: 'Omar',
  createdAt: DateTime(2026),
  keyboardBrand: 'MCHOSE',
  keyboardModel: 'MCHOSE GX87',
  keyboardLayout: KeyboardLayout.qwerty,
  keyboardCustomization: customization,
);

void main() {
  test('an unset keyboard yields no spec rows', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final profile = GuestProfile(
      id: ProfileId.generate(),
      username: 'Omar',
      createdAt: DateTime(2026),
    );

    expect(keyboardSpecRows(profile, l10n), isEmpty);
    expect(keyboardSpecSummary(profile, l10n), isEmpty);
  });

  test('every set field becomes one label/value row, in order', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final rows = keyboardSpecRows(
      _profile(
        customization: const KeyboardCustomization(
          shapeFamily: KeyboardShapeFamily.tkl,
          switchType: SwitchType.tactile,
          keycapMaterial: KeycapMaterial.pbt,
          caseMaterial: CaseMaterial.aluminum,
          connection: KeyboardConnectionType.multi,
          hotSwappable: true,
          rgbEnabled: true,
          rgbEffect: RgbEffect.breathing,
          purchaseYear: 2024,
          notes: 'First build.',
          keyOverrides: [
            KeyboardKeyLegendOverride(keyId: '0.000,0.000', label: 'Ñ'),
          ],
          extraKeys: [KeyboardExtraKey(id: 'e1')],
          remaps: [KeyboardKeyRemap(physicalKey: 'keyA', character: 'q')],
        ),
      ),
      l10n,
    );

    expect(
      rows.map((row) => row.$1),
      containsAllInOrder([
        'Keyboard brand',
        'Keyboard model',
        'Keyboard layout',
        'Form factor',
        'Switch type',
        'Keycap material',
        'Case material',
        'Connection',
        'Hot-swappable',
        'Effect',
        'Purchased',
        'Custom legends',
        'Extra keys',
        'Functional remaps',
        'Notes',
      ]),
    );
    expect(
      rows.firstWhere((row) => row.$1 == 'Form factor').$2,
      'Tenkeyless (TKL)',
    );
    expect(rows.firstWhere((row) => row.$1 == 'Hot-swappable').$2, 'Yes');
    expect(rows.firstWhere((row) => row.$1 == 'Effect').$2, 'Breathing');
  });

  test('the summary keeps only the first few values', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final summary = keyboardSpecSummary(
      _profile(
        customization: const KeyboardCustomization(
          switchType: SwitchType.linear,
        ),
      ),
      l10n,
    );

    // brand, model, layout, form factor — switch cut off at the default cap.
    expect(summary, hasLength(4));
    expect(summary, isNot(contains('Linear')));
  });
}
