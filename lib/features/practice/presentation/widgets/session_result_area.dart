import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/practice/domain/entities/practice_session_status.dart';
import 'package:ridge/features/practice/domain/entities/session_metrics.dart';
import 'package:ridge/features/practice/domain/services/survival_run_tracker.dart';
import 'package:ridge/features/practice/presentation/widgets/session_result_panel.dart';

/// The session's finished/result half — the focusable, scrollable result
/// panel (or the persist-failure message). Split out of
/// `PracticeSessionScreen` for the 500-line budget; the screen keeps the
/// transition gating and the pinned `SessionResultFooter`.
class SessionResultArea extends StatelessWidget {
  /// Creates the result area for the given session outcome.
  const new({
    required this.status,
    required this.error,
    required this.metrics,
    required this.passed,
    required this.survival,
    required this.onShare,
    required this.scrollController,
    required this.focusNode,
    super.key,
  });

  /// The session state machine's status (only `result` renders content).
  final PracticeSessionStatus status;

  /// The persist-failure message, or `null` on a clean finish.
  final String? error;

  /// The computed metrics — non-null exactly when [error] is null.
  final SessionMetrics? metrics;

  /// This session's pass/fail outcome (SPEC.md §5.3), `null` for modes
  /// without a threshold.
  final bool? passed;

  /// The final arcade state of a Survival run, or `null` for other modes.
  final SurvivalRunTracker? survival;

  /// Shares a link to the lesson this session belonged to, when it did.
  final VoidCallback? onShare;

  /// Backs the result panel's scroll view — the screen binds Home/End/
  /// PageUp/PageDown to it.
  final ScrollController scrollController;

  /// Holds focus over the result area so the screen's `CallbackShortcuts`
  /// (Enter/R/I/Home/End/PageUp/PageDown) keep receiving key events once
  /// the capture field unmounts.
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final metrics = this.metrics;
    return Focus(
      focusNode: focusNode,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          key: const ValueKey('result-area'),
          duration: AppMotion.spatialDefault,
          switchInCurve: AppMotion.enter,
          switchOutCurve: AppMotion.exit,
          transitionBuilder: springSwitcherTransition,
          child: switch (status) {
            PracticeSessionStatus.result
                when error == null && metrics != null =>
              SingleChildScrollView(
                key: const ValueKey('result'),
                controller: scrollController,
                padding: const EdgeInsets.only(bottom: 16),
                child: SessionResultPanel(
                  metrics: metrics,
                  passed: passed,
                  survival: survival,
                  onShare: onShare,
                ),
              ),
            PracticeSessionStatus.result => Center(
              key: const ValueKey('error'),
              child: Text(error ?? ''),
            ),
            // The screen mounts this area only in `result`, so this
            // catch-all is unreachable in practice — kept so the switch
            // stays exhaustive.
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
