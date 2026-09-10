import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/progression/domain/entities/activity_report.dart';
import 'package:ridge/features/progression/domain/entities/category_activity_stat.dart';
import 'package:ridge/features/progression/domain/entities/exercise_activity_stat.dart';
import 'package:ridge/features/progression/domain/entities/trend.dart';
import 'package:ridge/features/progression/presentation/progression_labels.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';

/// [Trend]'s icon direction for a "higher = better" score, the inverse
/// of `TrendPresentation.icon`'s weakness-score direction (see
/// `CategoryActivityStat.trend`'s doc).
extension _ActivityTrendIcon on Trend {
  IconData get _icon => switch (this) {
    Trend.improving => LucideIcons.trendingUp300,
    Trend.worsening => LucideIcons.trendingDown300,
    Trend.stable => LucideIcons.moveHorizontal300,
  };
}

/// One ranked activity entry, already reduced to exactly what this
/// card's list rendering needs.
typedef _RankedActivityEntryView = ({
  String label,
  String subtitle,
  IconData? trendIcon,
  String? trendLabel,
});

/// The "dónde practicas más / dónde tienes el puntaje más bajo"
/// diagnostic card — four short ranked lists (most/lowest-scoring,
/// categories/exercises), mirroring `WeaknessReportCard`'s layout.
class ActivityReportCard extends ConsumerWidget {
  /// Creates the card for [report].
  const new({required this.report, super.key});

  /// The activity report to render.
  final ActivityReport report;

  static const _maxEntriesShown = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.progressActivityTitle, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            _ActivitySection(
              title: l10n.progressActivityMostPracticedCategories,
              entries: [
                for (final c in report.mostPracticedCategories.take(
                  _maxEntriesShown,
                ))
                  _categoryEntry(c, l10n),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
            const SizedBox(height: 12),
            _ActivitySection(
              title: l10n.progressActivityLowestScoringCategories,
              entries: [
                for (final c in report.lowestScoringCategories.take(
                  _maxEntriesShown,
                ))
                  _categoryEntry(c, l10n),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
            const SizedBox(height: 12),
            _ActivitySection(
              title: l10n.progressActivityMostPracticedExercises,
              entries: [
                for (final e in report.mostPracticedExercises.take(
                  _maxEntriesShown,
                ))
                  _exerciseEntry(e, l10n, ref, context),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
            const SizedBox(height: 12),
            _ActivitySection(
              title: l10n.progressActivityLowestScoringExercises,
              entries: [
                for (final e in report.lowestScoringExercises.take(
                  _maxEntriesShown,
                ))
                  _exerciseEntry(e, l10n, ref, context),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
          ],
        ),
      ),
    );
  }

  _RankedActivityEntryView _categoryEntry(
    CategoryActivityStat stat,
    AppLocalizations l10n,
  ) {
    return (
      label: stat.category.label(l10n),
      subtitle:
          '${l10n.progressActivitySessionCount(stat.sessionCount)} · '
          '${l10n.progressActivityScoreLabel(stat.performanceScore.round())}',
      trendIcon: stat.trend._icon,
      trendLabel: stat.trend.label(l10n),
    );
  }

  _RankedActivityEntryView _exerciseEntry(
    ExerciseActivityStat stat,
    AppLocalizations l10n,
    WidgetRef ref,
    BuildContext context,
  ) {
    final snippetAsync = ref.watch(snippetByIdProvider(stat.snippetId));
    final title = snippetAsync.when(
      data: (snippet) => snippet?.titleFor(context) ?? stat.snippetId.value,
      loading: () => stat.snippetId.value,
      error: (error, stackTrace) => stat.snippetId.value,
    );
    return (
      label: title,
      subtitle:
          '${l10n.progressActivitySessionCount(stat.sessionCount)} · '
          '${l10n.progressActivityScoreLabel(stat.performanceScore.round())}',
      trendIcon: null,
      trendLabel: null,
    );
  }
}

class _ActivitySection extends StatelessWidget {
  const new({
    required this.title,
    required this.entries,
    required this.emptyLabel,
  });

  final String title;
  final List<_RankedActivityEntryView> entries;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        if (entries.isEmpty)
          Text(emptyLabel, style: textTheme.bodySmall)
        else
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.label,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppFonts.mono,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(entry.subtitle, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (entry.trendIcon != null) ...[
                    Icon(
                      entry.trendIcon,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(entry.trendLabel!, style: textTheme.bodySmall),
                  ],
                ],
              ),
            ),
      ],
    );
  }
}
