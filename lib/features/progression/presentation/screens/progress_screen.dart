import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/content/presentation/content_labels.dart';
import 'package:just_in_time/features/progression/presentation/providers/progression_providers.dart';
import 'package:just_in_time/features/progression/presentation/widgets/keyboard_heatmap.dart';
import 'package:just_in_time/features/progression/presentation/widgets/personal_history_chart.dart';
import 'package:just_in_time/features/progression/presentation/widgets/weakness_report_card.dart';
import 'package:just_in_time/features/progression/presentation/widgets/xp_level_bar.dart';

/// The Progress screen (SPEC.md §4.3/§6): XP/level, streak, weakness
/// diagnostic, per-category mastery, and a personal-history comparison
/// for recently-practiced content.
class ProgressScreen extends ConsumerStatefulWidget {
  /// Creates the progress screen.
  const new({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(progressSnapshotControllerProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.progressTitle)),
      body: snapshotAsync.when(
        data: (snapshot) {
          if (snapshot == null) {
            return Center(child: Text(l10n.progressEmptyState));
          }
          return KeyboardScrollShortcuts(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              children: [
                XpLevelBar(xpSummary: snapshot.xpSummary),
                const SizedBox(height: 8),
                Text(
                  l10n.progressStreakLabel(snapshot.currentStreakDays),
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                WeaknessReportCard(report: snapshot.weaknessReport),
                const SizedBox(height: 24),
                Text(l10n.progressHeatmapTitle, style: textTheme.titleMedium),
                const SizedBox(height: 12),
                KeyboardHeatmap(
                  weakCharacters: snapshot.weaknessReport.weakCharacters,
                ),
                const SizedBox(height: 24),
                Text(l10n.progressMasteryTitle, style: textTheme.titleMedium),
                const SizedBox(height: 12),
                if (snapshot.masteryStatuses.isEmpty)
                  Text(l10n.progressMasteryEmpty, style: textTheme.bodyMedium)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final status in snapshot.masteryStatuses)
                        Tooltip(
                          message: status.isMastered
                              ? l10n.progressMasteryCertified
                              : l10n.progressMasteryNotYet,
                          child: Chip(
                            avatar: Icon(
                              status.isMastered
                                  ? Icons.verified_rounded
                                  : Icons.circle_outlined,
                              size: 18,
                            ),
                            label: Text(
                              '${status.category.label(l10n)} · '
                              '${status.difficulty.label(l10n)}',
                            ),
                          ),
                        ),
                    ],
                  ),
                if (snapshot.masteryStatuses.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(l10n.progressHistoryTitle, style: textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final comparisonAsync = ref.watch(
                        personalHistoryForCategoryProvider(
                          snapshot.masteryStatuses.first.category,
                        ),
                      );
                      return comparisonAsync.when(
                        data: (comparison) =>
                            PersonalHistoryChart(comparison: comparison),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Text(l10n.commonSomethingWrong),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.commonSomethingWrong)),
      ),
    );
  }
}
