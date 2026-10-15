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

/// Registers a Registered Account from the current Guest Profile
/// (SPEC.md §7.2's "Migración desde Invitado"): username + password, no
/// email. Once the account exists, the screen switches to the one-time
/// recovery-code reveal — the code is the only way back into the
/// account, so it gets its own full step before the user can leave.
class RegisterAccountScreen extends ConsumerStatefulWidget {
  /// Creates the registration screen.
  const new({super.key});

  @override
  ConsumerState<RegisterAccountScreen> createState() =>
      _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends ConsumerState<RegisterAccountScreen> {
  late final TextEditingController _usernameController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _scrollController = ScrollController();
  bool _submitting = false;
  String? _errorText;
  String? _recoveryCode;

  @override
  void initState() {
    super.initState();
    final displayName =
        ref.read(activeProfileControllerProvider).value?.username ?? '';
    _usernameController = TextEditingController(
      text: AccountUsername.suggestFromDisplayName(displayName) ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (password != _confirmController.text) {
      setState(() => _errorText = l10n.accountPasswordMismatch);
      return;
    }
    final usernameResult = AccountUsername.parse(username);
    if (usernameResult.isErr) {
      setState(() => _errorText = l10n.accountErrorInvalidInput);
      return;
    }
    final passwordResult = AccountPassword.parse(password);
    if (passwordResult.isErr) {
      setState(() => _errorText = l10n.accountErrorInvalidInput);
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final result = await ref
        .read(registerAccountUseCaseProvider)
        .call(username: username, password: password);
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
      _recoveryCode = result.valueOrNull!.recoveryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final recoveryCode = _recoveryCode;

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
                      child: recoveryCode != null
                          ? RecoveryCodeReveal(
                              code: recoveryCode,
                              onConfirmed: () => Navigator.of(context).pop(),
                            )
                          : _buildForm(l10n, colorScheme, textTheme),
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

  Widget _buildForm(
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.cloud300,
          size: 40,
          color: colorScheme.primary,
        ).poppedIn(context, 0),
        const SizedBox(height: 24),
        Text(
          l10n.accountRegisterTitle,
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ).staggeredIn(context, 1),
        const SizedBox(height: 8),
        Text(
          l10n.accountRegisterSubtitle,
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
            helperText: l10n.accountUsernameHint,
          ),
        ).staggeredIn(context, 2),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          enabled: !_submitting,
          obscureText: true,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l10n.accountPasswordLabel),
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
          onSubmitted: _submitting ? null : (_) => _submit(),
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
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.accountRegisterAction,
                      key: const ValueKey('label'),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
