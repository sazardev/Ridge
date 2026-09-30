import 'package:flutter/material.dart';
import 'package:ridge/core/theme/app_motion.dart';

/// Press feedback for any tappable surface: scales [child] down on press
/// and springs it back past 1.0 on release. Wraps the child's own ink
/// (`InkWell`/`Card`), it does not replace it — the ripple still plays.
/// Skipped when the platform asks for reduced motion.
class BouncyTap extends StatefulWidget {
  /// Creates a press-scale wrapper around [child].
  const new({
    required this.child,
    required this.enabled,
    this.pressedScale = AppMotion.pressedScale,
    super.key,
  });

  /// The surface that scales.
  final Widget child;

  /// Whether the surface reacts to presses (`false` for disabled tiles).
  final bool enabled;

  /// Scale reached while pressed.
  final double pressedScale;

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.spatialFast,
  );
  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: AppMotion.bouncy,
  );
  late final Animation<double> _scale = _curved.drive(
    Tween<double>(begin: 1, end: widget.pressedScale),
  );

  void _set({required bool pressed}) {
    if (!widget.enabled) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    if (pressed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listener (not GestureDetector) so it observes the pointer without
    // joining the gesture arena — the child's own tap handling is untouched.
    return Listener(
      onPointerDown: (_) => _set(pressed: true),
      onPointerUp: (_) => _set(pressed: false),
      onPointerCancel: (_) => _set(pressed: false),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
