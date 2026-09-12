import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';

/// Draws any [KeyboardKeySpec] list as a pseudo-3D keyboard silhouette —
/// the one rendering engine behind the profile's keyboard visual, whether
/// the specs came from a curated real-layout JSON file or from
/// `standard_family_key_specs.dart`'s generic fallback geometry.
///
/// The depth is a hand-rolled 2.5D trick, not real 3D: every keycap and
/// the case itself are drawn as a solid extrusion (a side/lip at
/// [KeyboardKeycapStyle.keySide] offset [KeyboardKeycapStyle]'s depth
/// downward) with a subtly shaded top face over it, VIA-style. Pressing a
/// key sinks its face by the full depth while the lip shrinks to nothing,
/// so the cap physically travels down into its own base.
///
/// Geometry comes entirely from [KeyboardLayoutTransform], which is also
/// what the interactive wrapper uses for pointer hit-testing, so the
/// painted keys and the clickable keys can never disagree.
class KeyboardLayoutPainter extends CustomPainter {
  /// Creates a painter for [keys] in [style], with optional hover/press
  /// state addressed by key index.
  const new({
    required this.keys,
    required this.style,
    this.hoveredIndex,
    this.pressedIndex,
    this.pressProgress = 0,
  });

  /// The keys to draw, in key-units.
  final List<KeyboardKeySpec> keys;

  /// Resolved colors, radii, and depth proportions.
  final KeyboardKeycapStyle style;

  /// Index of the key under the pointer, if any.
  final int? hoveredIndex;

  /// Index of the key currently held down, if any.
  final int? pressedIndex;

  /// How far the pressed key has travelled, 0 (rest) to 1 (fully sunk).
  final double pressProgress;

  @override
  void paint(Canvas canvas, Size size) {
    if (keys.isEmpty) return;

    final transform = KeyboardLayoutTransform.fit(
      keys: keys,
      size: size,
      depthFraction: style.caseDepthFraction,
    );
    _drawCase(canvas, transform);
    _drawPlate(canvas, transform);

    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      canvas.save();
      if (key.rotationAngle != 0) {
        final pivot = transform.pivotFor(key);
        canvas
          ..translate(pivot.dx, pivot.dy)
          ..rotate(key.rotationAngle * math.pi / 180)
          ..translate(-pivot.dx, -pivot.dy);
      }

      final progress = i == pressedIndex ? pressProgress : 0.0;
      final hovered = i == hoveredIndex;
      final accent = _isAccentKey(key);

      _drawKeycap(
        canvas,
        transform,
        key,
        accent: accent,
        hovered: hovered,
        pressProgress: progress,
      );
      // A second rectangle only exists for stepped keys (e.g. an ISO
      // Enter's L-shape) — the common case has it identical to the
      // primary rectangle, so skip the (invisible, overlapping) redraw.
      if (transform.hasSecondaryRect(key)) {
        _drawKeycap(
          canvas,
          transform,
          key,
          secondary: true,
          accent: accent,
          hovered: hovered,
          pressProgress: progress,
        );
      }
      canvas.restore();
    }
  }

  bool _isAccentKey(KeyboardKeySpec key) => key.w > 1.05 || key.h > 1.05;

  /// The outer case: a downward extrusion of [KeyboardKeycapStyle.caseSide]
  /// with the case top face over it, so the board reads as a slab rather
  /// than a flat outline.
  void _drawCase(Canvas canvas, KeyboardLayoutTransform transform) {
    final rect = transform.caseRect;
    final radius = Radius.circular(style.caseCornerRadius);
    final depth = transform.unit * style.caseDepthFraction;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(Offset(0, depth)), radius),
      Paint()..color = style.caseSide,
    );
    final top = RRect.fromRectAndRadius(rect, radius);
    canvas
      ..drawRRect(top, Paint()..color = style.caseTop)
      ..drawRRect(top, _stroke(style.caseBorder, 1.5));
  }

  /// The plate the keys sit on, inset from the case edge and darker than
  /// the case top, so it reads as a recessed well.
  void _drawPlate(Canvas canvas, KeyboardLayoutTransform transform) {
    final rect = transform.caseRect.deflate(
      transform.bezel * KeyboardLayoutTransform.plateInsetFraction,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(style.caseCornerRadius * 0.7),
    );
    canvas
      ..drawRRect(rrect, Paint()..color = style.plate)
      ..drawRRect(rrect, _stroke(style.caseBorder, 1));
  }

  /// One keycap — its extruded side first, then the shaded top face over
  /// it. [pressProgress] sinks the face by the full depth while collapsing
  /// the side to zero, so the key visibly travels down.
  void _drawKeycap(
    Canvas canvas,
    KeyboardLayoutTransform transform,
    KeyboardKeySpec key, {
    required bool accent,
    required bool hovered,
    required double pressProgress,
    bool secondary = false,
  }) {
    final rect = transform.rectFor(key, secondary: secondary);
    final depth = transform.unit * style.keyDepthFraction;
    final radius = Radius.circular(style.keyCornerRadius);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.shift(Offset(0, depth * (1 - pressProgress))),
        radius,
      ),
      Paint()..color = accent ? style.keySideAccent : style.keySide,
    );

    var top = accent ? style.keyTopAccent : style.keyTop;
    if (hovered) top = Color.lerp(top, style.hoverTint, 0.35)!;
    // Pressing darkens the face slightly, reinforcing the sink.
    if (pressProgress > 0) {
      top = Color.lerp(
        top,
        accent ? style.keySideAccent : style.keySide,
        0.25 * pressProgress,
      )!;
    }

    final face = rect.shift(Offset(0, depth * pressProgress));
    final rrect = RRect.fromRectAndRadius(face, radius);
    canvas
      ..drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              KeyboardKeycapStyle.shiftLightness(top, style.topLightnessDelta),
              KeyboardKeycapStyle.shiftLightness(
                top,
                -style.bottomLightnessDelta,
              ),
            ],
          ).createShader(face),
      )
      ..drawRRect(rrect, _stroke(style.keyBorder, 1));
  }

  Paint _stroke(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..color = color;

  @override
  bool shouldRepaint(covariant KeyboardLayoutPainter oldDelegate) =>
      !listEquals(keys, oldDelegate.keys) ||
      style != oldDelegate.style ||
      hoveredIndex != oldDelegate.hoveredIndex ||
      pressedIndex != oldDelegate.pressedIndex ||
      pressProgress != oldDelegate.pressProgress;
}
