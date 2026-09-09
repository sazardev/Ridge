import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/features/progression/domain/entities/xp_summary.dart';

/// XP/level progress bar (SPEC.md §6.1-§6.2) — level, total XP, and how
/// far through the current level's bracket the profile is.
class XpLevelBar extends StatelessWidget {
  /// Creates the XP/level bar for [xpSummary].
  const new({required this.xpSummary, super.key});

  /// The XP/level standing to render.
  final XpSummary xpSummary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.progressLevelLabel(xpSummary.level),
              style: textTheme.titleMedium,
            ),
            Text(
              l10n.progressTotalXp(xpSummary.totalXp),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: AppShapes.squircleRadius(AppShapes.of(context).full),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: xpSummary.progressToNextLevel),
            duration: AppMotion.spatialDefault,
            curve: AppMotion.spatial,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
