import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_faces.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_shading.dart';

/// Reads a 0..1 effect level from a nullable, index-aligned list.
double levelAt(List<double>? levels, int index) =>
    (levels != null && index < levels.length)
    ? levels[index].clamp(0.0, 1.0)
    : 0.0;

double _fract(double value) => value - value.floorToDouble();

/// The per-key brightness multiplier of the current effect — the layer on
/// top of the board-wide [rgbIntensity]: the wave band, aurora's drifting
/// swells, stars' twinkles and rain's falling drops (everything else is
/// uniform).
double effectIntensity(
  KeyboardKeycapStyle style,
  double phase,
  KeyboardKeySpec key,
  KeyboardCamera camera,
) {
  final base = rgbIntensity(style, phase);
  final width = camera.caseRect.width;
  final height = camera.caseRect.height;
  final t = width <= 0
      ? 0.5
      : ((key.x + key.w / 2 - camera.caseRect.left) / width).clamp(0.0, 1.0);
  final v = height <= 0
      ? 0.5
      : ((key.y + key.h / 2 - camera.caseRect.top) / height).clamp(0.0, 1.0);

  switch (style.rgbEffect) {
    case RgbEffect.wave:
      return base * waveBoost(style, phase, key, camera);
    case RgbEffect.aurora:
      return base * (0.72 + 0.28 * math.sin(2 * math.pi * (phase + t * 1.15)));
    case RgbEffect.stars:
      final hash = _fract(
        math.sin(key.x * 12.9898 + key.y * 78.233) * 43758.5453,
      );
      final wave = math.sin((phase * 2 + hash) * 2 * math.pi);
      final spike = math.pow(math.max(0.0, wave), 3).toDouble();
      return base * (0.45 + 1.5 * spike);
    case RgbEffect.rain:
      final drop = (key.y + key.x * 0.35) / 4.5 + phase * 1.6;
      final band = math.exp(
        -math.pow((_fract(drop) - 0.5) * 8.0, 2).toDouble(),
      );
      return base * (0.30 + 1.7 * band);
    case RgbEffect.gradient:
      return base * (0.75 + 0.25 * v);
    case RgbEffect.static:
    case RgbEffect.breathing:
    case RgbEffect.rainbow:
    case RgbEffect.colorCycle:
    case RgbEffect.reactive:
    case RgbEffect.ripple:
      return base;
  }
}

/// The brightness multiplier `RgbEffect.wave` adds for [key] at [phase]:
/// a gaussian band of light travelling left→right across the board
/// (every other effect returns 1).
double waveBoost(
  KeyboardKeycapStyle style,
  double phase,
  KeyboardKeySpec key,
  KeyboardCamera camera,
) {
  if (style.rgbEffect != RgbEffect.wave) return 1;
  final width = camera.caseRect.width;
  if (width <= 0) return 1;
  final t = ((key.x + key.w / 2 - camera.caseRect.left) / width).clamp(
    0.0,
    1.0,
  );
  final band = math.exp(-math.pow((t - phase) * 5.0, 2).toDouble());
  return 1 + 2.2 * band;
}

/// How fast a ripple's ring expands, in key-units per second.
const rippleSpeedUnitsPerSecond = 7.0;

/// How long a ripple lives before it is dropped — the classic typewriter
/// splash's tail.
const rippleLifetimeSeconds = 1.4;

/// The "splash" brightness for the key at [index], given every active
/// ripple's age (seconds), indexed by its origin key — a key lights up
/// while the expanding ring crosses its distance from an origin. Multiple
/// concurrent ripples (fast typing) combine by their brightest hit.
double rippleBoost(
  List<KeyboardKeySpec> keys,
  int index,
  List<double>? rippleAges,
) {
  if (rippleAges == null || rippleAges.isEmpty || index >= keys.length) {
    return 0;
  }
  final key = keys[index];
  final cx = key.x + key.w / 2;
  final cy = key.y + key.h / 2;
  var boost = 0.0;
  for (var origin = 0; origin < rippleAges.length; origin++) {
    final age = rippleAges[origin];
    if (age <= 0) continue;
    if (origin >= keys.length) break;
    final originKey = keys[origin];
    final dx = cx - (originKey.x + originKey.w / 2);
    final dy = cy - (originKey.y + originKey.h / 2);
    final distance = math.sqrt(dx * dx + dy * dy);
    final ring = age * rippleSpeedUnitsPerSecond;
    final band = math.exp(-math.pow((ring - distance) * 1.8, 2).toDouble());
    final fade = (1 - age / rippleLifetimeSeconds).clamp(0.0, 1.0);
    boost = math.max(boost, band * fade);
  }
  return boost.clamp(0.0, 1.0);
}

/// One soft pool of light on the plate under each key that is lit — a key
/// with its own backlight color, a key mid-pulse or mid-ripple, or (in
/// reactive mode) a key currently held. Painted after the plate and before
/// every cap, so the caps sit on top of their own pool of light.
List<KeyboardFace> plateGlowFaces(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
  double phase,
  List<KeyboardKeySpec> keys,
  List<int?>? keyLightColors,
  List<double>? keyPressLevels,
  List<double>? keyPulses,
  List<double>? rippleAges,
) {
  final faces = <KeyboardFace>[];
  for (var i = 0; i < keys.length; i++) {
    final lightColor = keyLightColors != null && i < keyLightColors.length
        ? keyLightColors[i]
        : null;
    final pulse = levelAt(keyPulses, i);
    final held = levelAt(keyPressLevels, i);
    final ripple = rippleBoost(keys, i, rippleAges);
    final reactiveHeld = style.rgbEffect == RgbEffect.reactive && held > 0;
    if (lightColor == null && pulse <= 0 && ripple <= 0 && !reactiveHeld) {
      continue;
    }

    final key = keys[i];
    final tint = lightColor != null
        ? Color(lightColor)
        : rgbTint(style, phase, key, camera);
    var intensity = effectIntensity(style, phase, key, camera);
    if (reactiveHeld) intensity = math.max(intensity, held * 1.2);
    intensity = math.min(1.6, intensity + pulse + ripple);

    final rect = camera.rectFor(key).inflate(0.3);
    Offset rotate(Offset point) => key.rotationAngle == 0
        ? point
        : rotatePoint(
            point,
            Offset(key.rotationX, key.rotationY),
            key.rotationAngle,
          );
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];
    faces.add(
      KeyboardFace(
        points: [
          for (final corner in corners)
            camera.project(
              Vec3(
                rotate(corner).dx,
                rotate(corner).dy,
                -plateRecessFraction + 0.001,
              ),
            ),
        ],
        depth: camera.depthOf(
          Vec3(key.x + key.w / 2, key.y + key.h / 2, -plateRecessFraction),
        ),
        color: tint.withValues(alpha: 0),
        gradient: RadialGradient(
          colors: [
            tint.withValues(alpha: 0.50 * intensity.clamp(0.0, 1.0)),
            tint.withValues(alpha: 0),
          ],
          stops: const [0, 1],
        ),
      ),
    );
  }
  return faces;
}
