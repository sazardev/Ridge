import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridge/core/theme/app_motion.dart';

/// Branch container for the shell's `StatefulShellRoute`: keeps every
/// branch alive like `indexedStack`, but replays a springy fade/rise/scale
/// entrance on the branch that just became active, so switching tabs feels
/// like the destination lands rather than snaps.
class AnimatedBranchContainer extends StatelessWidget {
  /// Creates the container for [children], showing [currentIndex].
  const new({required this.currentIndex, required this.children, super.key});

  /// Index of the visible branch.
  final int currentIndex;

  /// The branch navigators, in branch order.
  final List<Widget> children;

  /// Adapter for the shell route's `navigatorContainerBuilder`.
  static Widget builder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => AnimatedBranchContainer(
    currentIndex: navigationShell.currentIndex,
    children: children,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < children.length; i++)
          _BranchEntrance(active: i == currentIndex, child: children[i]),
      ],
    );
  }
}

class _BranchEntrance extends StatefulWidget {
  const new({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_BranchEntrance> createState() => _BranchEntranceState();
}

class _BranchEntranceState extends State<_BranchEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.spatialSlow,
    value: widget.active ? 1 : 0,
  );
  late final CurvedAnimation _spring = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.gentle,
  );
  late final CurvedAnimation _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.5, curve: Curves.easeOut),
  );

  @override
  void didUpdateWidget(_BranchEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active == oldWidget.active) return;
    if (!widget.active) {
      _controller.value = 0;
    } else if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _spring.dispose();
    _fade.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.active,
      child: TickerMode(
        enabled: widget.active,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(_spring),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1).animate(_spring),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
