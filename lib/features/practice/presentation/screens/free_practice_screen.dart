import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/presentation/content_labels.dart';
import 'package:just_in_time/features/content/presentation/providers/content_providers.dart';
import 'package:just_in_time/features/content/presentation/widgets/practice_mode_picker_sheet.dart';
import 'package:just_in_time/features/practice/presentation/widgets/quick_mode_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Free-form practice (SPEC.md §5.1–5.3, §5.8) — Zen/Sprint/Precision/
/// Survival shortcuts on an arbitrary catalog snippet, plus a link out to
/// browse the whole catalog by hand. Deliberately its own tab, one over
/// from Practice's default structured roadmap (`LearningPathsScreen`) —
/// this is where you come to practice *something*, not *the next thing*.
class FreePracticeScreen extends ConsumerStatefulWidget {
  /// Creates the free-practice screen.
  const new({super.key});

  @override
  ConsumerState<FreePracticeScreen> createState() => _FreePracticeScreenState();
}

class _FreePracticeScreenState extends ConsumerState<FreePracticeScreen> {
  final _scrollController = ScrollController();

  /// The language quick modes draw from — defaults to Go; Bash is
  /// course-only (see `bash_foundations_v1.json`), so it's only picked
  /// here once the user explicitly selects it.
  ProgrammingLanguage _language = ProgrammingLanguage.go;

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
    // Languages actually present in the catalog, in enum declaration
    // order; fall back to Go (or the first present) if the remembered
    // selection no longer exists.
    final languages = [
      for (final language in ProgrammingLanguage.values)
        if (catalog.any((snippet) => snippet.language == language)) language,
    ];
    final selectedLanguage = languages.contains(_language)
        ? _language
        : (languages.isEmpty ? null : languages.first);
    final pool = selectedLanguage == null
        ? catalog
        : [
            for (final snippet in catalog)
              if (snippet.language == selectedLanguage) snippet,
          ];
    // Any catalog entry works equally well here — free practice has no
    // notion of "the next thing," only "something to type right now."
    final quickModeSnippet = pool.isEmpty
        ? null
        : pool[Random().nextInt(pool.length)];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.freePracticeTitle)),
      body: KeyboardScrollShortcuts(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          children: [
            if (languages.length > 1) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: SegmentedButton<ProgrammingLanguage>(
                  segments: [
                    for (final language in languages)
                      ButtonSegment(
                        value: language,
                        label: Text(language.label(l10n)),
                      ),
                  ],
                  selected: {selectedLanguage!},
                  showSelectedIcon: false,
                  onSelectionChanged: (values) =>
                      setState(() => _language = values.first),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(l10n.practiceHubQuickModesTitle, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            if (quickModeSnippet == null && catalogAsync.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (quickModeSnippet == null)
              Text(
                l10n.practiceHubNoSnippetsAvailable,
                style: textTheme.bodyMedium,
              )
            else ...[
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuickModeTile(
                        icon: LucideIcons.brain,
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
                        icon: LucideIcons.zap,
                        label: l10n.practiceModeSprint60,
                        subtitle: l10n.practiceModeSprintSubtitle,
                        onTap: () => _startDirect(
                          context,
                          quickModeSnippet,
                          practiceModeKindSprint60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuickModeTile(
                        icon: LucideIcons.target,
                        label: l10n.practiceModePrecision,
                        subtitle: l10n.practiceModePrecisionSubtitle,
                        onTap: () => _startDirect(
                          context,
                          quickModeSnippet,
                          practiceModeKindPrecision,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickModeTile(
                        icon: LucideIcons.heart600,
                        label: l10n.practiceModeSurvival,
                        subtitle: l10n.practiceModeSurvivalSubtitle,
                        onTap: () => _startDirect(
                          context,
                          quickModeSnippet,
                          practiceModeKindSurvival,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/practice/browse'),
                icon: const Icon(LucideIcons.bookOpen),
                label: Text(l10n.practiceHubBrowseAllAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
