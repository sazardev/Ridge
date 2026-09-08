import 'package:flutter/animation.dart';

/// Hand-tuned motion tokens approximating the Material 3 Expressive motion
/// system (spatial springs move things, effects springs fade/tint them).
/// Flutter's stable SDK doesn't expose `MotionScheme` yet, so these
/// durations/curves stand in for it — deliberately understated so motion
/// reads as elegant polish, not decoration.
abstract final class AppMotion {
  // Spatial: position, size, shape morphing.
  static const spatialFast = Duration(milliseconds: 260);
  static const spatialDefault = Duration(milliseconds: 380);
  static const spatialSlow = Duration(milliseconds: 520);

  // Effects: opacity, color, elevation-free tint changes.
  static const effectsFast = Duration(milliseconds: 120);
  static const effectsDefault = Duration(milliseconds: 200);
  static const effectsSlow = Duration(milliseconds: 300);

  static const Curve spatial = Curves.easeInOutCubicEmphasized;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve effects = Curves.easeOut;

  /// A restrained overshoot for the rare moment something should feel
  /// alive (e.g. a success checkmark) without tipping into playful.
  static const Curve emphasizedBounce = Cubic(0.18, 1.28, 0.34, 1);
}
