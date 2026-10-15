import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wraps the capture field with its restrained reject shake — the
/// hard-lock equivalent of the wrong-PIN shake, so a rejected keystroke
/// reads as a clear physical "no". Extracted from
/// `KeystrokeCaptureField` for the file-size budget; the owner drives
/// [controller] with `forward(from: 0)` on every rejection.
class RejectShake extends StatelessWidget {
  /// Creates the shake wrapper around [child].
  const new({required this.controller, required this.child, super.key});

  /// The shake's animation driver (0 = at rest, 1 = finished).
  final AnimationController controller;

  /// The subtree to displace. Passed as `AnimatedBuilder.child` so the
  /// per-tick rebuilds never touch or remount it.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final t = controller.value;
        final decay = 1 - t;
        final dx = 6.0 * math.sin(t * 4 * math.pi) * decay;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}
