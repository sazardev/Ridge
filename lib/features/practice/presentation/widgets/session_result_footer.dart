import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_typography.dart';

/// The result screen's fixed (never-scrolls) footer: Retry/Continue side
/// by side — Retry on the left, Continue on the right, matching how a
/// desktop user's eye already reads Escape/Enter-style dialogs — plus
/// an optional "info" action above them opening the full-screen code +
/// explanation reading view.
///
/// Pinned to the bottom of the screen (via `Scaffold.bottomNavigationBar`)
/// rather than living inside the scrollable metrics panel: on a longer
/// result (many weak characters, a tall snippet) the actions would
/// otherwise scroll out of reach, forcing a scroll just to continue.
class SessionResultFooter extends StatelessWidget {
  /// Creates the footer. Renders nothing at all if both [onRetry] and
  /// [onContinue] are `null` (Zen/Sprint have no pass/fail gate, so
  /// there's nothing to pin here).
  const new({this.onRetry, this.onContinue, this.onShowInfo, super.key});

  /// Callback for the "Retry" action — `null` for modes without a
  /// pass/fail gate.
  final VoidCallback? onRetry;

  /// Callback for "Continue to next lesson" — only ever non-`null` for a
  /// passing `learning_paths` lesson attempt with a next lesson to jump
  /// to (SPEC.md §5.7).
  final VoidCallback? onContinue;

  /// Opens the full-screen "what did you just type?" reading view —
  /// `null` (hiding the info action) when the snippet has no explanation
  /// text to show.
  final VoidCallback? onShowInfo;

  @override
  Widget build(BuildContext context) {
    if (onRetry == null && onContinue == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onShowInfo != null) ...[
                Center(
                  child: TextButton.icon(
                    onPressed: onShowInfo,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(LucideIcons.info300),
                    label: _ButtonLabelWithKeyHint(
                      label: l10n.practiceResultLearnMoreTitle,
                      keyHint: 'I',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Row(
                children: [
                  if (onRetry != null)
                    Expanded(
                      child: onContinue != null
                          ? OutlinedButton(
                              onPressed: onRetry,
                              child: _ButtonLabelWithKeyHint(
                                label: l10n.practiceResultRetry,
                                keyHint: 'R',
                              ),
                            )
                          : FilledButton.tonal(
                              onPressed: onRetry,
                              child: _ButtonLabelWithKeyHint(
                                label: l10n.practiceResultRetry,
                                keyHint: 'R',
                              ),
                            ),
                    ),
                  if (onRetry != null && onContinue != null)
                    const SizedBox(width: 12),
                  if (onContinue != null)
                    Expanded(
                      child: FilledButton(
                        onPressed: onContinue,
                        child: _ButtonLabelWithKeyHint(
                          label: l10n.practiceResultContinue,
                          keyHint: 'ENTER',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A button's label plus a small keyboard-shortcut hint chip (SPEC.md's
/// desktop-usability ask) — "ENTER"/"R" are literal key-cap labels, not
/// translated content (same treatment as e.g. "cpm" elsewhere in this
/// panel), so they read the same in every locale.
///
/// Reads its color from [DefaultTextStyle] rather than a fixed one, so
/// the hint chip automatically contrasts correctly whichever button
/// style wraps it (`FilledButton`, `FilledButton.tonal`, or
/// `OutlinedButton` each set a different foreground here).
class _ButtonLabelWithKeyHint extends StatelessWidget {
  const new({required this.label, required this.keyHint});

  final String label;
  final String keyHint;

  @override
  Widget build(BuildContext context) {
    final foreground =
        DefaultTextStyle.of(context).style.color ??
        Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: foreground.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            keyHint,
            style: TextStyle(
              fontFamily: AppFonts.mono,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: foreground.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}
