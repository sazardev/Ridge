import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/window/window_bar.dart';
import 'package:just_in_time/features/lock/presentation/providers/lock_providers.dart';
import 'package:just_in_time/features/lock/presentation/widgets/numeric_keypad.dart';
import 'package:just_in_time/features/lock/presentation/widgets/pin_dots.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Which of the two flows [LockScreen] is running.
enum LockScreenMode {
  /// Asks for the existing PIN once and unlocks the session on a match.
  unlock,

  /// Asks for a new PIN twice (set, then confirm) and persists it.
  setup,
}

/// Gate screen used two ways: as the redirect target when the app is
/// locked (`unlock`), and pushed from Settings to create a new PIN
/// (`setup`, which asks twice and pops `true` on success).
class LockScreen extends ConsumerStatefulWidget {
  /// Creates the lock screen for the given [mode].
  const new({required this.mode, super.key});

  /// Which flow this instance runs — see [LockScreenMode].
  final LockScreenMode mode;

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  static const _pinLength = 4;

  String _buffer = '';
  String? _firstEntry;
  int _errorTick = 0;
  bool _submitting = false;

  bool get _isSetup => widget.mode == LockScreenMode.setup;
  bool get _isConfirmStep => _isSetup && _firstEntry != null;

  @override
  void initState() {
    super.initState();
    if (widget.mode == LockScreenMode.unlock) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final biometricEnabled =
            ref
                .read(settingsControllerProvider)
                .value
                ?.appLockBiometricEnabled ??
            false;
        if (biometricEnabled) unawaited(_authenticateWithBiometrics());
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final reason = AppLocalizations.of(context).lockBiometricReason;
    final result = await ref.read(authenticateWithBiometricsUseCaseProvider)(
      reason: reason,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result.valueOrNull ?? false) {
      ref.read(appLockSessionProvider.notifier).unlock();
      context.go('/practice');
      return;
    }
    if (result.isErr) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.lockBiometricError)));
    }
  }

  void _onDigit(String digit) {
    if (_submitting || _buffer.length >= _pinLength) return;
    setState(() => _buffer += digit);
    if (_buffer.length == _pinLength) unawaited(_submit());
  }

  void _onBackspace() {
    if (_buffer.isEmpty) return;
    setState(() => _buffer = _buffer.substring(0, _buffer.length - 1));
  }

  Future<void> _submit() async {
    if (_isSetup) {
      await _submitSetup();
    } else {
      await _submitUnlock();
    }
  }

  Future<void> _submitUnlock() async {
    setState(() => _submitting = true);
    final result = await ref.read(verifyPinUseCaseProvider)(_buffer);
    if (!mounted) return;
    if (result.valueOrNull ?? false) {
      ref.read(appLockSessionProvider.notifier).unlock();
      context.go('/practice');
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() {
      _errorTick++;
      _buffer = '';
      _submitting = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.lockError)));
  }

  Future<void> _submitSetup() async {
    if (_firstEntry == null) {
      setState(() {
        _firstEntry = _buffer;
        _buffer = '';
      });
      return;
    }

    if (_firstEntry != _buffer) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _errorTick++;
        _firstEntry = null;
        _buffer = '';
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.lockMismatch)));
      return;
    }

    setState(() => _submitting = true);
    final result = await ref.read(setPinUseCaseProvider)(_buffer);
    if (!mounted) return;
    if (result.isOk) {
      Navigator.of(context).pop(true);
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() {
      _errorTick++;
      _firstEntry = null;
      _buffer = '';
      _submitting = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.lockSaveError)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final biometricEnabled =
        ref.watch(settingsControllerProvider).value?.appLockBiometricEnabled ??
        false;
    final showBiometricButton =
        widget.mode == LockScreenMode.unlock && biometricEnabled;

    final title = switch (widget.mode) {
      LockScreenMode.unlock => l10n.lockTitle,
      LockScreenMode.setup =>
        _isConfirmStep ? l10n.lockConfirmTitle : l10n.lockSetTitle,
    };
    final subtitle = switch (widget.mode) {
      LockScreenMode.unlock => l10n.lockSubtitle,
      LockScreenMode.setup => l10n.lockSetSubtitle,
    };

    return Scaffold(
      body: Column(
        children: [
          const WindowBar(),
          Expanded(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.lock,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: AppMotion.effectsDefault,
                        child: Text(
                          title,
                          key: ValueKey(title),
                          style: textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      PinDots(
                        length: _pinLength,
                        filled: _buffer.length,
                        errorTick: _errorTick,
                      ),
                      const SizedBox(height: 40),
                      NumericKeypad(
                        onDigit: _onDigit,
                        onBackspace: _onBackspace,
                      ),
                      if (showBiometricButton) ...[
                        const SizedBox(height: 24),
                        TextButton.icon(
                          onPressed: _submitting
                              ? null
                              : _authenticateWithBiometrics,
                          icon: const Icon(LucideIcons.fingerprint),
                          label: Text(l10n.lockUseBiometrics),
                        ),
                      ],
                    ],
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
