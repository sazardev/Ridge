import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Binds Escape to `Navigator.maybePop()` — a fixed, non-customizable
/// convention (unlike `AppNavigationShortcuts`' rebindable shortcuts):
/// closing with Escape is universal enough that reassigning it would add
/// indirection without real benefit. Mirrors the pattern
/// `snippet_info_screen.dart` already hand-rolled for itself; this is
/// the shared version for every other pushed/non-shell screen
/// (Achievements, Changelog, Edit Profile, Snippet Browser, ...) that
/// didn't have one yet.
class EscapeToPop extends StatelessWidget {
  /// Wraps [child] with Escape bound to popping the current route.
  const new({required this.child, super.key});

  /// The screen content Escape should close.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
      },
      child: child,
    );
  }
}
