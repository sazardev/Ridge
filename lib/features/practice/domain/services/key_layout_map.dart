import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/practice/domain/entities/keyboard_row.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';

/// The finger and keyboard row a [PhysicalKeyId] resolves to under
/// standard-US-QWERTY touch typing.
typedef KeyLayoutEntry = ({Finger finger, KeyboardRow row});

/// The const standard-US-QWERTY touch-typing finger/row assignment for
/// every [PhysicalKeyId] this app knows about (SPEC.md §4.1). Shift
/// itself doesn't change which finger/row a key is assigned — Shift is
/// what lets that finger produce the shifted character on the same key.
const Map<PhysicalKeyId, KeyLayoutEntry> keyLayoutMap = {
  // Number row.
  PhysicalKeyId.backquote: (
    finger: Finger.leftPinky,
    row: KeyboardRow.numberRow,
  ),
  PhysicalKeyId.digit1: (finger: Finger.leftPinky, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit2: (finger: Finger.leftRing, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit3: (finger: Finger.leftMiddle, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit4: (finger: Finger.leftIndex, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit5: (finger: Finger.leftIndex, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit6: (finger: Finger.rightIndex, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit7: (finger: Finger.rightIndex, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit8: (
    finger: Finger.rightMiddle,
    row: KeyboardRow.numberRow,
  ),
  PhysicalKeyId.digit9: (finger: Finger.rightRing, row: KeyboardRow.numberRow),
  PhysicalKeyId.digit0: (finger: Finger.rightPinky, row: KeyboardRow.numberRow),
  PhysicalKeyId.minus: (finger: Finger.rightPinky, row: KeyboardRow.numberRow),
  PhysicalKeyId.equal: (finger: Finger.rightPinky, row: KeyboardRow.numberRow),
  PhysicalKeyId.backspace: (
    finger: Finger.rightPinky,
    row: KeyboardRow.numberRow,
  ),
  PhysicalKeyId.delete: (finger: Finger.rightPinky, row: KeyboardRow.numberRow),
  PhysicalKeyId.arrowLeft: (
    finger: Finger.rightPinky,
    row: KeyboardRow.numberRow,
  ),
  PhysicalKeyId.arrowRight: (
    finger: Finger.rightPinky,
    row: KeyboardRow.numberRow,
  ),

  // Top row.
  PhysicalKeyId.tab: (finger: Finger.leftPinky, row: KeyboardRow.topRow),
  PhysicalKeyId.keyQ: (finger: Finger.leftPinky, row: KeyboardRow.topRow),
  PhysicalKeyId.keyW: (finger: Finger.leftRing, row: KeyboardRow.topRow),
  PhysicalKeyId.keyE: (finger: Finger.leftMiddle, row: KeyboardRow.topRow),
  PhysicalKeyId.keyR: (finger: Finger.leftIndex, row: KeyboardRow.topRow),
  PhysicalKeyId.keyT: (finger: Finger.leftIndex, row: KeyboardRow.topRow),
  PhysicalKeyId.keyY: (finger: Finger.rightIndex, row: KeyboardRow.topRow),
  PhysicalKeyId.keyU: (finger: Finger.rightIndex, row: KeyboardRow.topRow),
  PhysicalKeyId.keyI: (finger: Finger.rightMiddle, row: KeyboardRow.topRow),
  PhysicalKeyId.keyO: (finger: Finger.rightRing, row: KeyboardRow.topRow),
  PhysicalKeyId.keyP: (finger: Finger.rightPinky, row: KeyboardRow.topRow),
  PhysicalKeyId.bracketLeft: (
    finger: Finger.rightPinky,
    row: KeyboardRow.topRow,
  ),
  PhysicalKeyId.bracketRight: (
    finger: Finger.rightPinky,
    row: KeyboardRow.topRow,
  ),
  PhysicalKeyId.backslash: (finger: Finger.rightPinky, row: KeyboardRow.topRow),

  // Home row.
  PhysicalKeyId.keyA: (finger: Finger.leftPinky, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyS: (finger: Finger.leftRing, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyD: (finger: Finger.leftMiddle, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyF: (finger: Finger.leftIndex, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyG: (finger: Finger.leftIndex, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyH: (finger: Finger.rightIndex, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyJ: (finger: Finger.rightIndex, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyK: (finger: Finger.rightMiddle, row: KeyboardRow.homeRow),
  PhysicalKeyId.keyL: (finger: Finger.rightRing, row: KeyboardRow.homeRow),
  PhysicalKeyId.semicolon: (
    finger: Finger.rightPinky,
    row: KeyboardRow.homeRow,
  ),
  PhysicalKeyId.quote: (finger: Finger.rightPinky, row: KeyboardRow.homeRow),
  PhysicalKeyId.enter: (finger: Finger.rightPinky, row: KeyboardRow.homeRow),

  // Bottom row.
  PhysicalKeyId.shiftLeft: (
    finger: Finger.leftPinky,
    row: KeyboardRow.bottomRow,
  ),
  PhysicalKeyId.keyZ: (finger: Finger.leftPinky, row: KeyboardRow.bottomRow),
  PhysicalKeyId.keyX: (finger: Finger.leftRing, row: KeyboardRow.bottomRow),
  PhysicalKeyId.keyC: (finger: Finger.leftMiddle, row: KeyboardRow.bottomRow),
  PhysicalKeyId.keyV: (finger: Finger.leftIndex, row: KeyboardRow.bottomRow),
  PhysicalKeyId.keyB: (finger: Finger.leftIndex, row: KeyboardRow.bottomRow),
  PhysicalKeyId.keyN: (finger: Finger.rightIndex, row: KeyboardRow.bottomRow),
  PhysicalKeyId.keyM: (finger: Finger.rightIndex, row: KeyboardRow.bottomRow),
  PhysicalKeyId.comma: (finger: Finger.rightMiddle, row: KeyboardRow.bottomRow),
  PhysicalKeyId.period: (finger: Finger.rightRing, row: KeyboardRow.bottomRow),
  PhysicalKeyId.slash: (finger: Finger.rightPinky, row: KeyboardRow.bottomRow),
  PhysicalKeyId.shiftRight: (
    finger: Finger.rightPinky,
    row: KeyboardRow.bottomRow,
  ),

  // Space row.
  PhysicalKeyId.space: (finger: Finger.thumb, row: KeyboardRow.spaceRow),
};
