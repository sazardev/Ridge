import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/achievements/presentation/achievements_labels.dart';

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

    return Opacity(
      opacity: isUnlocked ? 1 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          shape: AppShapes.of(context).largeShape,
          color: isUnlocked
              ? colors.primaryContainer
              : colors.surfaceContainerHigh,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              id.icon,
              size: 36,
              color: isUnlocked ? colors.onPrimaryContainer : colors.outline,
            ),
            const SizedBox(height: 8),
            Text(
              id.title(l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isUnlocked ? colors.onPrimaryContainer : null,
              ),
            ),
            const SizedBox(height: 4),
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
