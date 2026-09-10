import 'package:ridge/features/practice/domain/entities/finger.dart'
    show Finger;

/// Which hand a [Finger] belongs to.
enum Hand {
  /// The left hand.
  left,

  /// The right hand.
  right,

  /// Neither hand in particular — the thumb, shared by both.
  neutral,
}
