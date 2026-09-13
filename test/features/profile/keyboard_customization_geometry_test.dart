// Unit tests for the composition layer between a resolved base layout and
// the user's keyboard customization: per-key legend overrides addressed by
// physical position, and auto-placed extra keys.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_customization_geometry.dart';

KeyboardKeySpec _key(
  double x,
  double y, {
  double w = 1,
  double h = 1,
  String? label,
  String? label2,
}) => KeyboardKeySpec(
  x: x,
  y: y,
  w: w,
  h: h,
  x2: 0,
  y2: 0,
  w2: w,
  h2: h,
  rotationAngle: 0,
  rotationX: x,
  rotationY: y,
  label: label,
  label2: label2,
);

void main() {
  test('an override replaces the legends of the key at its exact position', () {
    final base = [_key(0, 0, label: 'A'), _key(1, 0, label: 'B', label2: '*')];

    final result = applyKeyboardCustomization(
      baseKeys: base,
      customization: const KeyboardCustomization(
        keyOverrides: [
          KeyboardKeyLegendOverride(keyId: '0.000,0.000', label: 'Ñ'),
          KeyboardKeyLegendOverride(keyId: '1.000,0.000', label2: '×'),
        ],
      ),
    );

    expect(result[0].label, 'Ñ');
    expect(result[1].label, 'B');
    // A field the override leaves empty keeps the curated legend.
    expect(result[1].label2, '×');
  });

  test('overrides never touch geometry or unmatched keys', () {
    final base = [_key(2, 3, w: 2, label: 'Shift')];

    final result = applyKeyboardCustomization(
      baseKeys: base,
      customization: const KeyboardCustomization(
        keyOverrides: [
          KeyboardKeyLegendOverride(keyId: '9.000,9.000', label: 'ghost'),
        ],
      ),
    );

    expect(result.single, base.single);
  });

  test('extra keys are placed in a column to the right of the board', () {
    final base = [_key(0, 0), _key(0, 1), _key(0, 2)];

    final result = applyKeyboardCustomization(
      baseKeys: base,
      customization: const KeyboardCustomization(
        extraKeys: [
          KeyboardExtraKey(id: 'e1', label: 'Macro'),
          KeyboardExtraKey(id: 'e2', label: 'Knob'),
        ],
      ),
    );

    expect(result, hasLength(5));
    final first = result[3];
    final second = result[4];
    // Right of the board's 3u-tall, 1u-wide footprint (gap = 0.5u).
    expect(first.x, 1.5);
    expect(first.y, 0);
    expect(first.label, 'Macro');
    expect(second.x, 1.5);
    expect(second.y, 1.25);
  });

  test('extra keys wrap to a new column when they pass the board bottom', () {
    final base = [_key(0, 0)];

    final result = placeExtraKeys(
      baseKeys: base,
      extraKeys: const [
        KeyboardExtraKey(id: 'e1'),
        KeyboardExtraKey(id: 'e2'),
      ],
    );

    expect(result, hasLength(2));
    expect(result[0].x, 1.5);
    expect(result[1].x, 3.0);
    expect(result[1].y, 0);
  });

  test('a wide extra key widens its own column before wrapping', () {
    final base = [_key(0, 0)];

    final result = placeExtraKeys(
      baseKeys: base,
      extraKeys: const [
        KeyboardExtraKey(id: 'e1', width: 2),
        KeyboardExtraKey(id: 'e2'),
      ],
    );

    // The wrap must clear the widest key placed in the first column.
    expect(result[1].x, 1.5 + 2 + 0.5);
  });

  test('no extras/overrides returns the base keys untouched', () {
    final base = [_key(0, 0, label: 'A')];

    final result = applyKeyboardCustomization(
      baseKeys: base,
      customization: KeyboardCustomization.empty,
    );

    expect(result, base);
  });

  test('an empty base layout renders nothing while there are no extras', () {
    final result = applyKeyboardCustomization(
      baseKeys: const [],
      customization: KeyboardCustomization.empty,
    );

    expect(result, isEmpty);
  });

  test('a 100% custom board builds the whole board from extra keys', () {
    final result = applyKeyboardCustomization(
      baseKeys: const [],
      customization: const KeyboardCustomization(
        shapeFamily: KeyboardShapeFamily.custom,
        extraKeys: [
          KeyboardExtraKey(id: 'e1', label: 'Esc'),
          KeyboardExtraKey(id: 'e2', label: '1'),
          KeyboardExtraKey(id: 'e3', label: '2'),
        ],
      ),
    );

    expect(result, hasLength(3));
    expect(result.map((key) => key.label), ['Esc', '1', '2']);
    // The block starts at the origin and stacks downward.
    expect(result[0].x, 0.5);
    expect(result[0].y, 0);
    expect(result[1].y, 1.25);
    expect(result[2].y, 2.5);
  });

  test('a functional remap redirects the matching cap legends', () {
    final base = [
      _key(0, 0, label: 'A'),
      _key(1, 0, label: 'B', label2: '*'),
      _key(2, 0, label: 'C'),
    ];

    final result = applyKeyboardCustomization(
      baseKeys: base,
      customization: const KeyboardCustomization(
        remaps: [
          KeyboardKeyRemap(
            physicalKey: 'keyA',
            character: 'q',
            shiftedCharacter: 'Q',
          ),
          KeyboardKeyRemap(physicalKey: 'keyB', character: 'z'),
        ],
      ),
    );

    // Remapped key: the new character on top, the old cap legend above.
    expect(result[0].label, 'q');
    expect(result[0].label2, 'Q');
    // A remap with no shifted form keeps the old shifted legend above.
    expect(result[1].label, 'z');
    expect(result[1].label2, '*');
    // Untouched keys stay as curated.
    expect(result[2].label, 'C');
  });

  test('an explicit legend override wins over the remap display', () {
    final base = [_key(0, 0, label: 'A')];

    final result = applyKeyboardCustomization(
      baseKeys: base,
      customization: const KeyboardCustomization(
        remaps: [KeyboardKeyRemap(physicalKey: 'keyA', character: 'q')],
        keyOverrides: [
          KeyboardKeyLegendOverride(keyId: '0.000,0.000', label: 'Ñ'),
        ],
      ),
    );

    expect(result.single.label, 'Ñ');
  });
}
