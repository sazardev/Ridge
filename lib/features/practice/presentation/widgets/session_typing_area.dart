import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/practice_session_status.dart';
import 'package:ridge/features/practice/domain/services/survival_run_tracker.dart';
import 'package:ridge/features/practice/presentation/widgets/keyboard_required_notice.dart';
import 'package:ridge/features/practice/presentation/widgets/keystroke_capture_field.dart';

/// The session's typing half: the optional live Survival stats row plus
/// the capture field (or the Android "connect a keyboard" notice). Split
/// out of `PracticeSessionScreen` for the 500-line budget — the live 3D
/// keyboard strip mounts here too, right above the capture field.
class SessionTypingArea extends StatelessWidget {
  /// Creates the typing area for [snippet] under [mode].
  const new({
    required this.snippet,
    required this.mode,
    required this.status,
    required this.keyboardConnected,
    required this.survival,
    this.keyboardStrip,
    super.key,
  });

  /// The snippet being typed.
  final Snippet snippet;

  /// Which practice mode is driving the session.
  final PracticeMode mode;

  /// The session state machine's current status, gating the live row.
  final PracticeSessionStatus status;

  /// Whether a physical/Bluetooth keyboard is attached (Android-only
  /// ambiguity; every other platform always reports `true`).
  final bool keyboardConnected;

  /// The live Survival run state, or `null` for other modes.
  final SurvivalRunTracker? survival;

  /// An optional strip rendered between the stats row and the capture
  /// field — the live 3D keyboard, when the user turned it on.
  final Widget? keyboardStrip;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('typing-area'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status == PracticeSessionStatus.running && survival != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _LiveStatsRow(survival: survival!),
          ),
        if (keyboardStrip != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: keyboardStrip,
          ),
        Expanded(
          child: keyboardConnected
              ? KeystrokeCaptureField(snippet: snippet, mode: mode)
              : const KeyboardRequiredNotice(),
        ),
      ],
    );
  }
}

/// Small live readout for Survival (§5.8) only — the run-local score,
/// current combo multiplier, and snippets cleared, since lives/score are
/// the mode's whole point. Every other mode's typing progress is carried
/// entirely by `TypingProgressBar` now, with no numeric chars-typed/
/// accuracy readout competing with it.
class _LiveStatsRow extends StatelessWidget {
  const new({required this.survival});

  final SurvivalRunTracker survival;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtleStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l10n.practiceLiveScore(survival.score), style: subtleStyle),
        Text(
          l10n.practiceLiveMultiplier(survival.multiplier),
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          l10n.practiceLiveSnippets(survival.snippetsCleared),
          style: subtleStyle,
        ),
      ],
    );
  }
}
