import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/progression/domain/entities/weak_character.dart';

/// A lightweight keyboard heatmap (SPEC.md §4.2's "mapa de calor del
/// teclado") — a [Wrap] of key-shaped tiles, one per weakest character,
/// tinted from neutral to error-red by score. No charting dependency:
/// just colored containers, per the project plan.
class KeyboardHeatmap extends StatelessWidget {
  /// Creates the heatmap for [weakCharacters] (already ranked worst-first
  /// and capped by `WeaknessRankingCalculator`).
  const new({required this.weakCharacters, super.key});

  /// The ranked weak-character list to render as tiles.
  final List<WeakCharacter> weakCharacters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (weakCharacters.isEmpty) {
      return Text(
        l10n.progressWeaknessEmpty,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final weak in weakCharacters)
          _KeyTile(
            character: weak.character,
            score: weak.score,
            colorScheme: colorScheme,
          ),
      ],
    );
  }
}

class _KeyTile extends StatelessWidget {
  const new({
    required this.character,
    required this.score,
    required this.colorScheme,
  });

  final String character;
  final double score;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final intensity = score.clamp(0.0, 1.0);
    final tileColor = Color.lerp(
      colorScheme.surfaceContainerHighest,
      colorScheme.errorContainer,
      intensity,
    );
    final onTileColor = Color.lerp(
      colorScheme.onSurfaceVariant,
      colorScheme.onErrorContainer,
      intensity,
    );
    return AnimatedContainer(
      duration: AppMotion.effectsDefault,
      curve: AppMotion.effects,
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: tileColor,
        shape: AppShapes.of(context).smallShape,
      ),
      child: Text(
        character,
        style: TextStyle(
          fontFamily: AppFonts.mono,
          fontWeight: FontWeight.w700,
          color: onTileColor,
        ),
      ),
    );
  }
}
