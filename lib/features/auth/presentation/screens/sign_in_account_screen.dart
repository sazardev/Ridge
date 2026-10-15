import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/core/window/window_bar.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';
import 'package:ridge/features/auth/presentation/auth_error_message.dart';
import 'package:ridge/features/auth/presentation/providers/auth_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';

/// Signs into an existing Registered Account (SPEC.md §7.2) with the
/// username + password pair and links the on-device profile to it — the
/// client SDK keeps the session from there on.
class SignInAccountScreen extends ConsumerStatefulWidget {
  /// Creates the sign-in screen.
  const new({super.key});

  @override
  ConsumerState<SignInAccountScreen> createState() =>
      _SignInAccountScreenState();
}

class _SignInAccountScreenState extends ConsumerState<SignInAccountScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();
  bool _submitting = false;
  String? _errorText;

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
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final result = await ref
        .read(signInAccountUseCaseProvider)
        .call(
          username: _usernameController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (result.isErr) {
      setState(() {
        _submitting = false;
        _errorText = accountErrorMessage(result.failureOrNull!, l10n);
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.logIn300,
                            size: 40,
                            color: colorScheme.primary,
                          ).poppedIn(context, 0),
                          const SizedBox(height: 24),
                          Text(
                            l10n.accountSignInTitle,
                            style: textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ).staggeredIn(context, 1),
                          const SizedBox(height: 8),
                          Text(
                            l10n.accountSignInSubtitle,
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
                            controller: _passwordController,
                            enabled: !_submitting,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: l10n.accountPasswordLabel,
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
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        l10n.accountSignInAction,
                                        key: const ValueKey('label'),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _submitting
                                ? null
                                : () => context.push('/account/recover'),
                            child: Text(l10n.accountForgotPassword),
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
