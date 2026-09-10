import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/progression/domain/entities/personal_history_comparison.dart';

/// A simple bar/sparkline row (SPEC.md §7.1/§11.4's guest-only "local
/// leaderboard") — one bar per recent session's net speed, tallest-first
/// order preserved as chronological (oldest to newest), colored above/
/// below the rolling average. No charting dependency, per the project
/// plan.
class PersonalHistoryChart extends StatelessWidget {
  /// Creates the chart for [comparison].
  const new({required this.comparison, super.key});

  /// The rolling comparison to render.
  final PersonalHistoryComparison comparison;

  static const _barAreaHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    if (comparison.sampleSize == 0) {
      return Text(l10n.progressHistoryEmpty, style: textTheme.bodyMedium);
    }

    final colorScheme = Theme.of(context).colorScheme;
    final maxSpeed = comparison.recentNetSpeedCpm.reduce(math.max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressHistoryAverage(
            comparison.averageNetSpeedCpm.round(),
            comparison.averageAccuracyPct.round(),
          ),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: _barAreaHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final speed in comparison.recentNetSpeedCpm)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: AppMotion.spatialDefault,
                      curve: AppMotion.spatial,
                      height: maxSpeed <= 0
                          ? 4
                          : _barAreaHeight *
                                (speed / maxSpeed).clamp(0.05, 1.0),
                      decoration: BoxDecoration(
                        color: speed >= comparison.averageNetSpeedCpm
                            ? colorScheme.primary
                            : colorScheme.secondaryContainer,
                        borderRadius: AppShapes.squircleRadius(
                          AppShapes.of(context).extraSmall,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
