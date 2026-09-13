import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';

/// Replaces `KeystrokeCaptureField` when `PracticeSessionScreen` finds no
/// physical/Bluetooth keyboard attached (Android only — see
/// `HardwareKeyboardRepositoryImpl`). Capture only ever reacts to real
/// hardware key events (STACK.md §2.8), so without one this screen would
/// otherwise sit silently unresponsive to on-screen taps; this explains
/// why, and disappears on its own the moment a keyboard connects — no
/// manual retry, since `PracticeSessionScreen` watches the same stream
/// this notice would.
class KeyboardRequiredNotice extends StatelessWidget {
  /// Creates the notice.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.errorContainer,
                ),
                child: Icon(
                  LucideIcons.keyboardOff,
                  size: 44,
                  color: colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.practiceKeyboardRequiredTitle,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.practiceKeyboardRequiredBody,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
