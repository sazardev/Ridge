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
    required this.accentKeyColor,
    required this.caseColor,
    required this.plateColor,
    required this.borderColor,
    required this.keyCornerRadius,
    required this.caseCornerRadius,
  });

  /// The keys to draw, in key-units.
  final List<KeyboardKeySpec> keys;

  /// Fill color for a standard 1u alpha keycap.
  final Color keyColor;

  /// Fill color for a non-alpha keycap (modifiers, spacebar, Enter, ...) —
  /// any key wider or taller than [_accentSizeThreshold] key-units, the
  /// same visual cue real keyboards use to set the alpha block apart from
  /// the surrounding modifier/function keys.
  final Color accentKeyColor;

  /// Fill color for the outer case/body.
  final Color caseColor;

  /// Fill color for the inner plate the keys sit on, inset from
  /// [caseColor]'s outer edge — a second flat tone (never a gradient/
  /// shadow, per the design system) that reads as the case's rim vs. its
  /// top plate.
  final Color plateColor;

  /// Stroke color for keycap, plate, and case outlines.
  final Color borderColor;

  /// Corner radius applied to every keycap.
  final double keyCornerRadius;

  /// Corner radius applied to the case/body.
  final double caseCornerRadius;

  /// The gap between adjacent keycaps, as a fraction of one key-unit.
  static const _keyGapFraction = 0.14;

  /// How far the case extends past the outermost keys on every side, as a
  /// fraction of one key-unit — the "bezel" that makes this read as a
  /// keyboard body rather than a loose grid of keycaps. Expressed relative
  /// to [_unitFor]'s key-unit (rather than a fixed logical-pixel value) so
  /// the proportions stay correct whether this paints a small inline
  /// preview or a large hero visual.
  static const _bezelFraction = 0.45;

  /// How far the inner plate is inset from the outer case edge, as a
  /// fraction of [_bezelFraction]'s bezel — the remainder reads as the
  /// case's outer rim.
  static const _plateInsetFraction = 0.55;

  /// A key wider or taller than this (in key-units) is drawn with
  /// [accentKeyColor] instead of [keyColor].
  static const _accentSizeThreshold = 1.05;

  /// The key-unit scale fitting [bounds] into [size], accounting for the
  /// proportional bezel on every side (see [_bezelFraction]).
  double _unitFor(Size size, Rect bounds) => math.min(
    size.width / (bounds.width + _bezelFraction * 2),
    size.height / (bounds.height + _bezelFraction * 2),
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (keys.isEmpty) return;

    final bounds = contentBoundsOf(keys);
    final unit = _unitFor(size, bounds);
    final bezel = unit * _bezelFraction;
    final gridWidth = unit * bounds.width;
    final gridHeight = unit * bounds.height;
    // The screen position of key-space origin (0, 0) — every key's
    // (x, y) maps to screen (originX + x * unit, originY + y * unit).
    final originX = (size.width - gridWidth) / 2 - bounds.left * unit;
    final originY = (size.height - gridHeight) / 2 - bounds.top * unit;

    final caseRect = Rect.fromLTWH(
      (size.width - gridWidth) / 2 - bezel,
      (size.height - gridHeight) / 2 - bezel,
      gridWidth + bezel * 2,
      gridHeight + bezel * 2,
    );
    _drawCase(canvas, caseRect);
    _drawPlate(canvas, caseRect.deflate(bezel * _plateInsetFraction));

    final keyFill = Paint()..color = keyColor;
    final accentFill = Paint()..color = accentKeyColor;
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

      final fill = _isAccentKey(key) ? accentFill : keyFill;
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

  bool _isAccentKey(KeyboardKeySpec key) =>
      key.w > _accentSizeThreshold || key.h > _accentSizeThreshold;

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

  void _drawPlate(Canvas canvas, Rect rect) {
    final fill = Paint()..color = plateColor;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = borderColor;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(caseCornerRadius * 0.7),
    );
    canvas
      ..drawRRect(rrect, fill)
      ..drawRRect(rrect, border);
  }

  @override
  bool shouldRepaint(covariant KeyboardLayoutPainter oldDelegate) =>
      !listEquals(keys, oldDelegate.keys) ||
      keyColor != oldDelegate.keyColor ||
      accentKeyColor != oldDelegate.accentKeyColor ||
      caseColor != oldDelegate.caseColor ||
      plateColor != oldDelegate.plateColor ||
      borderColor != oldDelegate.borderColor ||
      keyCornerRadius != oldDelegate.keyCornerRadius ||
      caseCornerRadius != oldDelegate.caseCornerRadius;
}
