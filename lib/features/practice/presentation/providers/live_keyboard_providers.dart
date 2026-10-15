import 'package:flutter/foundation.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_keyboard_providers.g.dart';

/// Physical keys currently held down during a practice session, by
/// `PhysicalKeyId.name` — the bridge between `KeystrokeCaptureField`
/// (which sees every real keydown/keyup) and the live 3D keyboard strip.
///
/// A raw `ValueNotifier` on purpose: it changes on every keystroke, and
/// only the strip's own `ValueListenableBuilder` should rebuild that
/// often — a Riverpod state here would rebuild the capture field per
/// key. Kept alive (and explicitly cleared when the field disposes) so a
/// key still held at the end of a session can never stay lit into the
/// next one.
@Riverpod(keepAlive: true)
ValueNotifier<Set<String>> pressedSessionKeys(Ref ref) {
  final notifier = ValueNotifier<Set<String>>(const {});
  ref.onDispose(notifier.dispose);
  return notifier;
}

/// Whether the active profile has a keyboard the live strip can actually
/// draw — a non-empty model that resolves to a curated layout or a known
/// family silhouette. Gates both the session AppBar's toggle and the
/// strip itself, so the control never dangles over nothing.
@riverpod
bool hasSessionKeyboardVisual(Ref ref) {
  final profile = ref.watch(activeProfileControllerProvider).value;
  final model = profile?.keyboardModel;
  if (profile == null || model == null || model.isEmpty) return false;
  final customization =
      profile.keyboardCustomization ?? KeyboardCustomization.empty;

  // Mirrors `resolveKeyboardKeySpecs`'s lookup order (explicit family
  // override, then a curated layout, then a known family silhouette) —
  // that helper takes a `WidgetRef`, which a provider doesn't have.
  if (customization.shapeFamily != null) return true;
  if (ref.watch(keyboardVisualLayoutsProvider).value?[model] != null) {
    return true;
  }
  return keyboardShapeFamilyFor(model) != null;
}
