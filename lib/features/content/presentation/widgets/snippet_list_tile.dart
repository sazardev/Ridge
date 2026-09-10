import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/content/presentation/widgets/practice_mode_picker_sheet.dart';

/// A single catalog entry in the snippet browser: title, difficulty and
/// category badges, and a one-line code preview.
class SnippetListTile extends StatelessWidget {
  /// Creates the list tile for [snippet].
  const new({required this.snippet, super.key});

  /// The catalog entry this tile renders.
  final Snippet snippet;

  String get _codePreview {
    final firstNonBlankLine = snippet.code
        .split('\n')
        .firstWhere(
          (line) => line.trim().isNotEmpty,
          orElse: () => snippet.code,
        );
    return firstNonBlankLine.trim();
  }

  /// Shows the mode picker and, on a choice, pushes the session route —
  /// a non-shell route (mirrors `/lock`'s shape) so the nav rail/bottom
  /// bar disappears during capture. Used both from the catalog browser
  /// and (reused verbatim) from the Practice hub's recommended-snippet
  /// card.
  Future<void> _startPractice(BuildContext context) async {
    final modeKind = await showPracticeModePickerSheet(context);
    if (modeKind == null || !context.mounted) return;
    unawaited(
      context.push(
        '/practice/session',
        extra: (snippet: snippet, modeKind: modeKind),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: AppShapes.of(context).mediumShape,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(snippet.titleFor(context), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(label: Text(snippet.difficulty.label(l10n))),
                Chip(label: Text(snippet.category.label(l10n))),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _codePreview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // Explicit GeistMono, even though it's already the app-wide
              // default (STACK.md §2.5): code previews/snippet text are
              // the one place monospace is a *hard requirement*, not a
              // styling default that could quietly change later.
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: AppFonts.mono,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => unawaited(_startPractice(context)),
                child: Text(l10n.snippetPracticeAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
