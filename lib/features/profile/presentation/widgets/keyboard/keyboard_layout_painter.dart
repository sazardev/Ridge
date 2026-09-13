import 'dart:math' as math;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_typography.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_3d.dart';

/// Draws any [KeyboardKeySpec] list as a real-3D keyboard: the scene is
/// built as actual 3D geometry (case, recessed plate, tapered keycaps),
/// projected through a perspective camera orbited by
/// [yawDegrees]/[pitchDegrees], shaded per face against a fixed
/// directional light, and painted back-to-front (`buildKeyboardScene`
/// does the geometry and sorting; this class is only the Canvas sink).
///
/// Geometry comes entirely from [KeyboardCamera], which is also what the
/// interactive wrapper uses to un-project the pointer back onto the
/// keycap plane, so the painted keys and the clickable keys can never
/// disagree — under any camera angle.
class KeyboardLayoutPainter extends CustomPainter {
  /// Creates a painter for [keys] in [style], viewed from the given orbit
  /// angles, with optional hover/press state addressed by key index.
  const new({
    required this.keys,
    required this.style,
    this.yawDegrees = 0,
    this.pitchDegrees = 0,
    this.hoveredIndex,
    this.pressedIndex,
    this.pressProgress = 0,
    this.rgbPhase = 0,
    this.keyLightColors,
    this.keyPressLevels,
    this.keyPulses,
    this.rippleAges,
  });

  /// The keys to draw, in key-units.
  final List<KeyboardKeySpec> keys;

  /// Resolved colors, radii, and depth proportions.
  final KeyboardKeycapStyle style;

  /// Camera orbit around the vertical axis, in degrees.
  final double yawDegrees;

  /// Camera orbit around the horizontal axis, in degrees (positive tips
  /// the board's top edge away from the viewer).
  final double pitchDegrees;

  /// Index of the key under the pointer, if any.
  final int? hoveredIndex;

  /// Index of the key currently held down, if any.
  final int? pressedIndex;

  /// How far the pressed key has sunk, 0 (rest) to 1 (fully bottomed out).
  final double pressProgress;

  /// The repeating 0..1 phase of the RGB effect — drives breathing/rainbow
  /// when [KeyboardKeycapStyle.rgbEnabled], ignored otherwise.
  final double rgbPhase;

  /// Per-key backlight colors (ARGB) indexed like [keys]; a `null` entry
  /// means "use the board-wide light color for this key".
  final List<int?>? keyLightColors;

  /// Per-key press levels (0..1) from an external source (the real
  /// keyboard) indexed like [keys] — merged with the pointer's own press
  /// when building the scene.
  final List<double>? keyPressLevels;

  /// Per-key reactive flashes (0..1, decaying) indexed like [keys] — the
  /// click/keystroke light burst.
  final List<double>? keyPulses;

  /// Active ripple ages (seconds), indexed by origin key — the expanding
  /// "splash" of `RgbEffect.ripple`.
  final List<double>? rippleAges;

