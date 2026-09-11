import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/achievements/domain/entities/achievement_id.dart';
import 'package:ridge/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:ridge/features/achievements/domain/entities/streak_tier.dart';
import 'package:ridge/features/achievements/presentation/achievements_labels.dart';

/// The (container, onContainer) pair an unlocked badge for [id] renders
/// with. Tiered achievements ([AchievementId.maratonista],
/// [AchievementId.streak]) step through increasingly prominent color
/// roles as the tier gets harder, so the badge wall reads as a visible
/// progression instead of every unlocked tile looking identical; the
/// untiered achievements keep the single [ColorScheme.primaryContainer]
/// look this tile always had.
(Color, Color) _unlockedColors(ColorScheme colors, AchievementId id) => id.when(
  ceroErrores: () => (colors.primaryContainer, colors.onPrimaryContainer),
  ambidiestro: () => (colors.primaryContainer, colors.onPrimaryContainer),
  categoryMastery: (_, _) =>
      (colors.primaryContainer, colors.onPrimaryContainer),
  maratonista: (tier) => switch (tier) {
    MaratonistaTier.bronze => (
      colors.tertiaryContainer,
      colors.onTertiaryContainer,
    ),
    MaratonistaTier.silver => (
      colors.secondaryContainer,
      colors.onSecondaryContainer,
    ),
    MaratonistaTier.gold => (
      colors.primaryContainer,
      colors.onPrimaryContainer,
    ),
  },
  streak: (tier) => switch (tier) {
    StreakTier.threeDays => (colors.surfaceContainerHigh, colors.onSurface),
    StreakTier.sevenDays => (
      colors.tertiaryContainer,
      colors.onTertiaryContainer,
    ),
    StreakTier.thirtyDays => (
      colors.secondaryContainer,
      colors.onSecondaryContainer,
    ),
    StreakTier.hundredDays => (
      colors.primaryContainer,
      colors.onPrimaryContainer,
    ),
  },
);

/// One badge in the Achievements screen's grid: unlocked achievements
/// show in full color with their unlock date; locked ones are greyed
/// out with a hint of what's needed (SPEC.md §12 — every achievement is
/// cosmetic/prestige-only, so a locked badge is never more than a
/// visual/informational nudge, never a gameplay signal).
class AchievementBadgeTile extends StatelessWidget {
  /// Creates the tile for [id], unlocked at [unlockedAt] (or `null` if
  /// still locked).
  const new({required this.id, this.unlockedAt, super.key});

  /// Which achievement this tile renders.
  final AchievementId id;

  /// When this achievement was unlocked, or `null` if still locked.
  final DateTime? unlockedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isUnlocked = unlockedAt != null;
    final (container, onContainer) = isUnlocked
        ? _unlockedColors(colors, id)
        : (colors.surfaceContainerHigh, colors.outline);

    return Opacity(
      opacity: isUnlocked ? 1 : 0.5,
      child: Container(
        // Unlocked tiles only need one short line (the unlock date) while
        // locked ones show a longer, sometimes two-line, description —
        // without a shared minimum every unlocked tile in the Wrap reads
        // as noticeably smaller than its locked neighbors. 136 comfortably
        // fits icon + two lines of title + two lines of subtitle at the
        // default Material 3 type scale.
        constraints: const BoxConstraints(minHeight: 136),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          shape: AppShapes.of(context).largeShape,
          color: container,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(id.icon, size: 28, color: onContainer),
            const SizedBox(height: 6),
            Text(
              id.title(l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isUnlocked ? onContainer : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isUnlocked
                  ? DateFormat.yMMMd().format(unlockedAt!)
                  : id.description(l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
