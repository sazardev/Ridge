import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/escape_to_pop.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/content/presentation/widgets/snippet_filter_bar.dart';
import 'package:ridge/features/content/presentation/widgets/snippet_list_tile.dart';

/// A filterable list of the seeded catalog — reachable from the Practice
/// hub's "Browse all snippets" action (`/practice/browse`), a pushed
/// non-shell route rather than its own shell tab (folded into Practice
/// per the final five-destination shell).
class SnippetBrowserScreen extends ConsumerStatefulWidget {
  /// Creates the snippet browser screen.
  const new({super.key});

  @override
  ConsumerState<SnippetBrowserScreen> createState() =>
      _SnippetBrowserScreenState();
}

class _SnippetBrowserScreenState extends ConsumerState<SnippetBrowserScreen> {
  // Defaults to Go — Bash content is course-only (see
  // `bash_foundations_v1.json`), so it only appears here once the user
  // explicitly picks the Bash chip (or "All").
  ProgrammingLanguage? _language = ProgrammingLanguage.go;
  Difficulty? _difficulty;
  ContentCategory? _category;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Every language actually present in [snippets], in enum declaration
  /// order (Go first today) — the filter bar hides its language row when
  /// there's only one.
  List<ProgrammingLanguage> _languagesIn(List<Snippet> snippets) {
    final present = {for (final snippet in snippets) snippet.language};
    return [
      for (final language in ProgrammingLanguage.values)
        if (present.contains(language)) language,
    ];
  }

  /// Every category actually present in [snippets] for [language] (or for
  /// every language when [language] is `null`), in enum declaration
  /// order — a Go-only or SQL-only category never renders as a chip under
  /// a language that has no entry for it.
  List<ContentCategory> _categoriesIn(
    List<Snippet> snippets,
    ProgrammingLanguage? language,
  ) {
    final present = {
      for (final snippet in snippets)
        if (language == null || snippet.language == language) snippet.category,
    };
    return [
      for (final category in ContentCategory.values)
        if (present.contains(category)) category,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(snippetCatalogControllerProvider);
    final catalog = catalogAsync.value ?? const <Snippet>[];

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.libraryTitle)),
        body: Column(
          children: [
            SnippetFilterBar(
              languages: _languagesIn(catalog),
              selectedLanguage: _language,
              onLanguageChanged: (value) => setState(() {
                _language = value;
                // A category chip that belonged to the previous language
                // may no longer exist — clear it instead of silently
                // filtering the new language down to nothing.
                if (_category != null &&
                    !_categoriesIn(catalog, value).contains(_category)) {
                  _category = null;
                }
              }),
              categories: _categoriesIn(catalog, _language),
              selectedDifficulty: _difficulty,
              selectedCategory: _category,
              onDifficultyChanged: (value) =>
                  setState(() => _difficulty = value),
              onCategoryChanged: (value) => setState(() => _category = value),
            ),
            Expanded(
              child: catalogAsync.when(
                data: (snippets) {
                  final filtered = [
                    for (final snippet in snippets)
                      if ((_language == null ||
                              snippet.language == _language) &&
                          (_difficulty == null ||
                              snippet.difficulty == _difficulty) &&
                          (_category == null || snippet.category == _category))
                        snippet,
                  ];
                  if (filtered.isEmpty) {
                    return Center(child: Text(l10n.libraryEmptyState));
                  }
                  return KeyboardScrollShortcuts(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => index < 10
                          ? SnippetListTile(snippet: filtered[index])
                                .staggeredIn(context, index)
                          : SnippetListTile(snippet: filtered[index]),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text(l10n.commonSomethingWrong)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
