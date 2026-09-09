import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/presentation/content_labels.dart';

/// Two horizontally-scrollable rows of filter chips — difficulty and
/// category — for narrowing the snippet browser's list.
class SnippetFilterBar extends StatelessWidget {
  /// Creates the filter bar over the currently selected filters.
  const new({
    required this.selectedDifficulty,
    required this.selectedCategory,
    required this.onDifficultyChanged,
    required this.onCategoryChanged,
    super.key,
  });

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
        SizedBox(
          height: _rowHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: _chipPadding,
                child: FilterChip(
                  label: Text(l10n.libraryFilterAll),
                  selected: selectedDifficulty == null,
                  onSelected: (_) => onDifficultyChanged(null),
                ),
              ),
              for (final difficulty in Difficulty.values)
                Padding(
                  padding: _chipPadding,
                  child: FilterChip(
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
                child: FilterChip(
                  label: Text(l10n.libraryFilterAll),
                  selected: selectedCategory == null,
                  onSelected: (_) => onCategoryChanged(null),
                ),
              ),
              for (final category in ContentCategory.values)
                Padding(
                  padding: _chipPadding,
                  child: FilterChip(
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
