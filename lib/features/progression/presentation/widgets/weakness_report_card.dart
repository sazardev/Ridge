import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id_label.dart';
import 'package:ridge/features/progression/domain/entities/weakness_report.dart';
import 'package:ridge/features/progression/presentation/progression_labels.dart';

/// One ranked entry, already reduced to exactly what this card's list
/// rendering needs — shared shape for the character/finger/n-gram lists,
/// whose underlying types otherwise differ.
typedef _RankedEntryView = ({
  String label,
  double score,
  String trendLabel,
  IconData trendIcon,
});

/// The "tus puntos débiles" diagnostic card (SPEC.md §4.3) — three short
/// ranked lists (characters, fingers, n-grams), each with a trend
/// indicator, per the project plan's "three separate lists" rule.
class WeaknessReportCard extends StatelessWidget {
  /// Creates the card for [report].
  const new({required this.report, super.key});

  /// The weakness report to render.
  final WeaknessReport report;

  static const _maxEntriesShown = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.progressWeaknessTitle, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            _WeaknessSection(
              title: l10n.progressWeaknessCharacters,
              entries: [
                for (final w in report.weakCharacters.take(_maxEntriesShown))
                  (
                    label: w.character,
                    score: w.score,
                    trendLabel: w.trend.label(l10n),
                    trendIcon: w.trend.icon,
                  ),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
            const SizedBox(height: 12),
            _WeaknessSection(
              title: l10n.progressWeaknessFingers,
              entries: [
                for (final w in report.weakFingers.take(_maxEntriesShown))
                  (
                    label: w.finger.label(l10n),
                    score: w.score,
                    trendLabel: w.trend.label(l10n),
                    trendIcon: w.trend.icon,
                  ),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
            const SizedBox(height: 12),
            _WeaknessSection(
              title: l10n.progressWeaknessNgrams,
              entries: [
                for (final w in report.weakNgrams.take(_maxEntriesShown))
                  (
                    label: w.text,
                    score: w.score,
                    trendLabel: w.trend.label(l10n),
                    trendIcon: w.trend.icon,
                  ),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
            const SizedBox(height: 12),
            _WeaknessSection(
              title: l10n.progressWeaknessKeyTransitions,
              entries: [
                for (final w in report.weakKeyTransitions.take(
                  _maxEntriesShown,
                ))
                  (
                    label:
                        '${w.fromKey.displayLabel(l10n)} '
                        '→ ${w.toKey.displayLabel(l10n)}',
                    score: w.score,
                    trendLabel: w.trend.label(l10n),
                    trendIcon: w.trend.icon,
                  ),
              ],
              emptyLabel: l10n.progressWeaknessEmpty,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeaknessSection extends StatelessWidget {
  const new({
    required this.title,
    required this.entries,
    required this.emptyLabel,
  });

  final String title;
  final List<_RankedEntryView> entries;
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
                    child: Text(
                      entry.label,
                      style: const TextStyle(
                        fontFamily: AppFonts.mono,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    entry.trendIcon,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(entry.trendLabel, style: textTheme.bodySmall),
                ],
              ),
            ),
      ],
    );
  }
}
