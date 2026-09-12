import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Computes the scroll offset that keeps [cursorIndex] comfortably in view
/// — a couple of lines of context above and below, clamped to the
/// viewport's own scrollable range — or `null` when the cursor is already
/// inside that margin and the viewport shouldn't move at all.
///
/// Shared by `KeystrokeCaptureField`'s auto-scroll so the widget file
/// itself stays within the project's 500-line limit; the caller owns the
/// `ScrollController` and the "did the cursor already move this build"
/// bookkeeping.
double? cursorScrollTarget({
  required TextSpan textSpan,
  required int cursorIndex,
  required double innerWidth,
  required ScrollPosition position,
}) {
  final painter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
    ..layout(maxWidth: innerWidth);
  final caretOffset = painter.getOffsetForCaret(
    TextPosition(offset: cursorIndex),
    Rect.zero,
  );
  final lineHeight = painter.preferredLineHeight;

  final viewportTop = position.pixels;
  final viewportBottom = viewportTop + position.viewportDimension;
  // 6 lines of context above/below the cursor — clamped to a fraction of
  // the viewport so a short viewport (a small window, or a result area
  // sharing the screen) can't make the margin exceed the space there is
  // to scroll within.
  final margin = math.min(lineHeight * 6, position.viewportDimension * 0.35);

  double? target;
  if (caretOffset.dy < viewportTop + margin) {
    target = caretOffset.dy - margin;
  } else if (caretOffset.dy + lineHeight > viewportBottom - margin) {
    target = caretOffset.dy + lineHeight - position.viewportDimension + margin;
  }
  if (target == null) return null;

  return target.clamp(position.minScrollExtent, position.maxScrollExtent);
}
