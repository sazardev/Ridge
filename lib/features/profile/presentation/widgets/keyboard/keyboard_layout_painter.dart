import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';

/// Draws any [KeyboardKeySpec] list as a keyboard silhouette — the one
/// rendering engine behind the profile's keyboard visual, whether the
/// specs came from a curated real-layout JSON file or from
/// `standard_family_key_specs.dart`'s generic fallback geometry. Fits
/// the whole layout's bounding box (after rotation, via
/// `keyboard_layout_geometry.dart`) into the given [Size], so callers
/// never need to know the layout's real physical scale.
class KeyboardLayoutPainter extends CustomPainter {
  /// Creates a painter for [keys], styled with the given colors/radii.
  new({
    required this.keys,
    required this.keyColor,
    required this.caseColor,
    required this.borderColor,
    required this.keyCornerRadius,
    required this.caseCornerRadius,
  });

  /// The keys to draw, in key-units.
  final List<KeyboardKeySpec> keys;

  /// Fill color for every keycap.
  final Color keyColor;

  /// Fill color for the surrounding case/body.
  final Color caseColor;

  /// Stroke color for both keycap and case outlines.
  final Color borderColor;

  /// Corner radius applied to every keycap.
  final double keyCornerRadius;

  /// Corner radius applied to the case/body.
  final double caseCornerRadius;

  /// The gap between adjacent keycaps, as a fraction of one key-unit.
  static const _keyGapFraction = 0.12;

  /// How far the case extends past the outermost keys on every side, in
  /// logical pixels — the "bezel" that makes this read as a keyboard body
  /// rather than a loose grid of keycaps.
  static const _bezel = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (keys.isEmpty) return;

    final bounds = contentBoundsOf(keys);
    final unit = math.min(
      (size.width - _bezel * 2) / bounds.width,
      (size.height - _bezel * 2) / bounds.height,
    );
    final gridWidth = unit * bounds.width;
    final gridHeight = unit * bounds.height;
    // The screen position of key-space origin (0, 0) — every key's
    // (x, y) maps to screen (originX + x * unit, originY + y * unit).
    final originX = (size.width - gridWidth) / 2 - bounds.left * unit;
    final originY = (size.height - gridHeight) / 2 - bounds.top * unit;

    _drawCase(
      canvas,
      Rect.fromLTWH(
        (size.width - gridWidth) / 2 - _bezel,
        (size.height - gridHeight) / 2 - _bezel,
        gridWidth + _bezel * 2,
        gridHeight + _bezel * 2,
      ),
    );

    final fill = Paint()..color = keyColor;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = borderColor;
    final gap = unit * _keyGapFraction;

    for (final key in keys) {
      canvas.save();
      if (key.rotationAngle != 0) {
        final pivot = Offset(
          originX + key.rotationX * unit,
          originY + key.rotationY * unit,
        );
        canvas
          ..translate(pivot.dx, pivot.dy)
          ..rotate(key.rotationAngle * math.pi / 180)
          ..translate(-pivot.dx, -pivot.dy);
      }

      _drawKeycap(
        canvas,
        fill,
        border,
        Rect.fromLTWH(
          originX + key.x * unit + gap / 2,
          originY + key.y * unit + gap / 2,
          key.w * unit - gap,
          key.h * unit - gap,
        ),
      );
      // A second rectangle only exists for stepped keys (e.g. an ISO
      // Enter's L-shape) — the common case has it identical to the
      // primary rectangle, so skip the (invisible, overlapping) redraw.
      if (key.x2 != 0 || key.y2 != 0 || key.w2 != key.w || key.h2 != key.h) {
        _drawKeycap(
          canvas,
          fill,
          border,
          Rect.fromLTWH(
            originX + (key.x + key.x2) * unit + gap / 2,
            originY + (key.y + key.y2) * unit + gap / 2,
            key.w2 * unit - gap,
            key.h2 * unit - gap,
          ),
        );
      }
      canvas.restore();
    }
  }

  void _drawKeycap(Canvas canvas, Paint fill, Paint border, Rect rect) {
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(keyCornerRadius),
    );
    canvas
      ..drawRRect(rrect, fill)
      ..drawRRect(rrect, border);
  }

  void _drawCase(Canvas canvas, Rect rect) {
    final fill = Paint()..color = caseColor;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = borderColor;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(caseCornerRadius),
    );
    canvas
      ..drawRRect(rrect, fill)
      ..drawRRect(rrect, border);
  }

  @override
  bool shouldRepaint(covariant KeyboardLayoutPainter oldDelegate) =>
      !listEquals(keys, oldDelegate.keys) ||
      keyColor != oldDelegate.keyColor ||
      caseColor != oldDelegate.caseColor ||
      borderColor != oldDelegate.borderColor ||
      keyCornerRadius != oldDelegate.keyCornerRadius ||
      caseCornerRadius != oldDelegate.caseCornerRadius;
}
