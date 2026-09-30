import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_motion.dart';

/// Row of dots marking progress through the onboarding [PageView] — the
/// active dot stretches into a pill, mirroring `PinDots`' fill animation.
class OnboardingPageDots extends StatelessWidget {
  /// Creates the indicator for [length] pages, highlighting [activeIndex].
  const new({required this.length, required this.activeIndex, super.key});

  /// Total number of onboarding pages.
  final int length;

  /// Index of the currently visible page.
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          AnimatedContainer(
            duration: AppMotion.spatialFast,
            curve: AppMotion.bouncy,
            width: i == activeIndex ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: i == activeIndex
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ],
    );
  }
}
