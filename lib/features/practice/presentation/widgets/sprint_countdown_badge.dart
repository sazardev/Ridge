import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';

/// How much time remains before a countdown is considered "urgent" enough
/// to switch to the error color — a last-seconds visual cue (SPEC.md
/// §5.2).
const _urgentThreshold = Duration(seconds: 10);

/// Small pill showing the time left in a Sprint countdown (SPEC.md
/// §5.2), formatted `mm:ss`. Turns to the error color in the final
/// seconds as a visual cue that time is almost up.
class SprintCountdownBadge extends StatelessWidget {
  /// Creates the badge showing [remaining] time left.
  const new({required this.remaining, super.key});

  /// Time left in the countdown. Never negative in practice — the
  /// controller clamps to zero once the deadline is reached.
  final Duration remaining;

  String get _formatted {
    final totalSeconds = remaining > Duration.zero
        ? (remaining.inMilliseconds / 1000).ceil()
        : 0;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isUrgent = remaining <= _urgentThreshold;

    return AnimatedContainer(
      duration: AppMotion.effectsDefault,
      curve: AppMotion.effects,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        shape: AppShapes.of(context).fullShape,
        color: isUrgent ? colors.errorContainer : colors.secondaryContainer,
      ),
      child: Text(
        _formatted,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: isUrgent
              ? colors.onErrorContainer
              : colors.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
