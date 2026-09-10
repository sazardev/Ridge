import 'package:ridge/features/practice/domain/entities/hand.dart';

/// The finger assigned to a key under standard touch-typing technique
/// (SPEC.md §4.1).
enum Finger {
  /// Left pinky.
  leftPinky,

  /// Left ring finger.
  leftRing,

  /// Left middle finger.
  leftMiddle,

  /// Left index finger.
  leftIndex,

  /// Right index finger.
  rightIndex,

  /// Right middle finger.
  rightMiddle,

  /// Right ring finger.
  rightRing,

  /// Right pinky.
  rightPinky,

  /// Either thumb (space bar).
  thumb;

  /// Which [Hand] this finger belongs to.
  ///
  /// Always derived from [Finger], never stored as its own field —
  /// storing it separately could let it silently drift out of sync with
  /// the finger it supposedly describes.
  Hand get hand => switch (this) {
    Finger.leftPinky ||
    Finger.leftRing ||
    Finger.leftMiddle ||
    Finger.leftIndex => Hand.left,
    Finger.rightIndex ||
    Finger.rightMiddle ||
    Finger.rightRing ||
    Finger.rightPinky => Hand.right,
    Finger.thumb => Hand.neutral,
  };
}
