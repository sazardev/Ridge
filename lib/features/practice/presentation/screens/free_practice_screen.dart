import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/presentation/providers/content_providers.dart';
import 'package:just_in_time/features/content/presentation/widgets/practice_mode_picker_sheet.dart';
import 'package:just_in_time/features/practice/presentation/widgets/quick_mode_tile.dart';

/// Free-form practice (SPEC.md §5.1–5.3) — Zen/Sprint/Precision shortcuts
/// on an arbitrary catalog snippet, plus a link out to browse the whole
/// catalog by hand. Deliberately its own tab, one over from Practice's
/// default structured roadmap (`LearningPathsScreen`) — this is where you
/// come to practice *something*, not *the next thing*.
class FreePracticeScreen extends ConsumerStatefulWidget {
  /// Creates the free-practice screen.
  const new({super.key});

  @override
  ConsumerState<FreePracticeScreen> createState() => _FreePracticeScreenState();
}

class _FreePracticeScreenState extends ConsumerState<FreePracticeScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Pushes the session route directly in [modeKind], bypassing the mode
  /// picker — the quick-mode tiles already say which mode they start.
  void _startDirect(BuildContext context, Snippet snippet, String modeKind) {
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
    final textTheme = Theme.of(context).textTheme;

    final catalogAsync = ref.watch(snippetCatalogControllerProvider);
    final catalog = catalogAsync.value ?? const <Snippet>[];
    // Any catalog entry works equally well here — free practice has no
    // notion of "the next thing," only "something to type right now."
    final quickModeSnippet = catalog.isEmpty
        ? null
        : catalog[Random().nextInt(catalog.length)];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.freePracticeTitle)),
      body: KeyboardScrollShortcuts(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          children: [
            Text(l10n.practiceHubQuickModesTitle, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            if (quickModeSnippet == null && catalogAsync.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (quickModeSnippet == null)
              Text(
                l10n.practiceHubNoSnippetsAvailable,
                style: textTheme.bodyMedium,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: QuickModeTile(
                      icon: Icons.self_improvement_rounded,
                      label: l10n.practiceModeZen,
                      subtitle: l10n.practiceModeZenSubtitle,
                      onTap: () => _startDirect(
                        context,
                        quickModeSnippet,
                        practiceModeKindZen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickModeTile(
                      icon: Icons.bolt_rounded,
                      label: l10n.practiceModeSprint60,
                      subtitle: l10n.practiceModeSprintSubtitle,
                      onTap: () => _startDirect(
                        context,
                        quickModeSnippet,
                        practiceModeKindSprint60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickModeTile(
                      icon: Icons.track_changes_rounded,
                      label: l10n.practiceModePrecision,
                      subtitle: l10n.practiceModePrecisionSubtitle,
                      onTap: () => _startDirect(
                        context,
                        quickModeSnippet,
                        practiceModeKindPrecision,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/practice/browse'),
                icon: const Icon(Icons.menu_book_outlined),
                label: Text(l10n.practiceHubBrowseAllAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
