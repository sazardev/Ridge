import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/features/progression/presentation/providers/progression_providers.dart';
import 'package:just_in_time/features/progression/presentation/widgets/xp_level_bar.dart';

/// A compact preview of the active profile's progression history — level,
/// XP progress, and current streak — reusing the already-computed
/// [progressSnapshotControllerProvider] so this card never duplicates
/// progression logic, only previews it, with a link out to the full
/// Progress screen for the rest of the history.
class ProfileStatsCard extends ConsumerWidget {
  /// Creates the card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final snapshot = ref.watch(progressSnapshotControllerProvider).value;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: snapshot == null
            ? Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.progressEmptyState,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.profileStatsTitle,
                          style: textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.progressStreakLabel(snapshot.currentStreakDays),
                        style: textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  XpLevelBar(xpSummary: snapshot.xpSummary),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push('/progress'),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text(l10n.profileViewProgressAction),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
