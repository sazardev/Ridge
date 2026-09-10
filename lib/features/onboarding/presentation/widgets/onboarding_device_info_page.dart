import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Onboarding step previewing the platform/OS/device
/// `EnsureDeviceInfoUseCase` will auto-detect and store once the Guest
/// Profile exists — purely informational here (see
/// `onboardingDeviceInfoProvider`'s doc comment for why nothing is
/// persisted from this page).
class OnboardingDeviceInfoPage extends ConsumerWidget {
  /// Creates the device-info preview step.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final deviceInfo = ref.watch(onboardingDeviceInfoProvider).value;

    final chips = [
      if (deviceInfo?.platform != null)
        _InfoChip(
          icon: LucideIcons.monitorSmartphone,
          text: deviceInfo!.platform!,
        ),
      if (deviceInfo?.operatingSystemVersion?.isNotEmpty ?? false)
        _InfoChip(
          icon: LucideIcons.server,
          text: deviceInfo!.operatingSystemVersion!,
        ),
      if (deviceInfo?.deviceModel?.isNotEmpty ?? false)
        _InfoChip(
          icon: LucideIcons.circuitBoard,
          text: deviceInfo!.deviceModel!,
        ),
    ];

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
                      LucideIcons.monitorSmartphone,
                      size: 56,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    l10n.onboardingDeviceTitle,
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.onboardingDeviceDescription,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: chips,
                    ),
                  ],
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

class _InfoChip extends StatelessWidget {
  const new({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
