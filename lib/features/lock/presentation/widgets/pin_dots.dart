import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:just_in_time/core/theme/app_motion.dart';

/// Row of dots that fill in as PIN digits are entered, with a restrained
/// shake when [errorTick] changes — the only "loud" motion in the whole
/// design system, reserved for a genuine mistake.
class PinDots extends StatelessWidget {
  const new({
    required this.length,
    required this.filled,
    required this.errorTick,
    super.key,
  });

  final int length;
  final int filled;
  final int errorTick;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final row = Row(
      key: ValueKey('pin-dots-$errorTick'),
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 18),
          AnimatedContainer(
            duration: AppMotion.effectsFast,
            curve: AppMotion.spatial,
            width: i < filled ? 18 : 14,
            height: i < filled ? 18 : 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ],
    );

    if (errorTick == 0) return row;
    return row.animate().shakeX(amount: 8, hz: 7, duration: 380.ms);
  }
}
