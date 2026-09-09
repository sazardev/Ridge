import 'package:flutter/animation.dart';

/// Hand-tuned motion tokens approximating the Material 3 Expressive motion
/// system (spatial springs move things, effects springs fade/tint them).
/// Flutter's stable SDK doesn't expose `MotionScheme` yet, so these
/// durations/curves stand in for it — deliberately understated so motion
/// reads as elegant polish, not decoration.
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

  /// Default curve for spatial (position/size/shape) motion.
  static const Curve spatial = Curves.easeInOutCubicEmphasized;

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
