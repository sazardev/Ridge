import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// The profile screen's keyboard hero: a large rendering of the active
/// profile's `keyboardModel`, shown right under the identity header
/// instead of buried inside `ProfileAboutCard` — this app is for people
/// who care about their keyboard, so it earns first-screen visibility
/// rather than living below the stats/achievements cards.
///
/// Renders nothing if [GuestProfile.keyboardModel] is unset, or is free
/// text `KeyboardVisual` can't match to a curated layout or generic
/// family — same "nothing to guess at" contract as `KeyboardVisual`
/// itself, so this never shows an empty decorated box.
class ProfileKeyboardHeroCard extends ConsumerWidget {
  /// Creates the hero for [profile]'s keyboard.
  const new({required this.profile, super.key});

  /// The profile whose keyboard this renders.
  final GuestProfile profile;

  /// The visual's painted height — noticeably larger than the `88`
  /// logical-pixel preview used inline elsewhere, since this is meant to
  /// read as the screen's visual centerpiece.
  static const _visualHeight = 168.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = profile.keyboardModel;
    if (model == null || model.isEmpty) return const SizedBox.shrink();

    final keys = resolveKeyboardKeySpecs(ref, model);
    if (keys == null || keys.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final brand = profile.keyboardBrand;
    final caption = (brand?.isNotEmpty ?? false) ? '$brand $model' : model;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colorScheme.surfaceContainerLow,
        shape: AppShapes.of(context).largeShape,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          children: [
            KeyboardVisual(model: model, height: _visualHeight),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.keyboard300,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
