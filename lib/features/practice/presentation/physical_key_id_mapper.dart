import 'package:flutter/services.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

/// The one place Flutter's `PhysicalKeyboardKey` space gets translated
/// into our own domain [PhysicalKeyId] — the capture widget is the only
/// file allowed to import both, per the hexagon's Flutter boundary
/// (`tool/check_architecture.dart` hard-fails on a `package:flutter/`
/// import anywhere under `domain/`/`application/`).
final Map<PhysicalKeyboardKey, PhysicalKeyId> physicalKeyIdMap = {
  PhysicalKeyboardKey.keyA: PhysicalKeyId.keyA,
  PhysicalKeyboardKey.keyB: PhysicalKeyId.keyB,
  PhysicalKeyboardKey.keyC: PhysicalKeyId.keyC,
  PhysicalKeyboardKey.keyD: PhysicalKeyId.keyD,
  PhysicalKeyboardKey.keyE: PhysicalKeyId.keyE,
  PhysicalKeyboardKey.keyF: PhysicalKeyId.keyF,
  PhysicalKeyboardKey.keyG: PhysicalKeyId.keyG,
  PhysicalKeyboardKey.keyH: PhysicalKeyId.keyH,
  PhysicalKeyboardKey.keyI: PhysicalKeyId.keyI,
  PhysicalKeyboardKey.keyJ: PhysicalKeyId.keyJ,
  PhysicalKeyboardKey.keyK: PhysicalKeyId.keyK,
  PhysicalKeyboardKey.keyL: PhysicalKeyId.keyL,
  PhysicalKeyboardKey.keyM: PhysicalKeyId.keyM,
  PhysicalKeyboardKey.keyN: PhysicalKeyId.keyN,
  PhysicalKeyboardKey.keyO: PhysicalKeyId.keyO,
  PhysicalKeyboardKey.keyP: PhysicalKeyId.keyP,
  PhysicalKeyboardKey.keyQ: PhysicalKeyId.keyQ,
  PhysicalKeyboardKey.keyR: PhysicalKeyId.keyR,
  PhysicalKeyboardKey.keyS: PhysicalKeyId.keyS,
  PhysicalKeyboardKey.keyT: PhysicalKeyId.keyT,
  PhysicalKeyboardKey.keyU: PhysicalKeyId.keyU,
  PhysicalKeyboardKey.keyV: PhysicalKeyId.keyV,
  PhysicalKeyboardKey.keyW: PhysicalKeyId.keyW,
  PhysicalKeyboardKey.keyX: PhysicalKeyId.keyX,
  PhysicalKeyboardKey.keyY: PhysicalKeyId.keyY,
  PhysicalKeyboardKey.keyZ: PhysicalKeyId.keyZ,
  PhysicalKeyboardKey.digit0: PhysicalKeyId.digit0,
  PhysicalKeyboardKey.digit1: PhysicalKeyId.digit1,
  PhysicalKeyboardKey.digit2: PhysicalKeyId.digit2,
  PhysicalKeyboardKey.digit3: PhysicalKeyId.digit3,
  PhysicalKeyboardKey.digit4: PhysicalKeyId.digit4,
  PhysicalKeyboardKey.digit5: PhysicalKeyId.digit5,
  PhysicalKeyboardKey.digit6: PhysicalKeyId.digit6,
  PhysicalKeyboardKey.digit7: PhysicalKeyId.digit7,
  PhysicalKeyboardKey.digit8: PhysicalKeyId.digit8,
  PhysicalKeyboardKey.digit9: PhysicalKeyId.digit9,
  PhysicalKeyboardKey.minus: PhysicalKeyId.minus,
  PhysicalKeyboardKey.equal: PhysicalKeyId.equal,
  PhysicalKeyboardKey.bracketLeft: PhysicalKeyId.bracketLeft,
  PhysicalKeyboardKey.bracketRight: PhysicalKeyId.bracketRight,
  PhysicalKeyboardKey.backslash: PhysicalKeyId.backslash,
  PhysicalKeyboardKey.semicolon: PhysicalKeyId.semicolon,
  PhysicalKeyboardKey.quote: PhysicalKeyId.quote,
  PhysicalKeyboardKey.backquote: PhysicalKeyId.backquote,
  PhysicalKeyboardKey.comma: PhysicalKeyId.comma,
  PhysicalKeyboardKey.period: PhysicalKeyId.period,
  PhysicalKeyboardKey.slash: PhysicalKeyId.slash,
  // The ISO key between Left Shift and Z — every European ISO layout
  // (and US-International) has it; dropping it is exactly why `<`/`>`
  // silently did nothing on a Spanish keyboard.
  PhysicalKeyboardKey.intlBackslash: PhysicalKeyId.intlBackslash,
  PhysicalKeyboardKey.space: PhysicalKeyId.space,
  PhysicalKeyboardKey.backspace: PhysicalKeyId.backspace,
  PhysicalKeyboardKey.delete: PhysicalKeyId.delete,
  PhysicalKeyboardKey.arrowLeft: PhysicalKeyId.arrowLeft,
  PhysicalKeyboardKey.arrowRight: PhysicalKeyId.arrowRight,
  PhysicalKeyboardKey.shiftLeft: PhysicalKeyId.shiftLeft,
  PhysicalKeyboardKey.shiftRight: PhysicalKeyId.shiftRight,
  PhysicalKeyboardKey.tab: PhysicalKeyId.tab,
  PhysicalKeyboardKey.enter: PhysicalKeyId.enter,
  PhysicalKeyboardKey.numpadEnter: PhysicalKeyId.enter,
};

