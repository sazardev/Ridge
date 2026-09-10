import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/core/theme/app_typography.dart';
import 'package:just_in_time/features/practice/domain/entities/session_metrics.dart';
import 'package:just_in_time/features/practice/domain/services/precision_score_calculator.dart';
import 'package:just_in_time/features/practice/domain/services/survival_run_tracker.dart';
import 'package:just_in_time/features/practice/presentation/compiler_flavor.dart';

const _scoreCalculator = PrecisionScoreCalculator();

/// Scrollable result summary shown once a practice session reaches
/// `PracticeSessionStatus.result` (SPEC.md §4.2/§4.3): speed, accuracy,
/// consistency, longest streak, and this session's weakest characters.
///
/// Deliberately has no actions of its own (no Retry/Continue/info) —
/// those live in `SessionResultFooter`, pinned outside this panel's
/// scroll view, so a long result never buries them out of reach.
class SessionResultPanel extends StatelessWidget {
  /// Creates the panel for the given computed [metrics].
  const new({required this.metrics, this.passed, this.survival, super.key});

  /// The computed metrics for the just-finished session.
  final SessionMetrics metrics;

  /// This session's pass/fail outcome (SPEC.md §5.3) — `null` for modes
  /// without a threshold (Zen, Sprint, Survival), in which case no
  /// pass/fail banner is shown.
  final bool? passed;

  /// The final arcade state of a Survival run (SPEC.md §5.8), or `null`
  /// for every other mode. When present, the panel leads with the run's
  /// own score/snippets/multiplier rows and titles itself "Run over".
  final SurvivalRunTracker? survival;

  List<MapEntry<String, int>> _weakestCharacters() {
    final withErrors = [
      for (final stat in metrics.characterStats.values)
        if (stat.errors > 0) MapEntry(stat.character, stat.errors),
    ]..sort((a, b) => b.value.compareTo(a.value));
    return withErrors.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final weakest = _weakestCharacters();
    final survival = this.survival;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        shape: AppShapes.of(context).largeShape,
        color: theme.colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            survival == null
                ? l10n.practiceResultTitle
                : l10n.practiceResultSurvivalTitle,
            style: theme.textTheme.titleLarge,
          ),
          if (passed != null) ...[
            const SizedBox(height: 12),
            _PassFailBanner(
              passed: passed!,
              score: _scoreCalculator.scoreFor(metrics.accuracyPct),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            compilerFlavorMessage(l10n, metrics),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: AppFonts.mono,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          if (survival != null) ...[
            _MetricRow(
              label: l10n.practiceResultSurvivalScore,
              value: '${survival.score}',
            ),
            _MetricRow(
              label: l10n.practiceResultSurvivalSnippets,
              value: '${survival.snippetsCleared}',
            ),
            _MetricRow(
              label: l10n.practiceResultSurvivalBestMultiplier,
              value: '×${survival.bestMultiplier}',
            ),
            const SizedBox(height: 8),
          ],
          _MetricRow(
            label: l10n.practiceResultNetSpeed,
            value: '${metrics.netSpeedCpm.toStringAsFixed(0)} cpm',
          ),
          _MetricRow(
            label: l10n.practiceResultRawSpeed,
            value: '${metrics.rawSpeedCpm.toStringAsFixed(0)} cpm',
          ),
          _MetricRow(
            label: l10n.practiceResultAccuracy,
            value: '${metrics.accuracyPct.toStringAsFixed(1)}%',
          ),
          _MetricRow(
            label: l10n.practiceResultConsistency,
            value: metrics.consistencyScore.toStringAsFixed(0),
          ),
          _MetricRow(
            label: l10n.practiceResultStreak,
            value: '${metrics.maxStreak}',
          ),
          if (weakest.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.practiceResultWeakestChars,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final entry in weakest)
                  Chip(label: Text('${entry.key} · ${entry.value}')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PassFailBanner extends StatelessWidget {
  const new({required this.passed, required this.score});

  final bool passed;

  /// 1-10, per [PrecisionScoreCalculator] — a score over
  /// [PrecisionScoreCalculator.passingScore] is what [passed] reflects.
  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: ShapeDecoration(
        shape: AppShapes.of(context).mediumShape,
        color: passed ? colors.primaryContainer : colors.errorContainer,
      ),
      child: Text(
        passed
            ? l10n.practiceResultScorePassed(score)
            : l10n.practiceResultScoreFailed(score),
        textAlign: TextAlign.center,
        style: theme.textTheme.titleSmall?.copyWith(
          color: passed ? colors.onPrimaryContainer : colors.onErrorContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
