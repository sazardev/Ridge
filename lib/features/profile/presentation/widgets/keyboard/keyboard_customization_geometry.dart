import 'dart:math' as math;

import 'package:flutter/painting.dart' show Rect;

import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';

/// How far the auto-placed extra-key column sits from the board's right
/// edge, and how much vertical space separates stacked extra keys — in
/// key-units, chosen to read clearly as "outside the board" while keeping
/// the whole composition one connected visual.
const _extraKeyGap = 0.5;
const _extraKeyStackGap = 0.25;

/// How many rows a key column stacks before wrapping when the board has
/// no base geometry at all (`KeyboardShapeFamily.custom`) — roughly the
/// height of a 60% board, so a homemade macro pad grows into a sensible
/// block instead of one endless strip.
const _customBoardRows = 4.0;

/// Static US-QWERTY primary legends as they appear on curated/standard
/// caps, mapped to `PhysicalKeyId.name` — the bridge that lets a
/// functional remap visibly redirect a cap's legend without `profile`'s
/// domain importing `practice`'s enum. Keys with special/named legends
/// (modifiers, arrows, F-row) aren't remappable anyway, so they're absent.
const _legendToPhysicalKeyName = <String, String>{
  'A': 'keyA',
  'B': 'keyB',
  'C': 'keyC',
  'D': 'keyD',
  'E': 'keyE',
  'F': 'keyF',
  'G': 'keyG',
  'H': 'keyH',
  'I': 'keyI',
  'J': 'keyJ',
  'K': 'keyK',
  'L': 'keyL',
  'M': 'keyM',
  'N': 'keyN',
  'O': 'keyO',
  'P': 'keyP',
  'Q': 'keyQ',
  'R': 'keyR',
  'S': 'keyS',
  'T': 'keyT',
  'U': 'keyU',
  'V': 'keyV',
  'W': 'keyW',
  'X': 'keyX',
  'Y': 'keyY',
  'Z': 'keyZ',
  '0': 'digit0',
  '1': 'digit1',
  '2': 'digit2',
  '3': 'digit3',
  '4': 'digit4',
  '5': 'digit5',
  '6': 'digit6',
  '7': 'digit7',
  '8': 'digit8',
  '9': 'digit9',
  '-': 'minus',
  '=': 'equal',
  '[': 'bracketLeft',
  ']': 'bracketRight',
  r'\': 'backslash',
  ';': 'semicolon',
  "'": 'quote',
  '`': 'backquote',
  ',': 'comma',
  '.': 'period',
  '/': 'slash',
  '<': 'intlBackslash',
  'Space': 'space',
};

/// The `PhysicalKeyId.name` a printed cap legend represents (e.g. `'A'` →
/// `'keyA'`), or `null` for a legend that isn't a bare printable key
/// (modifiers, F-row, merged remap displays, ...). Used to let real
/// keystrokes light the cap that sits at their physical position.
String? physicalKeyNameForLegend(String legend) =>
    _legendToPhysicalKeyName[legend];

/// Merges a resolved base layout with the user's keyboard customization:
/// functional remaps redirect the matching cap legends, every
/// `keyOverrides` entry replaces that key's legends (winning over the
/// remap's display, since it's the explicit per-key choice), and
/// `extraKeys` are placed in an auto-positioned column to the right of
/// the board (stacking downward, wrapping to a new column when a key
/// would spill past the board's bottom edge). With no base geometry at
/// all — the "100% custom" board — the extras start from the origin and
/// stack into a macro-pad block.
///
/// Overrides address keys by physical position (`keyboardKeyIdFor`), never
/// by list index, so they keep working if a curated asset reorders or
/// gains keys. The result is what the renderer and the editor's tap
/// hit-testing both consume, so what the user edits is exactly what they
/// see.
List<KeyboardKeySpec> applyKeyboardCustomization({
  required List<KeyboardKeySpec> baseKeys,
  required KeyboardCustomization customization,
}) {
  if (baseKeys.isEmpty && customization.extraKeys.isEmpty) {
    return const <KeyboardKeySpec>[];
  }

  final overrides = {
    for (final override in customization.keyOverrides) override.keyId: override,
  };
  final remapsByName = {
    for (final remap in customization.remaps) remap.physicalKey: remap,
  };

  final customized = <KeyboardKeySpec>[
    for (final key in baseKeys) _customizeKey(key, overrides, remapsByName),
  ];

  if (customization.extraKeys.isEmpty) return customized;
  return [
    ...customized,
    ...placeExtraKeys(baseKeys: customized, extraKeys: customization.extraKeys),
  ];
}

KeyboardKeySpec _customizeKey(
  KeyboardKeySpec key,
  Map<String, KeyboardKeyLegendOverride> overrides,
  Map<String, KeyboardKeyRemap> remapsByName,
) {
  var label = key.label;
  var label2 = key.label2;
  final physicalName = label == null ? null : _legendToPhysicalKeyName[label];
  final remap = physicalName == null ? null : remapsByName[physicalName];
  if (remap != null) {
    // Show the redirected character as the primary legend, with what the
    // cap used to print (or its shifted form) above it — the "letters
    // rearranged" the user asked to see on the board itself.
    label2 = remap.shiftedCharacter ?? label2 ?? label;
    label = remap.character;
  }

  final override = overrides[keyboardKeyIdFor(key)];
  if (override != null) {
    label = override.label ?? label;
    label2 = override.label2 ?? label2;
  }
  if (identical(label, key.label) && identical(label2, key.label2)) return key;
  return key.copyWith(label: label, label2: label2);
}

/// Positions each of [extraKeys] as a fully-resolved [KeyboardKeySpec]
/// outside the board's right edge — a single continuous column per stack,
/// wrapping to a new column when the next key would pass [baseKeys]'
/// bottom edge (a board only one row tall still stacks downward). With no
/// [baseKeys], the stack starts from the origin and wraps every
/// [_customBoardRows] rows.
List<KeyboardKeySpec> placeExtraKeys({
  required List<KeyboardKeySpec> baseKeys,
  required List<KeyboardExtraKey> extraKeys,
}) {
  if (extraKeys.isEmpty) return const <KeyboardKeySpec>[];

  final bounds = baseKeys.isEmpty
      ? const Rect.fromLTWH(0, 0, 0, _customBoardRows)
      : contentBoundsOf(baseKeys);
  final wrapBottom = bounds.top + math.max(bounds.height, 1.0);

  final placed = <KeyboardKeySpec>[];
  var cursorX = bounds.right + _extraKeyGap;
  var cursorY = bounds.top;
  var columnWidth = 0.0;

  for (final extra in extraKeys) {
    if (cursorY > bounds.top && cursorY + extra.height > wrapBottom) {
      cursorX += columnWidth + _extraKeyGap;
      cursorY = bounds.top;
      columnWidth = 0.0;
    }
    columnWidth = math.max(columnWidth, extra.width);
    placed.add(
      KeyboardKeySpec(
        x: cursorX,
        y: cursorY,
        w: extra.width,
        h: extra.height,
        x2: 0,
        y2: 0,
        w2: extra.width,
        h2: extra.height,
        rotationAngle: 0,
        rotationX: cursorX,
        rotationY: cursorY,
        label: extra.label,
        label2: extra.label2,
      ),
    );
    cursorY += extra.height + _extraKeyStackGap;
  }
  return placed;
}
