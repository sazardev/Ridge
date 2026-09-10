import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_in_time/features/settings/domain/entities/shortcut_binding.dart';

/// Converts a persisted, Flutter-free [ShortcutBinding] into the
/// `SingleActivator` `CallbackShortcuts` widgets actually bind against —
/// the one place this conversion happens, shared by every widget that
/// renders a customizable shortcut (`AppNavigationShortcuts`, the
/// Progress screen's tab-cycling shortcut).
extension ShortcutBindingActivator on ShortcutBinding {
  /// Returns the `SingleActivator` equivalent to this binding.
  SingleActivator toActivator() {
    return SingleActivator(
      LogicalKeyboardKey(keyId),
      control: control,
      alt: alt,
      shift: shift,
    );
  }
}
