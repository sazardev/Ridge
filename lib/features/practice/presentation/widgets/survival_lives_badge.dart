import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/practice/domain/services/survival_run_tracker.dart';

/// Small pill showing a Survival run's remaining lives as hearts (SPEC.md
/// §5.8), one heart per [SurvivalRunTracker.startingLives]. Filled hearts
/// are lives still in hand, outlined hearts are lives lost; the whole pill
/// switches to the error color at the last life as a visual cue, mirroring
/// `SprintCountdownBadge`'s urgent state.
class SurvivalLivesBadge extends StatelessWidget {
  /// Creates the badge for the given live [tracker].
  const new({required this.tracker, super.key});

  /// The run's live arcade state — read fresh on every rebuild.
  final SurvivalRunTracker tracker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final lives = tracker.livesRemaining;
    final isCritical = lives <= 1;

    return Semantics(
      label: l10n.practiceLiveLives(lives),
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: AppMotion.effectsDefault,
          curve: AppMotion.effects,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            shape: AppShapes.of(context).fullShape,
            color: isCritical
                ? colors.errorContainer
                : colors.secondaryContainer,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < tracker.startingLives; i++)
                Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 2,
                    right: i == tracker.startingLives - 1 ? 0 : 2,
                  ),
                  child: AnimatedSwitcher(
                    duration: AppMotion.spatialDefault,
                    // Losing a life pops the emptied heart in with a bounce.
                    transitionBuilder: springSwitcherTransition,
                    child: Icon(
                      i < lives ? LucideIcons.heart600 : LucideIcons.heart100,
                      key: ValueKey(i < lives),
                      size: 16,
                      color:
                          (isCritical
                                  ? colors.onErrorContainer
                                  : colors.onSecondaryContainer)
                              .withValues(alpha: i < lives ? 1 : 0.38),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
