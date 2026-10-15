import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/core/window/window_bar.dart';
import 'package:ridge/features/auth/domain/value_objects/account_password.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';
import 'package:ridge/features/auth/presentation/auth_error_message.dart';
import 'package:ridge/features/auth/presentation/providers/auth_providers.dart';
import 'package:ridge/features/auth/presentation/widgets/recovery_code_reveal.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';

/// Recovers a Registered Account with its one-time recovery code
/// (SPEC.md §7.2): username + code + new password in, a freshly minted
/// code out — the old one dies the instant this succeeds, so the new one
/// gets the same reveal-before-you-leave treatment as registration.
class RecoverAccountScreen extends ConsumerStatefulWidget {
  /// Creates the recovery screen.
  const new({super.key});

  @override
  ConsumerState<RecoverAccountScreen> createState() =>
      _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends ConsumerState<RecoverAccountScreen> {
  final _usernameController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _scrollController = ScrollController();
  bool _submitting = false;
  String? _errorText;
  String? _newRecoveryCode;

  @override
  void initState() {
    super.initState();
    final displayName =
        ref.read(activeProfileControllerProvider).value?.username ?? '';
    _usernameController.text =
        AccountUsername.suggestFromDisplayName(displayName) ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final password = _passwordController.text;
    if (password != _confirmController.text) {
      setState(() => _errorText = l10n.accountPasswordMismatch);
      return;
    }
    final usernameResult = AccountUsername.parse(_usernameController.text);
    final passwordResult = AccountPassword.parse(password);
    if (usernameResult.isErr || passwordResult.isErr) {
      setState(() => _errorText = l10n.accountErrorInvalidInput);
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final result = await ref
        .read(recoverAccountUseCaseProvider)
        .call(
          username: _usernameController.text,
          recoveryCode: _codeController.text,
          newPassword: password,
        );
    if (!mounted) return;
    if (result.isErr) {
      setState(() {
        _submitting = false;
        _errorText = accountErrorMessage(result.failureOrNull!, l10n);
      });
      return;
    }
    setState(() {
      _submitting = false;
      _newRecoveryCode = result.valueOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final newCode = _newRecoveryCode;

    return Scaffold(
      body: Column(
        children: [
          const WindowBar(),
          Expanded(
            child: SafeArea(
              child: Center(
                child: KeyboardScrollShortcuts(
                  controller: _scrollController,
                  autofocus: false,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: newCode != null
                          ? RecoveryCodeReveal(
                              code: newCode,
                              onConfirmed: () => Navigator.of(context).pop(),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.keyRound300,
                                  size: 40,
                                  color: colorScheme.primary,
                                ).poppedIn(context, 0),
                                const SizedBox(height: 24),
                                Text(
                                  l10n.accountRecoverTitle,
                                  style: textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ).staggeredIn(context, 1),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.accountRecoverSubtitle,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: _usernameController,
                                  autofocus: true,
                                  enabled: !_submitting,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: l10n.accountUsernameLabel,
                                  ),
                                ).staggeredIn(context, 2),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _codeController,
                                  enabled: !_submitting,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: l10n.accountRecoveryCodeLabel,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _passwordController,
                                  enabled: !_submitting,
                                  obscureText: true,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: l10n.accountNewPasswordLabel,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _confirmController,
                                  enabled: !_submitting,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: l10n.accountConfirmPasswordLabel,
                                    errorText: _errorText,
                                  ),
                                  onSubmitted: _submitting
                                      ? null
                                      : (_) => _submit(),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: _submitting ? null : _submit,
                                    child: AnimatedSwitcher(
                                      duration: AppMotion.effectsDefault,
                                      child: _submitting
                                          ? const SizedBox(
                                              key: ValueKey('loading'),
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              l10n.accountRecoverAction,
                                              key: const ValueKey('label'),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
