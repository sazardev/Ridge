import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/practice/presentation/widgets/typing_progress_bar.dart';

/// The code "card" of a practice session — the syntax-highlighted
/// [textSpan] on the session surface, the ghost-race badge when one is
/// running, and the bottom progress bar. Extracted from
/// `KeystrokeCaptureField` for the file-size budget; the field owns the
/// scroll view this is stacked inside.
class KeystrokeCodeCard extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.textSpan,
    required this.snippetKey,
    required this.progress,
    this.ghostPercent,
    this.ghostSpeedCpm,
    super.key,
  });

  /// The fully-styled snippet text.
  final TextSpan textSpan;

  /// Identifies the snippet for the cross-fade key — a Sprint mode
  /// mid-session swap animates, ordinary per-keystroke recoloring keeps
  /// the same key and never retriggers the transition.
  final Key snippetKey;

  /// 0..1 raw advance through the snippet's code.
  final double progress;

  /// The ghost race's completion percentage, or `null` when no ghost is
  /// being raced (or the session hasn't started).
  final int? ghostPercent;

  /// The ghost's own net speed, for the badge's tooltip.
  final double? ghostSpeedCpm;

  /// The internal padding that frames the code (also subtracted by the
  /// field's auto-scroll math).
  static const padding = EdgeInsets.all(20);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final percent = ghostPercent;
    final speed = ghostSpeedCpm;

    return Stack(
      // `loose` (the default) would hand the `Container` below loosened
      // constraints, discarding the minHeight floor the field's
      // `ConstrainedBox` just set — `passthrough` forwards the incoming
      // constraints unchanged so the card still fills the available space
      // instead of shrinking back to its text, with the progress bar
      // still free to position itself via `Positioned`.
      fit: StackFit.passthrough,
      children: [
        Container(
          width: double.infinity,
          padding: padding,
          color: theme.colorScheme.surfaceContainerHigh,
          child: AnimatedSwitcher(
            duration: AppMotion.effectsDefault,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.exit,
            child: RichText(key: snippetKey, text: textSpan),
          ),
        ),
        if (percent != null && speed != null)
          Positioned(
            top: 10,
            right: 14,
            child: Tooltip(
              message: l10n.practiceGhostRacingLabel(speed.round()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: ShapeDecoration(
                  shape: AppShapes.of(context).smallShape,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.ghost300,
                      size: 14,
                      color: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.practiceGhostBadge(percent),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: TypingProgressBar(progress: progress),
        ),
      ],
    );
  }
}
