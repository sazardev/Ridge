import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id_label.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';
import 'package:ridge/features/progression/presentation/widgets/xp_level_bar.dart';

/// A compact preview of the active profile's progression history — level,
/// XP progress, current streak, and (when available) a one-line taste of
/// the top weak key-transition and most-practiced category — reusing the
/// already-computed [progressSnapshotControllerProvider] so this card
/// never duplicates the full ranked lists (those stay on the Progress
/// screen), only previews the single most eye-catching entry of each,
/// with a link out to the full Progress screen for the rest.
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
                    LucideIcons.barChart3300,
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
                        LucideIcons.flame300,
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
                  if (snapshot.weaknessReport.weakKeyTransitions.isNotEmpty ||
                      snapshot
                          .activityReport
                          .mostPracticedCategories
                          .isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        if (snapshot
                            .weaknessReport
                            .weakKeyTransitions
                            .isNotEmpty)
                          _StatHighlight(
                            icon: LucideIcons.triangleAlert300,
                            label: () {
                              final worst = snapshot
                                  .weaknessReport
                                  .weakKeyTransitions
                                  .first;
                              return '${worst.fromKey.displayLabel(l10n)} '
                                  '→ ${worst.toKey.displayLabel(l10n)}';
                            }(),
                          ),
                        if (snapshot
                            .activityReport
                            .mostPracticedCategories
                            .isNotEmpty)
                          _StatHighlight(
                            icon: LucideIcons.repeat300,
                            label: snapshot
                                .activityReport
                                .mostPracticedCategories
                                .first
                                .category
                                .label(l10n),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push('/progress'),
                      icon: const Icon(LucideIcons.arrowRight300, size: 18),
                      label: Text(l10n.profileViewProgressAction),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// One small icon+label preview chip, used for the top weak
/// key-transition and top most-practiced category previews above.
class _StatHighlight extends StatelessWidget {
  const new({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(fontFamily: AppFonts.mono),
        ),
      ],
    );
  }
}
