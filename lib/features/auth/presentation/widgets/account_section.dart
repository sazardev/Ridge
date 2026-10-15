import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/firebase/firebase_bootstrap.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/auth/presentation/auth_error_message.dart';
import 'package:ridge/features/auth/presentation/providers/auth_providers.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';

/// The account card on the Profile screen — the one place the two
/// identity types of SPEC.md §7 are surfaced:
///
/// - Guest Profile: invites the conversion into a Registered Account;
/// - Registered Account: shows the account and offers sign-out and
///   deletion (the store-required in-app deletion path);
/// - Linux: explains accounts aren't available on this platform at all
///   (no Firebase client exists there), rather than hiding the section
///   and leaving the user wondering.
class AccountSection extends ConsumerStatefulWidget {
  /// Creates the card for [profile].
  const new({required this.profile, super.key});

  /// The active profile — its `accountUid` decides which state to show.
  final GuestProfile profile;

  @override
  ConsumerState<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends ConsumerState<AccountSection> {
  bool _busy = false;

  Future<bool> _confirmDestructive({
    required String title,
    required String body,
    required String confirmLabel,
  }) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      animationStyle: AppMotion.dialog,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.accountCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final result = await ref.read(signOutAccountUseCaseProvider)();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isErr) {
      _showError(accountErrorMessage(result.failureOrNull!, l10n));
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _confirmDestructive(
      title: l10n.accountDeleteConfirmTitle,
      body: l10n.accountDeleteConfirmBody,
      confirmLabel: l10n.accountDeleteConfirmAction,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final result = await ref.read(deleteAccountUseCaseProvider)();
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isErr) {
      _showError(accountErrorMessage(result.failureOrNull!, l10n));
    }
    // On success every local table is gone, so the router's guest-profile
    // redirect takes over on its own.
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirebaseSupportedPlatform) return const _UnsupportedCard();
    return widget.profile.accountUid == null
        ? const _GuestAccountCard()
        : _RegisteredAccountCard(
            username:
                ref.watch(currentAccountProvider).value?.username ??
                widget.profile.username,
            busy: _busy,
            onSignOut: _signOut,
            onDelete: _deleteAccount,
          );
  }
}

/// The guest-state card: explains the value of converting and links to
/// either registration or sign-in.
class _GuestAccountCard extends StatelessWidget {
  /// Creates the guest-state card.
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.userRound300, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.accountGuestTitle,
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accountGuestBody,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/account/register'),
                icon: const Icon(LucideIcons.cloud300, size: 18),
                label: Text(l10n.accountCreateAction),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => context.push('/account/sign-in'),
                child: Text(l10n.accountSignInAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The registered-state card: the account, sign-out and deletion.
class _RegisteredAccountCard extends StatelessWidget {
  /// Creates the registered-state card.
  const new({
    required this.username,
    required this.busy,
    required this.onSignOut,
    required this.onDelete,
  });

  final String username;
  final bool busy;
  final VoidCallback onSignOut;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.shieldCheck300, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.accountRegisteredTitle,
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        username,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: busy ? null : onSignOut,
                icon: const Icon(LucideIcons.logOut300, size: 18),
                label: Text(l10n.accountSignOutAction),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: busy ? null : onDelete,
                icon: Icon(
                  LucideIcons.trash2300,
                  size: 18,
                  color: colorScheme.error,
                ),
                label: Text(
                  l10n.accountDeleteAction,
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Linux-state card: accounts simply don't exist on this platform.
class _UnsupportedCard extends StatelessWidget {
  /// Creates the unsupported-platform card.
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(LucideIcons.cloudOff300, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.accountGuestTitle, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    l10n.accountUnsupportedBody,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
