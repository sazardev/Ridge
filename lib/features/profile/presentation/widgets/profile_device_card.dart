import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A read-only card of the active profile's auto-detected platform, OS
/// version, and device model (`EnsureDeviceInfoUseCase`) — unlike
/// `ProfileAboutCard`'s self-expression flair, nothing here is
/// user-editable, so there's no edit action. Renders nothing while
/// detection hasn't landed yet (right after profile creation, before the
/// next `deviceInfoSync` tick), rather than showing an empty card.
class ProfileDeviceCard extends StatelessWidget {
  /// Creates the card for [profile].
  const new({required this.profile, super.key});

  /// The profile whose auto-detected device info this card renders.
  final GuestProfile profile;

  bool get _hasAnything =>
      profile.platform != null ||
      (profile.operatingSystemVersion?.isNotEmpty ?? false) ||
      (profile.deviceModel?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    if (!_hasAnything) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.profileDeviceTitle, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (profile.platform != null)
                  Chip(
                    avatar: const Icon(LucideIcons.monitorSmartphone, size: 18),
                    label: Text(profile.platform!),
                  ),
                if (profile.operatingSystemVersion?.isNotEmpty ?? false)
                  Chip(
                    avatar: const Icon(LucideIcons.server, size: 18),
                    label: _ChipLabel(profile.operatingSystemVersion!),
                  ),
                if (profile.deviceModel?.isNotEmpty ?? false)
                  Chip(
                    avatar: const Icon(LucideIcons.circuitBoard, size: 18),
                    label: _ChipLabel(profile.deviceModel!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A [Chip] label capped to a sane width — OS version/device-model
/// strings (e.g. a full Windows build string) can be long enough to
/// overflow a narrow phone on their own.
class _ChipLabel extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
