import 'package:flutter/material.dart';

/// A minimalist stand-in for a numeric "chars typed"/accuracy readout:
/// just how far into the snippet the cursor has advanced, with no
/// percentage label and no notion of errors — [progress] is expected to
/// already be the raw fraction typed (see `KeystrokeCaptureField`, which
/// derives it from `expectedCursor`, itself unaffected by rejected
/// keystrokes).
///
/// Rendered with no rounding of its own — `KeystrokeCaptureField`
/// overlays it flush against the bottom edge of the code card and clips
/// the pair together to the card's own shape, so it reads as that
/// shape's bottom border rather than a separately-cornered strip on top
/// of it.
class TypingProgressBar extends StatelessWidget {
  /// Creates the bar at the given [progress] (clamped 0.0–1.0 by the
  /// caller).
  const new({required this.progress, super.key});

  /// Fraction of the snippet typed so far, in `[0.0, 1.0]`.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LinearProgressIndicator(
      value: progress,
      minHeight: 6,
      backgroundColor: colors.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
    );
  }
}
