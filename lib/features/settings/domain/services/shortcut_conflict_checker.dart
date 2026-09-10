import 'package:ridge/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:ridge/features/settings/domain/entities/shortcut_binding.dart';

/// Pure, stateless conflict check for the keyboard-shortcuts rebind
/// screen: does [candidate] already belong to some other action in
/// [bindings]? [action] itself never conflicts with its own current
/// binding (rebinding a shortcut to the combination it already has isn't
/// a conflict, it's a no-op).
///
/// Returns the other action already using [candidate], or `null` if
/// [candidate] is free.
AppShortcutAction? findShortcutConflict(
  Map<AppShortcutAction, ShortcutBinding> bindings,
  AppShortcutAction action,
  ShortcutBinding candidate,
) {
  for (final entry in bindings.entries) {
    if (entry.key == action) continue;
    if (entry.value == candidate) return entry.key;
  }
  return null;
}
