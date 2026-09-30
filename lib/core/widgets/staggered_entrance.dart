import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ridge/core/theme/app_motion.dart';

/// Entrance animation helpers shared by every screen so lists and card
/// groups arrive with the same springy, staggered rhythm.
extension StaggeredEntrance on Widget {
  /// Fades and springs this widget up into place, delayed by
  /// [index] × [AppMotion.stagger] (capped so long lists don't crawl).
  /// No-op when the platform asks for reduced motion.
  Widget staggeredIn(BuildContext context, int index) {
    if (MediaQuery.disableAnimationsOf(context)) return this;
    final delay = AppMotion.stagger * index.clamp(0, 10);
    // Per-effect delays (not `animate(delay:)`) so the stagger lives on the
    // animation timeline and never leaves a pending `Timer` behind.
    return animate()
        .fadeIn(
          delay: delay,
          duration: AppMotion.effectsSlow,
          curve: AppMotion.effects,
        )
        .slideY(
          delay: delay,
          begin: 0.12,
          end: 0,
          duration: AppMotion.spatialSlow,
          curve: AppMotion.gentle,
        )
        .scaleXY(
          delay: delay,
          begin: 0.94,
          end: 1,
          duration: AppMotion.spatialSlow,
          curve: AppMotion.bouncy,
        );
  }

  /// Pops this widget in from nothing with a bouncy overshoot and a slight
  /// twist — for badges and other small "reward" surfaces. Delayed like
  /// [staggeredIn]. No-op when the platform asks for reduced motion.
  Widget poppedIn(BuildContext context, int index) {
    if (MediaQuery.disableAnimationsOf(context)) return this;
    final delay = AppMotion.stagger * index.clamp(0, 14);
    return animate()
        .fadeIn(
          delay: delay,
          duration: AppMotion.effectsDefault,
          curve: AppMotion.effects,
        )
        .scaleXY(
          delay: delay,
          begin: 0.4,
          end: 1,
          duration: AppMotion.spatialSlow,
          curve: AppMotion.bouncy,
        )
        .rotate(
          delay: delay,
          begin: -0.04,
          end: 0,
          duration: AppMotion.spatialSlow,
          curve: AppMotion.bouncy,
        );
  }
}

/// `AnimatedSwitcher.transitionBuilder` with a springy scale-and-fade: the
/// incoming child grows in with a light overshoot while its opacity stays
/// on the plain linear animation (opacity can't take an overshooting
/// curve). Pair with `switchInCurve: AppMotion.bouncy`-style curves only
/// through this builder, never through `FadeTransition` directly.
Widget springSwitcherTransition(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(
        begin: 0.92,
        end: 1,
      ).animate(CurvedAnimation(parent: animation, curve: AppMotion.bouncy)),
      child: child,
    ),
  );
}
