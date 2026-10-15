import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/features/practice/presentation/providers/live_keyboard_providers.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// The user's own 3D keyboard, live during a practice session: every real
/// keystroke sinks its matching cap and (with RGB on) pulses it, in
/// whatever customization the profile saved — the same reaction the
/// fullscreen keyboard viewer has, running under the code being typed.
/// Shown only when the user turns it on in the session AppBar; renders
/// nothing for a profile whose model has no drawable shape (see
/// `hasSessionKeyboardVisual`).
class LiveKeyboardStrip extends ConsumerWidget {
  /// Creates the live keyboard strip.
  const new({super.key});

  /// The painted height of the board — compact enough to sit above the
  /// capture field on a phone without stealing its space.
  static const height = 110.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileControllerProvider).value;
    final model = profile?.keyboardModel;
    if (profile == null || model == null || model.isEmpty) {
      return const SizedBox.shrink();
    }
    final customization =
        profile.keyboardCustomization ?? KeyboardCustomization.empty;
    if (resolveKeyboardKeySpecs(ref, model, customization) == null) {
      return const SizedBox.shrink();
    }

    final pressed = ref.watch(pressedSessionKeysProvider);
    return SizedBox(
      height: height,
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: pressed,
        builder: (context, keys, child) => KeyboardVisual(
          model: model,
          customization: customization,
          height: height,
          interactive: false,
          pressedPhysicalKeys: keys,
        ),
      ),
    );
  }
}
