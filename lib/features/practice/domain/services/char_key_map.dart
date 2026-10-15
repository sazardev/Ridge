import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/hand.dart';
import 'package:ridge/features/practice/domain/services/key_layout_map.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

/// Every printable US-QWERTY character (both shift levels) mapped to the
/// physical key that prints it — the inverse of the capture path's
/// `fallbackCharFor`, kept pure and Flutter-free so `progression`'s
/// recommendation can score candidates by finger/hand before a session
/// ever runs (SPEC.md §4.2's per-finger profile used as curriculum
/// input). Letters include both cases: Shift never changes which key or
/// finger prints them.
const Map<String, PhysicalKeyId> charKeyMap = {
  // Letters (both cases — same physical key and finger).
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

  // Number row (shifted forms included).
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
  '0': PhysicalKeyId.digit0,
  ')': PhysicalKeyId.digit0,
  '-': PhysicalKeyId.minus,
  '_': PhysicalKeyId.minus,
  '=': PhysicalKeyId.equal,
  '+': PhysicalKeyId.equal,

  // Top row symbols.
  '`': PhysicalKeyId.backquote,
  '~': PhysicalKeyId.backquote,
  '[': PhysicalKeyId.bracketLeft,
  '{': PhysicalKeyId.bracketLeft,
  ']': PhysicalKeyId.bracketRight,
  '}': PhysicalKeyId.bracketRight,
  r'\': PhysicalKeyId.backslash,
  '|': PhysicalKeyId.backslash,

  // Home row symbols.
  ';': PhysicalKeyId.semicolon,
  ':': PhysicalKeyId.semicolon,
  "'": PhysicalKeyId.quote,
  '"': PhysicalKeyId.quote,
  ',': PhysicalKeyId.comma,
  '<': PhysicalKeyId.comma,
  '.': PhysicalKeyId.period,
  '>': PhysicalKeyId.period,
  '/': PhysicalKeyId.slash,
  '?': PhysicalKeyId.slash,

  // Space row.
  ' ': PhysicalKeyId.space,
};

/// The [PhysicalKeyId] [character] prints from, or `null` for anything
/// this map doesn't cover (non-printables, or layout-specific chars).
PhysicalKeyId? physicalKeyIdForChar(String character) => charKeyMap[character];

/// The finger that types [character] under standard US-QWERTY touch
/// typing, or `null` when unmapped.
Finger? fingerForChar(String character) {
  final key = charKeyMap[character];
  return key == null ? null : keyLayoutMap[key]?.finger;
}

/// Every printable character typed by [finger] (both shift levels).
Set<String> charactersForFinger(Finger finger) => {
  for (final character in charKeyMap.keys)
    if (fingerForChar(character) == finger) character,
};

/// Every printable character typed by [hand] — the union of its fingers;
/// the neutral (thumb) hand contributes nothing to either side.
Set<String> charactersForHand(Hand hand) => {
  for (final character in charKeyMap.keys)
    if (fingerForChar(character)?.hand == hand) character,
};
