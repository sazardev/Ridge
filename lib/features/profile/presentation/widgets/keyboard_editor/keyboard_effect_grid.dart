import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/presentation/profile_labels.dart';

/// A representative icon for each RGB effect, used by the editor's visual
/// effect picker.
IconData iconForRgbEffect(RgbEffect effect) => switch (effect) {
  RgbEffect.static => LucideIcons.circle,
  RgbEffect.breathing => LucideIcons.activity,
  RgbEffect.rainbow => LucideIcons.rainbow,
  RgbEffect.colorCycle => LucideIcons.refreshCw,
  RgbEffect.wave => LucideIcons.waves,
  RgbEffect.aurora => LucideIcons.wand2,
  RgbEffect.stars => LucideIcons.star,
  RgbEffect.rain => LucideIcons.cloudRain,
  RgbEffect.gradient => LucideIcons.blend,
  RgbEffect.reactive => LucideIcons.zap,
  RgbEffect.ripple => LucideIcons.radio,
};

/// A representative icon for each keycap light transmission.
IconData iconForKeycapTransparency(KeycapTransparency value) => switch (value) {
  KeycapTransparency.opaque => LucideIcons.circle,
  KeycapTransparency.shineThrough => LucideIcons.type,
  KeycapTransparency.pudding => LucideIcons.droplets,
  KeycapTransparency.translucent => LucideIcons.sun,
};

/// The lighting editor's visual effect picker: a grid of icon tiles, one
/// per firmware-style effect, instead of a long block of chips — the
/// closest a form gets to a keyboard configurator's effect list.
class KeyboardEffectGrid extends StatelessWidget {
  /// Creates the picker over the current [selected] effect.
  const new({required this.selected, required this.onSelected, super.key});

  /// The current effect.
  final RgbEffect selected;

  /// Called when a tile is tapped.
  final ValueChanged<RgbEffect> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.25,
      children: [
        for (final effect in RgbEffect.values)
          _EffectTile(
            effect: effect,
            selected: effect == selected,
            onTap: () => onSelected(effect),
          ),
      ],
    );
  }
}

class _EffectTile extends StatelessWidget {
  const new({
    required this.effect,
    required this.selected,
    required this.onTap,
  });

  final RgbEffect effect;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BouncyTap(
      enabled: true,
      child: InkWell(
        onTap: onTap,
        customBorder: AppShapes.of(context).mediumShape,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconForRgbEffect(effect),
                size: 22,
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  effect.label(l10n),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: selected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
