// Unit tests for the keyboard-customization JSON mapper — the storage
// contract behind `guest_profiles.keyboard_customization_json`. Covers a
// full round-trip, forward-compatible enum degradation, pruning of
// half-formed entries and corrupt-blob forgiveness.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_customization_dto.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_customization_mapper.dart';

void main() {
  test('a fully-populated customization round-trips exactly', () {
    const customization = KeyboardCustomization(
      shapeFamily: KeyboardShapeFamily.seventyFive,
      keycapShape: KeycapShape.round,
      keycapTransparency: KeycapTransparency.pudding,
      keycapColor: 0xFFECECEC,
      caseColor: 0xFF1B1B1B,
      rgbEnabled: true,
      rgbEffect: RgbEffect.rainbow,
      rgbColor: 0xFFFF5A36,
      switchType: SwitchType.tactile,
      keycapMaterial: KeycapMaterial.pbt,
      caseMaterial: CaseMaterial.aluminum,
      physicalLayout: KeyboardPhysicalLayout.iso,
      connection: KeyboardConnectionType.multi,
      hotSwappable: true,
      purchaseYear: 2024,
      notes: 'First build.',
      keyOverrides: [
        KeyboardKeyLegendOverride(keyId: '1.000,2.000', label: 'Ñ'),
      ],
      extraKeys: [KeyboardExtraKey(id: 'e1', label: 'Macro', width: 1.5)],
      remaps: [
        KeyboardKeyRemap(
          physicalKey: 'keyA',
          character: 'q',
          shiftedCharacter: 'Q',
        ),
      ],
      keyLights: [KeyboardKeyLight(keyId: '0.000,0.000', color: 0xFF00E5FF)],
    );

    final decoded = decodeKeyboardCustomization(
      encodeKeyboardCustomization(customization),
    );

    expect(decoded, customization);
  });

  test('an empty string/null blob decodes to null', () {
    expect(decodeKeyboardCustomization(null), isNull);
    expect(decodeKeyboardCustomization(''), isNull);
  });

  test('corrupt JSON decodes to null instead of throwing', () {
    expect(decodeKeyboardCustomization('{not json'), isNull);
    expect(decodeKeyboardCustomization('[1,2,3]'), isNull);
    expect(decodeKeyboardCustomization('"a string"'), isNull);
  });

  test('unknown enum names degrade to that field only', () {
    final decoded = decodeKeyboardCustomization(
      jsonEncode({
        'shapeFamily': 'hyperErgo9000',
        'keycapShape': 'triangular',
        'rgbEffect': 'disco',
        'switchType': 'laser',
        'keycapColor': 12,
        'rgbEnabled': true,
      }),
    );

    expect(decoded, isNotNull);
    expect(decoded!.shapeFamily, isNull);
    expect(decoded.keycapShape, KeycapShape.rounded);
    expect(decoded.rgbEffect, RgbEffect.static);
    expect(decoded.switchType, isNull);
    expect(decoded.keycapColor, 12);
    expect(decoded.rgbEnabled, isTrue);
  });

  test('entries missing their identity are pruned, not stored half-formed', () {
    final decoded = KeyboardCustomizationDto.fromJson({
      'keyOverrides': [
        {'keyId': '', 'label': 'ghost'},
        {'keyId': '0.000,0.000', 'label': 'A'},
      ],
      'extraKeys': [
        {'id': '', 'label': 'ghost'},
        {'id': 'e1'},
      ],
      'remaps': [
        {'physicalKey': 'keyA', 'character': ''},
        {'physicalKey': '', 'character': 'x'},
        {'physicalKey': 'keyB', 'character': 'y'},
      ],
    }).toDomain();

    expect(decoded.keyOverrides, hasLength(1));
    expect(decoded.keyOverrides.single.label, 'A');
    expect(decoded.extraKeys, hasLength(1));
    expect(decoded.extraKeys.single.id, 'e1');
    expect(decoded.remaps, hasLength(1));
    expect(decoded.remaps.single.physicalKey, 'keyB');
  });

  test('missing optional collections default to empty, never null', () {
    final decoded = KeyboardCustomizationDto.fromJson(const {}).toDomain();

    expect(decoded.keyOverrides, isEmpty);
    expect(decoded.extraKeys, isEmpty);
    expect(decoded.remaps, isEmpty);
    expect(decoded.rgbEnabled, isFalse);
  });
}
