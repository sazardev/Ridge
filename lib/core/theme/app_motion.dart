import 'dart:math' as math;

import 'package:flutter/animation.dart';

/// Hand-tuned motion tokens approximating the Material 3 Expressive motion
/// system (spatial springs move things, effects springs fade/tint them).
/// Flutter's stable SDK doesn't expose `MotionScheme` yet, so these
/// durations/curves stand in for it. Spring tokens ([AppMotion.snappy],
/// [AppMotion.bouncy], [AppMotion.gentle]) overshoot for playful spatial
/// motion; effects motion stays a plain fade.
abstract final class AppMotion {
  // Spatial: position, size, shape morphing.

  /// Short spatial move — small on-screen displacements.
  static const spatialFast = Duration(milliseconds: 260);

  /// Default spatial move — most position/size/shape transitions.
  static const spatialDefault = Duration(milliseconds: 380);

  /// Long spatial move — large or emphasized transitions.
  static const spatialSlow = Duration(milliseconds: 520);

  // Effects: opacity, color, elevation-free tint changes.

  /// Short effects fade — quick opacity/tint changes.
  static const effectsFast = Duration(milliseconds: 120);

  /// Default effects fade — most opacity/color/tint changes.
  static const effectsDefault = Duration(milliseconds: 200);

  /// Long effects fade — slow, deliberate tint changes.
  static const effectsSlow = Duration(milliseconds: 300);

  /// Default curve for spatial (position/size/shape) motion. Bounded (no
  /// overshoot), so it's safe for scrolls and clamped controllers; use
  /// [snappy]/[bouncy]/[gentle] for implicit or `flutter_animate` motion
  /// that should spring.
  static const Curve spatial = Curves.easeInOutCubicEmphasized;

  /// Quick spring, light overshoot — general UI motion.
  static const Curve snappy = SpringCurve.snappy;

  /// Pronounced overshoot for taps, pops and celebratory entrances.
  static const Curve bouncy = SpringCurve.bouncy;

  /// Soft, slow settle for large surfaces (pages, sheets, cards).
  static const Curve gentle = SpringCurve.gentle;

  /// Tap-down press scale shared by every pressable surface.
  static const double pressedScale = 0.96;

  /// Animation style for modal bottom sheets — a slower, decelerating rise
  /// (bounded: sheet offsets can't take an overshooting curve).
  static const AnimationStyle sheet = AnimationStyle(
    duration: spatialSlow,
    reverseDuration: spatialFast,
    curve: Curves.easeOutQuart,
    reverseCurve: Curves.easeInCubic,
  );

  /// Animation style for dialogs — quick, decelerating scale-and-fade.
  static const AnimationStyle dialog = AnimationStyle(
    duration: spatialDefault,
    reverseDuration: effectsDefault,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  /// Delay between consecutive items of a staggered entrance.
  static const stagger = Duration(milliseconds: 45);

  /// Curve for something entering the screen.
  static const Curve enter = Curves.easeOutCubic;

  /// Curve for something leaving the screen.
  static const Curve exit = Curves.easeInCubic;

  /// Default curve for effects (opacity/color/tint) motion.
  static const Curve effects = Curves.easeOut;

  /// A restrained overshoot for the rare moment something should feel
  /// alive (e.g. a success checkmark) without tipping into playful.
  static const Curve emphasizedBounce = Cubic(0.18, 1.28, 0.34, 1);
}

/// Closed-form damped-spring easing curve. `t` is the usual 0..1 fraction
/// of whatever duration the caller picks, so this is a fixed-shape curve
/// with spring parameters, not a physics simulation.
///
/// Overshoots past 1.0, so use it with implicit animations,
/// `CurvedAnimation` or `flutter_animate` — never as the `curve:` of
/// `AnimationController.animateTo`, which clamps the overshoot away.
class SpringCurve extends Curve {
  /// Creates a spring curve from its physical parameters.
  const new({this.mass = 1, this.stiffness = 200, this.damping = 10})
    : assert(mass > 0, 'mass must be positive'),
      assert(stiffness > 0, 'stiffness must be positive'),
      assert(damping >= 0, 'damping must not be negative');

  /// Pronounced overshoot (~34%).
  static const bouncy = SpringCurve(mass: 0.5, stiffness: 300, damping: 8);

  /// Quick settle, light overshoot (~21%).
  static const snappy = SpringCurve(stiffness: 400, damping: 18);

  /// Slow settle, subtle overshoot (~11%).
  static const gentle = SpringCurve(mass: 2, stiffness: 150, damping: 20);

  /// Spring mass.
  final double mass;

  /// Spring stiffness.
  final double stiffness;

  /// Damping coefficient.
  final double damping;

  @override
  double transformInternal(double t) {
    final omegaN = math.sqrt(stiffness / mass);
    final zeta = damping / (2 * math.sqrt(stiffness * mass));
    final decay = math.exp(-zeta * omegaN * t);
    if (zeta >= 1) return 1 - decay * (1 + omegaN * t);
    final omegaD = omegaN * math.sqrt(1 - zeta * zeta);
    final osc =
        math.cos(omegaD * t) + (zeta * omegaN / omegaD) * math.sin(omegaD * t);
    return 1 - decay * osc;
  }
}
