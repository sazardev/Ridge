import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_faces.dart';

/// How much a keycap's top face is inset from its base outline, as a
/// fraction of one key-unit — the classic tapered keycap silhouette.
const keycapTaperFraction = 0.075;

/// How far the plate sits below the case's top face, in key-units.
const plateRecessFraction = 0.06;

/// Upper bounds for the theme's px corner radii once converted to
/// key-units: without them a small screen (small unit) turns keycaps
/// into pill shapes and the case into a stadium, because the px radius
/// stays constant while everything else shrinks.
const maxKeyCornerFraction = 0.09;

/// The case's own version of [maxKeyCornerFraction] — a longer curve can
/// safely round more before the chassis reads as a stadium.
const maxCaseCornerFraction = 0.22;

/// The tiny corner radius that reads as "sharp square" while still
/// producing a positive-radius outline — `roundedRectOutline` falls back
/// to a 4-point outline at 0, which would no longer align with the
/// 12-point rounded outlines it must correspond to index-by-index.
const squareCornerUnits = 0.015;

/// Outline segments per corner when [KeycapShape.round] turns each corner
/// into a quarter of the cap's circle — twice the default so the top face
/// reads as a circle rather than a dodecagon.
const roundCornerSegments = 6;

/// The case's corner radius under the theme px radius, capped to a
/// size-independent fraction.
double caseCornerUnits(KeyboardKeycapStyle style, KeyboardCamera camera) =>
    (style.caseCornerRadius / camera.unit).clamp(0.0, maxCaseCornerFraction);

/// The plate's corner radius — a slightly tighter version of the case's.
double plateCornerUnits(KeyboardKeycapStyle style, KeyboardCamera camera) =>
    caseCornerUnits(style, camera) * 0.7;

/// The corner radius of a keycap's *base* outline under the style's
/// [KeycapShape]: a tiny near-square corner, the full half-width for a
/// circular cap, or the theme radius converted to key-units (capped so a
/// small screen doesn't balloon it).
double keyBaseCornerUnits(
  KeyboardKeycapStyle style,
  Rect rect,
  KeyboardCamera camera,
) => switch (style.keycapShape) {
  KeycapShape.square => squareCornerUnits,
  KeycapShape.round => math.min(rect.width, rect.height) / 2,
  KeycapShape.rounded => (style.keyCornerRadius / camera.unit).clamp(
    0.0,
    maxKeyCornerFraction,
  ),
};

/// The corner radius of a keycap's *top* outline, matching the base's
/// shape at the tapered top rectangle's own size.
double keyTopCornerUnits(
  KeyboardKeycapStyle style,
  double baseCornerUnits,
  Rect topRect,
) => switch (style.keycapShape) {
  KeycapShape.square => squareCornerUnits,
  KeycapShape.round => math.min(topRect.width, topRect.height) / 2,
  // Keep a strictly positive radius: `roundedRectOutline` falls back to
  // a 4-point outline at radius 0, which would no longer match the base
  // outline's segment count.
  KeycapShape.rounded => math.max(
    0.001,
    baseCornerUnits - keycapTaperFraction * 0.35,
  ),
};

/// Lambert-ish shading against the fixed viewer light, with a wrap term
/// so faces turned fully away from the light stay readable instead of
/// black. The resting top-face intensity is the zero point, so the
/// designed keycap colors survive at rest (STACK.md §2.5, contrast test).
Color shadeFace(Color base, Vec3 boardNormal, KeyboardCamera camera) {
  final normal = camera.rotate(boardNormal);
  final intensity = _intensity(normal);
  return KeyboardKeycapStyle.shiftLightness(
    base,
    (intensity - _restingTopIntensity) * 0.45,
  );
}

double _intensity(Vec3 cameraNormal) =>
    0.45 + 0.55 * (0.5 + 0.5 * _lightDirection.dot(cameraNormal));

/// The direction the scene's single directional light comes from, fixed
/// to the viewer — so faces genuinely change brightness as the board
/// orbits under it.
final Vec3 _lightDirection = const Vec3(-0.35, -0.45, 0.82).normalized();

