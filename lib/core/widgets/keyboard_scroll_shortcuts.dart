import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ridge/core/theme/app_motion.dart';

/// Adds Home/End/PageUp/PageDown keyboard scrolling to [child] — a
/// [Scrollable] must live somewhere below it (a `ListView`/`GridView`/
/// `SingleChildScrollView`, ...) using [controller].
///
/// Flutter's own default shortcuts (`WidgetsApp`) bind PageUp/PageDown to
/// `ScrollIntent`, but never bind Home/End to anything, so a bare
/// scrollable is only ever reachable a screenful at a time and can never
/// jump straight to its start/end. This fills both gaps for every
/// keyboard-first list/grid screen in the app (STACK.md §2.5).
///
/// Claims focus for itself on first build (same reasoning as
/// `SnippetInfoScreen`'s own `Focus(autofocus: true)` — see that class'
/// doc) so the keys work the instant a screen opens, without the user
/// needing to `Tab` into it first. Pass `autofocus: false` when [child]
/// already autofocuses a more specific descendant (e.g. a search
/// field) — the shortcuts still reach this widget by bubbling, once
/// that descendant ignores a key it doesn't itself handle.
class KeyboardScrollShortcuts extends StatelessWidget {
  /// Wraps [child] with Home/End/PageUp/PageDown bound to [controller].
  const new({
    required this.controller,
    required this.child,
    this.autofocus = true,
    super.key,
  });

  /// The controller attached to the [Scrollable] living inside [child].
  final ScrollController controller;

  /// The scrollable content these shortcuts apply to.
  final Widget child;

  /// Whether this widget claims keyboard focus for itself as soon as
  /// it's built. See the class doc for when to opt out.
  final bool autofocus;

  /// How much of a viewport a single PageUp/PageDown jumps — not a
  /// full page, so the previous screenful stays partly visible and
  /// context isn't lost between jumps (the same convention native
  /// scrollable text views use).
  static const _pageFraction = 0.8;

  void _animateTo(double offset) {
    if (!controller.hasClients) return;
    final position = controller.position;
    controller.animateTo(
      offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: AppMotion.spatialFast,
      curve: AppMotion.spatial,
    );
  }

  void _page({required bool forward}) {
    if (!controller.hasClients) return;
    final position = controller.position;
    final increment = position.viewportDimension * _pageFraction;
    _animateTo(position.pixels + (forward ? increment : -increment));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.home): () =>
            _animateTo(double.negativeInfinity),
        const SingleActivator(LogicalKeyboardKey.end): () =>
            _animateTo(double.infinity),
        const SingleActivator(LogicalKeyboardKey.pageUp): () =>
            _page(forward: false),
        const SingleActivator(LogicalKeyboardKey.pageDown): () =>
            _page(forward: true),
      },
      child: Focus(autofocus: autofocus, child: child),
    );
  }
}
