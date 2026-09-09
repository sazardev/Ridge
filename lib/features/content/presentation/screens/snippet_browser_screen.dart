import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/presentation/providers/content_providers.dart';
import 'package:just_in_time/features/content/presentation/widgets/snippet_filter_bar.dart';
import 'package:just_in_time/features/content/presentation/widgets/snippet_list_tile.dart';

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
  Difficulty? _difficulty;
  ContentCategory? _category;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalogAsync = ref.watch(snippetCatalogControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.libraryTitle)),
      body: Column(
        children: [
          SnippetFilterBar(
            selectedDifficulty: _difficulty,
            selectedCategory: _category,
            onDifficultyChanged: (value) => setState(() => _difficulty = value),
            onCategoryChanged: (value) => setState(() => _category = value),
          ),
          Expanded(
            child: catalogAsync.when(
              data: (snippets) {
                final filtered = [
                  for (final snippet in snippets)
                    if ((_difficulty == null ||
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
                    itemBuilder: (context, index) =>
                        SnippetListTile(snippet: filtered[index]),
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
    );
  }
}
