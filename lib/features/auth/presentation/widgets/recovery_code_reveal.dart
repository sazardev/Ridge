import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';

/// The one-time recovery-code reveal (SPEC.md §7.2): shown exactly once
/// — right after registering, or right after a successful recovery —
/// with copy-to-clipboard and an explicit "I saved it" acknowledgement,
/// since the code is the *only* way back into the account if the
/// password is ever forgotten.
class RecoveryCodeReveal extends StatelessWidget {
  /// Creates the reveal for [code].
  const new({required this.code, required this.onConfirmed, super.key});

  /// The plaintext code, formatted by the server as groups of five.
  final String code;

  /// Called once the user confirms they saved it.
  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.keyRound300, size: 40, color: colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          l10n.accountRecoveryCodeTitle,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.accountRecoveryCodeBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: ShapeDecoration(
            color: colorScheme.surfaceContainerHigh,
            shape: AppShapes.of(context).largeShape,
          ),
          child: SelectableText(
            code,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall
                ?.copyWith(letterSpacing: 1.5, color: colorScheme.onSurface)
                .tabular,
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: code));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.accountRecoveryCodeCopied)),
            );
          },
          icon: const Icon(LucideIcons.copy300, size: 18),
          label: Text(l10n.accountRecoveryCodeCopy),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onConfirmed,
            child: Text(l10n.accountRecoveryCodeSaved),
          ),
        ),
      ],
    );
  }
}
