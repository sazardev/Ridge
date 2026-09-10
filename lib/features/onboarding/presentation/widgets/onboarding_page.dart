import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:ridge/core/theme/app_motion.dart';

/// Content for a single onboarding step: an icon, a title, and a
/// supporting line. Plain data so the step list stays declarative and
/// separate from the l10n lookups that build it — see `OnboardingScreen`.
class OnboardingPageData {
  /// Creates one onboarding step's content.
  const new({
    required this.icon,
    required this.title,
    required this.description,
  });

  /// The step's hero glyph, shown inside a soft tonal circle.
  final IconData icon;

  /// The step's short headline.
  final String title;

  /// The step's one-line supporting copy.
  final String description;
}

/// Renders one [OnboardingPageData] centered in the available space, with a
/// restrained fade-and-rise entrance — the only motion here beyond the
/// [PageView]'s own horizontal slide, since the design system reserves
/// louder motion for genuine feedback (see `PinDots`), not for scenery.
class OnboardingPage extends StatelessWidget {
  /// Creates the page for [data].
  const new({required this.data, super.key});

  /// The step content this page renders.
  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      data.icon,
                      size: 56,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    data.title,
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: AppMotion.spatialDefault, curve: AppMotion.enter)
        .slideY(
          begin: 0.06,
          end: 0,
          duration: AppMotion.spatialDefault,
          curve: AppMotion.spatial,
        );
  }
}
