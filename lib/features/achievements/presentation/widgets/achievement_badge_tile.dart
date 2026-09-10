import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/achievements/domain/entities/achievement_id.dart';
import 'package:ridge/features/achievements/presentation/achievements_labels.dart';

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
          color: isUnlocked
              ? colors.primaryContainer
              : colors.surfaceContainerHigh,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              id.icon,
              size: 28,
              color: isUnlocked ? colors.onPrimaryContainer : colors.outline,
            ),
            const SizedBox(height: 6),
            Text(
              id.title(l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isUnlocked ? colors.onPrimaryContainer : null,
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
