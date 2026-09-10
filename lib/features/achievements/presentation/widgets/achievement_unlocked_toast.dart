import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement.dart';
import 'package:just_in_time/features/achievements/presentation/achievements_labels.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shows a short-lived snackbar-style notice for each newly-unlocked
/// entry in [achievements], right after a practice session finishes
/// (SPEC.md §12) — cosmetic/prestige-only celebratory flavor, never a
/// gameplay signal.
void showAchievementUnlockedToast(
  BuildContext context, {
  required List<Achievement> achievements,
}) {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  for (final achievement in achievements) {
    messenger.showSnackBar(
      SnackBar(
        shape: AppShapes.of(context).mediumShape,
        content: Row(
          children: [
            const Icon(LucideIcons.trophy600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.achievementUnlockedToast(achievement.id.title(l10n)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
