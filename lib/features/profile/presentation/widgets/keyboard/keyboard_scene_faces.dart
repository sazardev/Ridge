import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart';

import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';

/// One flat, filled polygon of the keyboard scene, already projected to
/// screen space and shaded, ready to paint — the renderer's only drawing
/// primitive.
@immutable
class KeyboardFace {
  /// Creates a face from its projected [points] and resolved [color].
  const new({
    required this.points,
    required this.depth,
    required this.color,
    this.gradient,
    this.strokeColor,
    this.glowColor,
    this.strokeWidth = 1,
    this.legend,
  });

  /// The polygon's vertices, in screen space, in order.
  final List<Offset> points;

  /// Camera-space distance of the face's centre — faces are painted in
  /// descending order of this value (farthest first).
  final double depth;

  /// The flat fill, before [gradient] (when set).
  final Color color;

  /// Optional two-stop sheen for keycap tops — the one sanctioned
  /// gradient of the design system (STACK.md §2.5).
  final Gradient? gradient;

  /// Optional outline, drawn after the fill.
  final Color? strokeColor;

  /// Optional additive radial glow painted over the fill — the RGB
  /// backlight shining through a keycap. Painted with
  /// [BlendMode.plus] from the face's centre, so it reads as light rather
  /// than paint, and never as a shadow.
  final Color? glowColor;

  /// Outline stroke width in logical pixels.
  final double strokeWidth;

  /// Optional printed legend for keycap tops — painted after the fill,
  /// projected onto the cap's own top plane by the camera.
  final KeyboardLegend? legend;
}

/// A keycap's printed legend: up to two text rows (the shifted symbol
/// above the primary one, like a real `!` over `1`), positioned and sized
/// in board units and drawn by the painter through
/// [KeyboardCamera.canvasMatrix] so it lies flat on the cap in true
/// perspective.
@immutable
class KeyboardLegend {
  /// Creates a legend at [position] (the cap top's centre, board units).
  const new({
    required this.position,
    required this.maxWidth,
    required this.primaryFontSize,
    required this.secondaryFontSize,
    required this.lineOffset,
    required this.color,
    this.primary,
    this.secondary,
  });

  /// The main legend (centered, or below [secondary] when both exist).
  final String? primary;

  /// The shifted-symbol legend, drawn above [primary].
  final String? secondary;

  /// The cap top's centre in board space.
  final Vec3 position;

  /// How much room the legend has, in board units — longer labels are
  /// auto-shrunk to fit instead of spilling over neighbouring caps.
  final double maxWidth;

  /// Primary legend em-size, in board units.
  final double primaryFontSize;

  /// Secondary legend em-size, in board units.
  final double secondaryFontSize;

  /// Vertical distance from [position] to each legend row's centre, in
  /// board units — only used when both legends are present.
  final double lineOffset;

  /// Resolved ink color.
  final Color color;
}