/// Unshifted/shifted character pair for every [PhysicalKeyId] that can
/// produce a printable character, used only as a fallback when the
/// platform doesn't populate [KeyEvent.character] for a key we otherwise
/// recognize.
final Map<PhysicalKeyId, (String, String)> _shiftPairs = {
  PhysicalKeyId.digit0: ('0', ')'),
  PhysicalKeyId.digit1: ('1', '!'),
  PhysicalKeyId.digit2: ('2', '@'),
  PhysicalKeyId.digit3: ('3', '#'),
  PhysicalKeyId.digit4: ('4', r'$'),
  PhysicalKeyId.digit5: ('5', '%'),
  PhysicalKeyId.digit6: ('6', '^'),
  PhysicalKeyId.digit7: ('7', '&'),
  PhysicalKeyId.digit8: ('8', '*'),
  PhysicalKeyId.digit9: ('9', '('),
  PhysicalKeyId.minus: ('-', '_'),
  PhysicalKeyId.equal: ('=', '+'),
  PhysicalKeyId.bracketLeft: ('[', '{'),
  PhysicalKeyId.bracketRight: (']', '}'),
  PhysicalKeyId.backslash: (r'\', '|'),
  PhysicalKeyId.semicolon: (';', ':'),
  PhysicalKeyId.quote: ("'", '"'),
  PhysicalKeyId.backquote: ('`', '~'),
  PhysicalKeyId.comma: (',', '<'),
  PhysicalKeyId.period: ('.', '>'),
  PhysicalKeyId.slash: ('/', '?'),
  // Spanish/Portuguese and US-International print `<`/`>` on this key;
  // the fallback is inherently US-ish, so it uses the pair the most
  // layouts agree on (German/French/UK print different characters here,
  // but those layouts reliably supply `KeyEvent.character` anyway).
  PhysicalKeyId.intlBackslash: ('<', '>'),
  PhysicalKeyId.space: (' ', ' '),
};

/// Resolves the [PhysicalKeyId] this Flutter [key] corresponds to, or
/// `null` for any key this app doesn't model (function keys, modifiers
/// other than Shift, etc. — never routed to the capture engine).
PhysicalKeyId? physicalKeyIdFor(PhysicalKeyboardKey key) =>
    physicalKeyIdMap[key];

/// A best-effort printable character for [id] under US-QWERTY, used only
/// when the platform didn't supply one via [KeyEvent.character] — letters
/// fall back to their upper/lowercase form based on [shiftPressed], and
/// symbol keys fall back to their shifted/unshifted pair.
String? fallbackCharFor(PhysicalKeyId id, {required bool shiftPressed}) {
  final pair = _shiftPairs[id];
  if (pair != null) return shiftPressed ? pair.$2 : pair.$1;

  final name = id.name;
  if (name.length == 4 && name.startsWith('key')) {
    final letter = name.substring(3);
    return shiftPressed ? letter.toUpperCase() : letter.toLowerCase();
  }
  return null;
}