final double _restingTopIntensity = _intensity(const Vec3(0, 0, 1));

/// The board-wide baseline backlight intensity for this frame — per-key
/// variation (wave/aurora/stars/rain/ripples) is layered on top by
/// `keyboard_scene_effects.dart`.
double rgbIntensity(KeyboardKeycapStyle style, double phase) {
  switch (style.rgbEffect) {
    case RgbEffect.static:
    case RgbEffect.rainbow:
    case RgbEffect.colorCycle:
    case RgbEffect.wave:
    case RgbEffect.aurora:
    case RgbEffect.stars:
    case RgbEffect.rain:
    case RgbEffect.gradient:
      return 1;
    case RgbEffect.reactive:
      return 0.35;
    case RgbEffect.ripple:
      return 0.30;
    case RgbEffect.breathing:
      return 0.30 + 0.70 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi));
  }
}

/// The backlight color for [key] this frame. Per-effect: the configured
/// color for the plain effects, a hue sweep for rainbow/color-cycle/aurora
/// (offset by the key's horizontal position where applicable), a
/// vertical two-tone blend for gradient, and a whitened base for stars.
/// [key] `null` means "the board as a whole" (plate/glow), which samples
/// the board's centre.
Color rgbTint(
  KeyboardKeycapStyle style,
  double phase,
  KeyboardKeySpec? key,
  KeyboardCamera camera,
) {
  final base = Color(style.rgbColor);
  final width = camera.caseRect.width;
  final x = key == null ? camera.caseRect.center.dx : key.x + key.w / 2;
  final height = camera.caseRect.height;
  final y = key == null ? camera.caseRect.center.dy : key.y + key.h / 2;
  final t = width <= 0
      ? 0.5
      : ((x - camera.caseRect.left) / width).clamp(0.0, 1.0);
  final v = height <= 0
      ? 0.5
      : ((y - camera.caseRect.top) / height).clamp(0.0, 1.0);
  final baseHue = HSVColor.fromColor(base).hue;

  return switch (style.rgbEffect) {
    RgbEffect.rainbow => HSVColor.fromAHSV(
      1,
      ((phase + t) % 1) * 360,
      0.75,
      1,
    ).toColor(),
    RgbEffect.colorCycle => HSVColor.fromAHSV(
      1,
      (phase % 1) * 360,
      0.75,
      1,
    ).toColor(),
    RgbEffect.aurora => HSVColor.fromAHSV(
      1,
      (baseHue + t * 90 + phase * 140) % 360,
      0.55,
      1,
    ).toColor(),
    RgbEffect.gradient => HSVColor.fromAHSV(
      1,
      (baseHue + v * 60) % 360,
      0.65,
      1,
    ).toColor(),
    RgbEffect.stars => Color.lerp(base, const Color(0xFFFFFFFF), 0.35)!,
    _ => base,
  };
}

/// The soft ambient halo around the board when RGB is on — a radial
/// gradient from the light color to transparent, projected just under the
/// case's bottom plane and painted before every solid face, so it reads
/// as light bleeding out from beneath the keyboard.
List<KeyboardFace> rgbGlowFaces(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
  double phase,
) {
  final tint = rgbTint(style, phase, null, camera);
  final intensity = rgbIntensity(style, phase);
  final rect = camera.caseRect.inflate(0.55);
  final outline = roundedRectOutline(
    rect,
    maxCaseCornerFraction + 0.2,
    segmentsPerCorner: 4,
  );
  if (outline.isEmpty) return const [];
  return [
    KeyboardFace(
      points: [
        for (final point in outline)
          camera.project(Vec3(point.dx, point.dy, -style.caseDepthFraction)),
      ],
      depth:
          camera.depthOf(
            Vec3(rect.center.dx, rect.center.dy, -style.caseDepthFraction),
          ) +
          999,
      color: tint.withValues(alpha: 0),
      gradient: RadialGradient(
        colors: [
          tint.withValues(alpha: 0.42 * intensity),
          tint.withValues(alpha: 0),
        ],
        stops: const [0.45, 1],
      ),
    ),
  ];
}
