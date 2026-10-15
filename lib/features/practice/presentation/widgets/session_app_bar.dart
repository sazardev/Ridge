import 'package:flutter/material.dart';

import 'package:ridge/features/practice/domain/services/survival_run_tracker.dart';
import 'package:ridge/features/practice/presentation/widgets/sprint_countdown_badge.dart';
import 'package:ridge/features/practice/presentation/widgets/survival_lives_badge.dart';

/// The practice session's app bar — title plus whichever live badge the
/// mode calls for (a Sprint countdown, a Survival heart row). Split out
/// of `PracticeSessionScreen` to keep that screen under the project's
/// 500-line limit as the session surface grows (the live-keyboard toggle
/// lands here too).
class SessionAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the session app bar.
  const new({
    required this.title,
    this.countdown,
    this.survival,
    this.actions = const [],
    super.key,
  });

  /// The current snippet's display title — for Sprint this may already
  /// have advanced past the one the route was pushed with (SPEC.md §5.2's
  /// seamless mid-session queue).
  final String title;

  /// Remaining Sprint time, or `null` for modes without a clock.
  final Duration? countdown;

  /// The live Survival run state, or `null` for other modes.
  final SurvivalRunTracker? survival;

  /// Extra trailing actions the owner screen contributes (the live
  /// keyboard toggle).
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      title: Text(title),
      actions: [
        if (countdown != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: SprintCountdownBadge(remaining: countdown!)),
          ),
        if (survival != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: SurvivalLivesBadge(tracker: survival!)),
          ),
        ...actions,
      ],
    );
  }
}
