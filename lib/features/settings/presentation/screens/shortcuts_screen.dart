import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:ridge/features/settings/domain/entities/shortcut_binding.dart';
import 'package:ridge/features/settings/domain/services/shortcut_conflict_checker.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:ridge/features/settings/presentation/shortcut_labels.dart';
import 'package:ridge/features/settings/presentation/widgets/settings_section.dart';

/// Lists every customizable global keyboard shortcut and lets the user
/// rebind each one (SPEC.md's keyboard-first requirement, STACK.md
/// §2.5) — reached from Settings' "Atajos de teclado" row.
class ShortcutsScreen extends ConsumerWidget {
  /// Creates the shortcuts screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings =
        ref.watch(settingsControllerProvider).value ?? AppSettings.initial;
    final bindings = settings.shortcutBindings;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shortcutsScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SettingsSection(
            title: l10n.settingsSectionShortcuts,
            children: [
              for (final action in AppShortcutAction.values) ...[
                if (action != AppShortcutAction.values.first)
                  const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(action.label(l10n)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(bindings[action]?.displayLabel ?? '—'),
                      const SizedBox(width: 8),
                      const Icon(LucideIcons.squarePen300, size: 18),
                    ],
                  ),
                  onTap: () => _showCaptureDialog(
                    context: context,
                    ref: ref,
                    l10n: l10n,
                    action: action,
                    bindings: bindings,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

void _showCaptureDialog({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required AppShortcutAction action,
  required Map<AppShortcutAction, ShortcutBinding> bindings,
}) {
  unawaited(
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _ShortcutCaptureDialog(
        action: action,
        bindings: bindings,
        onSave: (binding) {
          unawaited(
            ref
                .read(settingsControllerProvider.notifier)
                .setShortcutBinding(action, binding),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.shortcutsCaptureDialogSaved)),
          );
        },
      ),
    ),
  );
}

/// Every logical key that's a modifier on its own — pressing one alone
/// isn't a candidate combination, it's the prelude to one (same
/// treatment `KeystrokeCaptureField` already gives Shift during
/// practice capture). Not `const`: `LogicalKeyboardKey` overrides `==`,
/// which Dart's const-collection canonicalization disallows.
final Set<LogicalKeyboardKey> _modifierKeys = {
  LogicalKeyboardKey.controlLeft,
  LogicalKeyboardKey.controlRight,
  LogicalKeyboardKey.altLeft,
  LogicalKeyboardKey.altRight,
  LogicalKeyboardKey.shiftLeft,
  LogicalKeyboardKey.shiftRight,
  LogicalKeyboardKey.metaLeft,
  LogicalKeyboardKey.metaRight,
};

class _ShortcutCaptureDialog extends StatefulWidget {
  const new({
    required this.action,
    required this.bindings,
    required this.onSave,
  });

  final AppShortcutAction action;
  final Map<AppShortcutAction, ShortcutBinding> bindings;
  final ValueChanged<ShortcutBinding> onSave;

  @override
  State<_ShortcutCaptureDialog> createState() => _ShortcutCaptureDialogState();
}

class _ShortcutCaptureDialogState extends State<_ShortcutCaptureDialog> {
  String? _errorMessage;

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.handled;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    if (_modifierKeys.contains(event.logicalKey)) {
      return KeyEventResult.handled;
    }

    final l10n = AppLocalizations.of(context);
    final control = HardwareKeyboard.instance.isControlPressed;
    final alt = HardwareKeyboard.instance.isAltPressed;
    final shift = HardwareKeyboard.instance.isShiftPressed;

    if (!control && !alt) {
      setState(() => _errorMessage = l10n.shortcutsCaptureDialogNeedsModifier);
      return KeyEventResult.handled;
    }

    final candidate = ShortcutBinding(
      keyId: event.logicalKey.keyId,
      control: control,
      alt: alt,
      shift: shift,
    );
    final conflict = findShortcutConflict(
      widget.bindings,
      widget.action,
      candidate,
    );
    if (conflict != null) {
      setState(
        () => _errorMessage = l10n.shortcutsCaptureDialogConflict(
          conflict.label(l10n),
        ),
      );
      return KeyEventResult.handled;
    }

    widget.onSave(candidate);
    Navigator.of(context).pop();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(l10n.shortcutsCaptureDialogTitle),
      content: Focus(
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.shortcutsCaptureDialogHint,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? l10n.shortcutsCaptureDialogWaiting,
              style: _errorMessage != null
                  ? textTheme.bodyMedium?.copyWith(color: colorScheme.error)
                  : textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.shortcutsCaptureCancel),
        ),
      ],
    );
  }
}
