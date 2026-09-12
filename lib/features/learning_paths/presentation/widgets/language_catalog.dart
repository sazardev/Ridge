import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/domain/entities/language_progress.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/services/language_progress_calculator.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';

/// The Practice tab's language catalog (SPEC.md §5.7): one card per
/// language that actually has bundled paths, each showing its aggregated
/// lesson progress. Picking a card activates that language — the Practice
/// tab then shows its guide.
///
/// Deliberately just the tiles: the progress bar carries the state, so
/// there is no page header and no per-language action label.
class LanguageCatalog extends StatelessWidget {
  /// Creates the catalog over the given overviews/progress.
  const new({
    required this.overviews,
    required this.progress,
    required this.onLanguageSelected,
    this.activeLanguage,
    this.scrollController,
    super.key,
  });

  /// Every bundled path, joined against `content` by
  /// `LearningPathsController` — the catalog only ever offers languages
  /// present here.
  final List<LearningPathOverview> overviews;

  /// Cached per-lesson statuses (`LessonProgressController`).
  final Map<LessonId, LessonStatus> progress;

  /// Called with the language of the card the user tapped.
  final ValueChanged<ProgrammingLanguage> onLanguageSelected;

  /// The currently active language, if any — its card gets a check so the
  /// pushed catalog shows where the user currently stands.
  final ProgrammingLanguage? activeLanguage;

  /// Optional controller so callers that wrap this in
  /// `KeyboardScrollShortcuts` share one scroll position.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final languages = [
      for (final language in ProgrammingLanguage.values)
        if (overviews.any((overview) => overview.path.language == language))
          language,
    ];
    final paths = [for (final overview in overviews) overview.path];
    const calculator = LanguageProgressCalculator();

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      children: [
        for (final language in languages)
          _LanguageCard(
            language: language,
            progress: calculator.compute(
              language: language,
              paths: paths,
              progress: progress,
            ),
            isActive: language == activeLanguage,
            onTap: () => onLanguageSelected(language),
          ),
      ],
    );
  }
}

/// One language's catalog card: its name and a progress bar — nothing
/// else, since the bar itself already says whether the language is
/// untouched, in progress, or complete.
class _LanguageCard extends StatelessWidget {
  const new({
    required this.language,
    required this.progress,
    required this.isActive,
    required this.onTap,
  });

  final ProgrammingLanguage language;
  final LanguageProgress progress;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: AppShapes.of(context).mediumShape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(language.label(l10n), style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      language.blurb(l10n),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: AppShapes.squircleRadius(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: progress.fraction,
                        minHeight: 6,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.check300,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
