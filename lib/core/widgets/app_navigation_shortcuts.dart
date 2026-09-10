import 'package:flutter/material.dart';
import 'package:just_in_time/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:just_in_time/features/settings/domain/entities/shortcut_binding.dart';
import 'package:just_in_time/features/settings/presentation/shortcut_activator.dart';

/// Binds each of the 5 "go to section" [AppShortcutAction]s (capped to
/// [branchCount]) to jump straight to that top-level app section, and
/// [AppShortcutAction.cycleNextSection]/[AppShortcutAction.cyclePreviousSection]
/// to cycle through them — the app-wide counterpart to
/// `KeyboardScrollShortcuts`' own per-screen scroll shortcuts, so every
/// one of the app's main sections (`AppShell`'s `NavigationRail`/
/// `NavigationBar`) is reachable without a mouse/touch on Windows, Linux
/// desktop, and Android with a physical keyboard (STACK.md §2.5's "el
/// teclado es el input principal de toda la app"). [bindings] is
/// user-customizable from Settings — see `AppSettings.shortcutBindings`
/// — so this widget never hardcodes a key combination itself, only which
/// [AppShortcutAction] each gesture maps to.
///
/// Deliberately scoped to *outside* an active practice session:
/// `KeystrokeCaptureField` already claims every mapped physical key
/// while a session is `idle`/`running`, regardless of modifiers, so
/// these shortcuts simply never reach this widget during that window —
/// exactly like the existing Escape-to-exit shortcut on that screen.
/// No focus-grabbing of its own is needed (unlike
/// `KeyboardScrollShortcuts`): [child] always contains real focusable
/// content (nav destinations, buttons, ...) for a key event to bubble
/// up from.
class AppNavigationShortcuts extends StatelessWidget {
  /// Creates the shortcuts scope around [child].
  const new({
    required this.currentIndex,
    required this.branchCount,
    required this.bindings,
    required this.onSelectBranch,
    required this.child,
    super.key,
  });

  /// The currently active section index — the base
  /// [AppShortcutAction.cycleNextSection]/
  /// [AppShortcutAction.cyclePreviousSection] cycles from.
  final int currentIndex;

  /// How many sections exist — bounds both the direct-jump actions and
  /// the cycle's wrap-around.
  final int branchCount;

  /// The user's current (possibly customized) shortcut bindings —
  /// typically `AppSettings.shortcutBindings`.
  final Map<AppShortcutAction, ShortcutBinding> bindings;

  /// Called with the section index to switch to.
  final ValueChanged<int> onSelectBranch;

  /// The content these shortcuts apply above.
  final Widget child;

  /// The direct-jump actions, in section-index order.
  static const List<AppShortcutAction> _directJumpActions = [
    AppShortcutAction.goToPractice,
    AppShortcutAction.goToProgress,
    AppShortcutAction.goToFreePractice,
    AppShortcutAction.goToProfile,
    AppShortcutAction.goToSettings,
  ];

  @override
  Widget build(BuildContext context) {
    final callbackBindings = <ShortcutActivator, VoidCallback>{};

    for (var i = 0; i < branchCount && i < _directJumpActions.length; i++) {
      final binding = bindings[_directJumpActions[i]];
      if (binding == null) continue;
      callbackBindings[binding.toActivator()] = () => onSelectBranch(i);
    }

    final next = bindings[AppShortcutAction.cycleNextSection];
    if (next != null) {
      callbackBindings[next.toActivator()] = () =>
          onSelectBranch((currentIndex + 1) % branchCount);
    }
    final previous = bindings[AppShortcutAction.cyclePreviousSection];
    if (previous != null) {
      callbackBindings[previous.toActivator()] = () =>
          onSelectBranch((currentIndex - 1 + branchCount) % branchCount);
    }

    return CallbackShortcuts(bindings: callbackBindings, child: child);
  }
}
