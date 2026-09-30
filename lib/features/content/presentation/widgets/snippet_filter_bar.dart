import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/app_filter_chip.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';

/// Horizontally-scrollable rows of filter chips — language (only when
/// more than one language exists in the catalog), difficulty, and
/// category — for narrowing the snippet browser's list.
class SnippetFilterBar extends StatelessWidget {
  /// Creates the filter bar over the currently selected filters.
  const new({
    required this.languages,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.categories,
    required this.selectedDifficulty,
    required this.selectedCategory,
    required this.onDifficultyChanged,
    required this.onCategoryChanged,
    super.key,
  });

  /// Every language actually present in the catalog, in display order.
  final List<ProgrammingLanguage> languages;

  /// The currently selected language, or `null` for "all".
  final ProgrammingLanguage? selectedLanguage;

  /// Called with the newly selected language (or `null` to clear it).
  final ValueChanged<ProgrammingLanguage?> onLanguageChanged;

  /// Every category actually present in the catalog for the currently
  /// selected language(s), in display order — rendering every enum value
  /// instead would show Go-only or SQL-only categories under a language
  /// that has none.
  final List<ContentCategory> categories;

  /// The currently selected difficulty, or `null` for "all".
  final Difficulty? selectedDifficulty;

  /// The currently selected category, or `null` for "all".
  final ContentCategory? selectedCategory;

  /// Called with the newly selected difficulty (or `null` to clear it).
  final ValueChanged<Difficulty?> onDifficultyChanged;

  /// Called with the newly selected category (or `null` to clear it).
  final ValueChanged<ContentCategory?> onCategoryChanged;

  static const _rowHeight = 48.0;
  static const _chipPadding = EdgeInsets.symmetric(horizontal: 4);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        if (languages.length > 1)
          SizedBox(
            height: _rowHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: _chipPadding,
                  child: AppFilterChip(
                    label: Text(l10n.libraryFilterAll),
                    selected: selectedLanguage == null,
                    onSelected: (_) => onLanguageChanged(null),
                  ),
                ),
                for (final language in languages)
                  Padding(
                    padding: _chipPadding,
                    child: AppFilterChip(
                      label: Text(language.label(l10n)),
                      selected: selectedLanguage == language,
                      onSelected: (_) => onLanguageChanged(
                        selectedLanguage == language ? null : language,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(
          height: _rowHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: _chipPadding,
                child: AppFilterChip(
                  label: Text(l10n.libraryFilterAll),
                  selected: selectedDifficulty == null,
                  onSelected: (_) => onDifficultyChanged(null),
                ),
              ),
              for (final difficulty in Difficulty.values)
                Padding(
                  padding: _chipPadding,
                  child: AppFilterChip(
                    label: Text(difficulty.label(l10n)),
                    selected: selectedDifficulty == difficulty,
                    onSelected: (_) => onDifficultyChanged(
                      selectedDifficulty == difficulty ? null : difficulty,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: _rowHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: _chipPadding,
                child: AppFilterChip(
                  label: Text(l10n.libraryFilterAll),
                  selected: selectedCategory == null,
                  onSelected: (_) => onCategoryChanged(null),
                ),
              ),
              for (final category in categories)
                Padding(
                  padding: _chipPadding,
                  child: AppFilterChip(
                    label: Text(category.label(l10n)),
                    selected: selectedCategory == category,
                    onSelected: (_) => onCategoryChanged(
                      selectedCategory == category ? null : category,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
