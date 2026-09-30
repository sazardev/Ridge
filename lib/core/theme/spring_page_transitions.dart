import 'package:flutter/material.dart';
import 'package:ridge/core/theme/app_motion.dart';

/// Route transition with a springy settle: the incoming page fades in while
/// sliding a short way from the right and scaling up with a light
/// overshoot; the page underneath drifts left and dims slightly. No
/// intermediate solid box, so it never flashes a neutral fill over a vivid
/// palette.
class SpringPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Creates the builder.
  const new();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final incoming = CurvedAnimation(
      parent: animation,
      curve: AppMotion.gentle,
      reverseCurve: Curves.easeInCubic,
    );
    final outgoing = CurvedAnimation(
      parent: secondaryAnimation,
      curve: AppMotion.spatial,
      reverseCurve: Curves.easeInCubic,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.06, 0),
      ).animate(outgoing),
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0.6).animate(outgoing),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(incoming),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.5, curve: Curves.easeOut),
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1).animate(incoming),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
