import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/progression/presentation/providers/weekly_summary_providers.dart';

/// The Progress Overview's rolling weekly report card (SPEC.md §4.3's
/// "comparación histórica personal" as a weekly check-in): sessions,
/// time, XP and average speed/accuracy over the last seven local days,
/// plus the speed delta against the week before. Renders nothing without
/// any session history (see `weeklySummary`'s doc).
class WeeklySummaryCard extends ConsumerWidget {
  /// Creates the weekly report card.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(weeklySummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasDelta = summary.sessions > 0 && summary.previousSessions > 0;
    final delta = hasDelta
        ? (summary.averageNetSpeedCpm - summary.previousAverageNetSpeedCpm)
              .round()
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.progressWeeklyTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (delta != null) ...[
                  Icon(
                    delta >= 0
                        ? LucideIcons.trendingUp300
                        : LucideIcons.trendingDown300,
                    size: 16,
                    color: delta >= 0 ? colorScheme.primary : colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.progressWeeklySpeedDelta(
                      delta >= 0 ? '+$delta' : '$delta',
                    ),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: delta >= 0
                          ? colorScheme.primary
                          : colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (summary.sessions == 0)
              Text(l10n.progressWeeklyEmpty, style: theme.textTheme.bodyMedium)
            else ...[
              Row(
                children: [
                  _Stat(
                    label: l10n.progressWeeklySessions,
                    value: '${summary.sessions}',
                  ),
                  _Stat(
                    label: l10n.progressWeeklyTime,
                    value: _formatDuration(summary.totalDuration),
                  ),
                  _Stat(
                    label: l10n.progressWeeklyXp,
                    value: '${summary.totalXp}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Stat(
                    label: l10n.progressWeeklyAvgSpeed,
                    value: summary.averageNetSpeedCpm.toStringAsFixed(0),
                  ),
                  _Stat(
                    label: l10n.progressWeeklyAccuracy,
                    value: '${summary.averageAccuracyPct.toStringAsFixed(1)}%',
                  ),
                  _Stat(
                    label: l10n.progressWeeklyActiveDays,
                    value: '${summary.activeDays}/7',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// One metric column of the report — mono value over a muted label.
class _Stat extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: AppFonts.mono,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// `"1h 05m"` / `"42m"` / `"0m"` — compact enough for the stat column.
String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0) return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  return '${duration.inMinutes}m';
}
