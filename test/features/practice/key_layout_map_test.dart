// Regression guard for `KeyLayoutMap`: every character that appears in
// any seeded snippet in the bundled catalogs
// (`assets/content/snippets/go_v1.json`, `bash_v1.json`,
// `sql_v1.json`) must
// resolve to a real physical key (per a standalone, test-owned
// char->PhysicalKeyId table modeling standard US-QWERTY) that in turn
// has a `keyLayoutMap` entry. This is what makes adding a new snippet
// with an unsupported character a loud, immediate test failure instead
// of a silent capture-engine gap discovered later.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/domain/services/key_layout_map.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

/// Which physical key (unshifted) a character needs, under standard
/// US-QWERTY — independent of `lib/`'s own `physicalKeyIdMapper` (a
/// Flutter-boundary concern) so this test doesn't depend on the very
/// widget code it's meant to guard against regressing.
const Map<String, PhysicalKeyId> _charToPhysicalKeyId = {
  'a': PhysicalKeyId.keyA,
  'A': PhysicalKeyId.keyA,
  'b': PhysicalKeyId.keyB,
  'B': PhysicalKeyId.keyB,
  'c': PhysicalKeyId.keyC,
  'C': PhysicalKeyId.keyC,
  'd': PhysicalKeyId.keyD,
  'D': PhysicalKeyId.keyD,
  'e': PhysicalKeyId.keyE,
  'E': PhysicalKeyId.keyE,
  'f': PhysicalKeyId.keyF,
  'F': PhysicalKeyId.keyF,
  'g': PhysicalKeyId.keyG,
  'G': PhysicalKeyId.keyG,
  'h': PhysicalKeyId.keyH,
  'H': PhysicalKeyId.keyH,
  'i': PhysicalKeyId.keyI,
  'I': PhysicalKeyId.keyI,
  'j': PhysicalKeyId.keyJ,
  'J': PhysicalKeyId.keyJ,
  'k': PhysicalKeyId.keyK,
  'K': PhysicalKeyId.keyK,
  'l': PhysicalKeyId.keyL,
  'L': PhysicalKeyId.keyL,
  'm': PhysicalKeyId.keyM,
  'M': PhysicalKeyId.keyM,
  'n': PhysicalKeyId.keyN,
  'N': PhysicalKeyId.keyN,
  'o': PhysicalKeyId.keyO,
  'O': PhysicalKeyId.keyO,
  'p': PhysicalKeyId.keyP,
  'P': PhysicalKeyId.keyP,
  'q': PhysicalKeyId.keyQ,
  'Q': PhysicalKeyId.keyQ,
  'r': PhysicalKeyId.keyR,
  'R': PhysicalKeyId.keyR,
  's': PhysicalKeyId.keyS,
  'S': PhysicalKeyId.keyS,
  't': PhysicalKeyId.keyT,
  'T': PhysicalKeyId.keyT,
  'u': PhysicalKeyId.keyU,
  'U': PhysicalKeyId.keyU,
  'v': PhysicalKeyId.keyV,
  'V': PhysicalKeyId.keyV,
  'w': PhysicalKeyId.keyW,
  'W': PhysicalKeyId.keyW,
  'x': PhysicalKeyId.keyX,
  'X': PhysicalKeyId.keyX,
  'y': PhysicalKeyId.keyY,
  'Y': PhysicalKeyId.keyY,
  'z': PhysicalKeyId.keyZ,
  'Z': PhysicalKeyId.keyZ,
  '0': PhysicalKeyId.digit0,
  ')': PhysicalKeyId.digit0,
  '1': PhysicalKeyId.digit1,
  '!': PhysicalKeyId.digit1,
  '2': PhysicalKeyId.digit2,
  '@': PhysicalKeyId.digit2,
  '3': PhysicalKeyId.digit3,
  '#': PhysicalKeyId.digit3,
  '4': PhysicalKeyId.digit4,
  r'$': PhysicalKeyId.digit4,
  '5': PhysicalKeyId.digit5,
  '%': PhysicalKeyId.digit5,
  '6': PhysicalKeyId.digit6,
  '^': PhysicalKeyId.digit6,
  '7': PhysicalKeyId.digit7,
  '&': PhysicalKeyId.digit7,
  '8': PhysicalKeyId.digit8,
  '*': PhysicalKeyId.digit8,
  '9': PhysicalKeyId.digit9,
  '(': PhysicalKeyId.digit9,
  '-': PhysicalKeyId.minus,
  '_': PhysicalKeyId.minus,
  '=': PhysicalKeyId.equal,
  '+': PhysicalKeyId.equal,
  '[': PhysicalKeyId.bracketLeft,
  '{': PhysicalKeyId.bracketLeft,
  ']': PhysicalKeyId.bracketRight,
  '}': PhysicalKeyId.bracketRight,
  r'\': PhysicalKeyId.backslash,
  '|': PhysicalKeyId.backslash,
  ';': PhysicalKeyId.semicolon,
  ':': PhysicalKeyId.semicolon,
  "'": PhysicalKeyId.quote,
  '"': PhysicalKeyId.quote,
  '`': PhysicalKeyId.backquote,
  '~': PhysicalKeyId.backquote,
  ',': PhysicalKeyId.comma,
  '<': PhysicalKeyId.comma,
  '.': PhysicalKeyId.period,
  '>': PhysicalKeyId.period,
  '/': PhysicalKeyId.slash,
  '?': PhysicalKeyId.slash,
  ' ': PhysicalKeyId.space,
  '\t': PhysicalKeyId.tab,
  '\n': PhysicalKeyId.enter,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every character used by the seeded catalogs resolves to a '
      'PhysicalKeyId with a KeyLayoutMap entry', () async {
    const assetPaths = [
      'assets/content/snippets/go_v1.json',
      'assets/content/snippets/bash_v1.json',
      'assets/content/snippets/sql_v1.json',
      'assets/content/snippets/rust_v1.json',
    ];

    final distinctChars = <String>{};
    for (final assetPath in assetPaths) {
      final raw = await rootBundle.loadString(assetPath);
      final entries = jsonDecode(raw) as List<dynamic>;
      expect(entries, isNotEmpty);
      for (final entry in entries) {
        final code = (entry as Map<String, dynamic>)['code'] as String;
        distinctChars.addAll(code.split(''));
      }
    }
    expect(distinctChars, isNotEmpty);

    final unmapped = <String>{};
    final uncovered = <String>{};
    for (final char in distinctChars) {
      final physicalKeyId = _charToPhysicalKeyId[char];
      if (physicalKeyId == null) {
        unmapped.add(char);
        continue;
      }
      if (!keyLayoutMap.containsKey(physicalKeyId)) {
        uncovered.add(char);
      }
    }

    expect(
      unmapped,
      isEmpty,
      reason:
          'Characters with no known physical key at all: $unmapped. '
          "Extend PhysicalKeyId (and this test's char table) to cover "
          'them.',
    );
    expect(
      uncovered,
      isEmpty,
      reason:
          'Characters whose physical key has no KeyLayoutMap entry: '
          '$uncovered. Extend key_layout_map.dart.',
    );
  });

  test('keyLayoutMap has an entry for every PhysicalKeyId value', () {
    for (final id in PhysicalKeyId.values) {
      expect(
        keyLayoutMap.containsKey(id),
        isTrue,
        reason: '$id has no keyLayoutMap entry',
      );
    }
  });
}
