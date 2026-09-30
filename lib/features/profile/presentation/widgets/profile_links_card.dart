import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:url_launcher/url_launcher.dart';

/// A card of the active profile's optional external links — GitHub and
/// personal website (`UpdateProfileCustomizationUseCase` normalizes both
/// before they're stored). Each row opens in the OS browser when tapped;
/// renders nothing while neither link has been set, same as
/// `ProfileDeviceCard` does for undetected device info.
class ProfileLinksCard extends StatelessWidget {
  /// Creates the card for [profile].
  const new({required this.profile, this.onOpenUrl, super.key});

  /// The profile whose GitHub/website links this card renders.
  final GuestProfile profile;

  /// Overrides how a tapped link is opened — tests inject a recorder here
  /// instead of letting `url_launcher` reach a platform channel that isn't
  /// registered in the test binding. Production leaves it `null`.
  final ValueChanged<Uri>? onOpenUrl;

  bool get _hasAnything =>
      (profile.githubUsername?.isNotEmpty ?? false) ||
      (profile.websiteUrl?.isNotEmpty ?? false);

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
            Text(l10n.profileLinksTitle, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            if (profile.githubUsername case final username?)
              _LinkRow(
                icon: LucideIcons.gitBranch300,
                label: 'github.com/$username',
                onTap: () => _open(Uri.parse('https://github.com/$username')),
              ),
            if (profile.websiteUrl case final website?)
              _LinkRow(
                icon: LucideIcons.globe300,
                label: _displayWebsite(website),
                onTap: () => _open(Uri.parse(website)),
              ),
          ],
        ),
      ),
    );
  }

  void _open(Uri url) {
    final onOpen = onOpenUrl;
    if (onOpen != null) {
      onOpen(url);
      return;
    }
    unawaited(_launchInBrowser(url));
  }

  Future<void> _launchInBrowser(Uri url) async {
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } on Exception {
      // Best-effort: a platform without a URL handler simply does nothing.
    }
  }

  /// Shows the website without its scheme — `https://example.com/x` reads
  /// as `example.com/x`, which is what the user recognizes, while the full
  /// normalized URL stays in the profile data.
  String _displayWebsite(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return url;
    final path = uri.path == '/' ? '' : uri.path;
    return '${uri.host}$path';
  }
}

/// One tappable link row — icon, address, and the muted external-link
/// glyph that signals "this leaves the app".
class _LinkRow extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Tooltip(
      message: l10n.profileOpenLinkAction,
      child: BouncyTap(
        enabled: true,
        child: InkWell(
          onTap: onTap,
          customBorder: AppShapes.of(context).mediumShape,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  LucideIcons.externalLink300,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