  @override
  void paint(Canvas canvas, Size size) {
    if (keys.isEmpty) return;

    final camera = KeyboardCamera.fit(
      keys: keys,
      size: size,
      depthFraction: style.caseDepthFraction,
      topFraction: keyTopZFor(style),
      yawDegrees: yawDegrees,
      pitchDegrees: pitchDegrees,
    );
    final faces = buildKeyboardScene(
      keys: keys,
      style: style,
      camera: camera,
      hoveredIndex: hoveredIndex,
      pressedIndex: pressedIndex,
      pressProgress: pressProgress,
      rgbPhase: rgbPhase,
      keyLightColors: keyLightColors,
      keyPressLevels: keyPressLevels,
      keyPulses: keyPulses,
      rippleAges: rippleAges,
    );

    final fill = Paint();
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final glow = Paint()..blendMode = BlendMode.plus;
    for (final face in faces) {
      if (face.points.length < 3) continue;
      final path = Path()..moveTo(face.points.first.dx, face.points.first.dy);
      for (final point in face.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      path.close();

      fill
        ..shader = face.gradient?.createShader(path.getBounds())
        ..color = face.color;
      canvas.drawPath(path, fill);

      final glowColor = face.glowColor;
      if (glowColor != null) {
        glow.shader = RadialGradient(
          colors: [glowColor, glowColor.withValues(alpha: 0)],
          stops: const [0, 0.9],
        ).createShader(path.getBounds());
        canvas.drawPath(path, glow);
      }

      final strokeColor = face.strokeColor;
      if (strokeColor != null) {
        stroke
          ..color = strokeColor
          ..strokeWidth = face.strokeWidth;
      } else {
        // Seals the hairline antialiasing cracks between the adjacent
        // side quads of one extrusion, which would otherwise show the
        // background through the shared edges.
        stroke
          ..color = face.color
          ..strokeWidth = 0.5;
      }
      canvas.drawPath(path, stroke);

      final legend = face.legend;
      if (legend != null) _paintLegend(canvas, camera, legend);
    }
  }

  /// Paints [legend] onto its cap's top plane by transforming the canvas
  /// with the very same camera that built the scene — so the text lies
  /// flat on the keycap with true perspective instead of being scaled
  /// flat. Layouts are cached (they only depend on text + style, never on
  /// the camera), and glyph rasterization happens at the composed
  /// device scale, so legends stay crisp at any zoom.
  void _paintLegend(
    Canvas canvas,
    KeyboardCamera camera,
    KeyboardLegend legend,
  ) {
    final primary = legend.primary;
    final secondary = legend.secondary;
    if (primary == null && secondary == null) return;

    canvas
      ..save()
      ..transform(camera.canvasMatrix.storage)
      ..translate(legend.position.x, legend.position.y);
    if (primary != null && secondary != null) {
      _paintLegendLine(
        canvas,
        secondary,
        -legend.lineOffset,
        legend.secondaryFontSize,
        legend.maxWidth,
        legend.color,
      );
      _paintLegendLine(
        canvas,
        primary,
        legend.lineOffset,
        legend.primaryFontSize,
        legend.maxWidth,
        legend.color,
      );
    } else {
      final text = primary ?? secondary!;
      _paintLegendLine(
        canvas,
        text,
        0,
        primary != null ? legend.primaryFontSize : legend.secondaryFontSize,
        legend.maxWidth,
        legend.color,
      );
    }
    canvas.restore();
  }

  void _paintLegendLine(
    Canvas canvas,
    String text,
    double dy,
    double size,
    double maxWidth,
    Color color,
  ) {
    final entry = _legendEntry(text, color);
    final painter = entry.painter;
    // Auto-fit: never let a long legend spill past its cap.
    final fitted = maxWidth <= 0
        ? size
        : math.min(size, maxWidth / painter.width);
    canvas
      ..save()
      ..translate(0, dy)
      ..scale(fitted);
    // `-entry.capCenter` instead of `-painter.height / 2`: centring the
    // full line box (descender included) leaves caps/digits a hair high;
    // this centres the glyphs themselves.
    painter.paint(canvas, Offset(-painter.width / 2, -entry.capCenter));
    canvas.restore();
  }

  /// Geist Mono's cap height, as a fraction of the em — the glyphs that
  /// make up keycap legends (letters, digits, symbols) all sit between
  /// the baseline and this height.
  static const _capHeightFraction = 0.7;

  /// One cached paragraph per (text, ink) pair, laid out at font-size 1
  /// so a board-unit size can scale it at paint time, plus the vertical
  /// distance from the line box's top to the caps' optical centre.
  static final Map<(String, Color), _LegendEntry> _legendCache = {};

  static _LegendEntry _legendEntry(String text, Color color) =>
      _legendCache.putIfAbsent((text, color), () {
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontFamily: AppFonts.mono,
              fontWeight: FontWeight.w500,
              fontSize: 1,
              height: 1,
              color: color,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final ascent = painter.computeLineMetrics().first.ascent;
        return _LegendEntry(
          painter: painter,
          capCenter: ascent - _capHeightFraction / 2,
        );
      });

  @override
  bool shouldRepaint(covariant KeyboardLayoutPainter oldDelegate) =>
      !listEquals(keys, oldDelegate.keys) ||
      style != oldDelegate.style ||
      yawDegrees != oldDelegate.yawDegrees ||
      pitchDegrees != oldDelegate.pitchDegrees ||
      hoveredIndex != oldDelegate.hoveredIndex ||
      pressedIndex != oldDelegate.pressedIndex ||
      pressProgress != oldDelegate.pressProgress ||
      rgbPhase != oldDelegate.rgbPhase ||
      !listEquals(keyLightColors, oldDelegate.keyLightColors) ||
      !listEquals(keyPressLevels, oldDelegate.keyPressLevels) ||
      !listEquals(keyPulses, oldDelegate.keyPulses) ||
      !listEquals(rippleAges, oldDelegate.rippleAges);
}

/// A cached legend layout plus its glyph-centre metric.
class _LegendEntry {
  const new({required this.painter, required this.capCenter});

  final TextPainter painter;
  final double capCenter;
}
