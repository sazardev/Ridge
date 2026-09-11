import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/presentation/content_labels.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/services/lesson_status_resolver.dart';
import 'package:ridge/features/learning_paths/presentation/learning_paths_labels.dart';
import 'package:ridge/features/learning_paths/presentation/lesson_navigation.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';

/// The Practice tab's default, structured home (SPEC.md §5.7): a
/// language-scoped roadmap of curated lessons — start with the basics,
/// unlock the next one only once the previous is passed. This is the
/// smart, deliberate ordering the catalog's curator already authored
/// (`RecomputeLessonProgressUseCase`'s unlock-gating), never a random
/// pick — free-form Zen/Sprint/Precision practice lives on its own,
/// separate tab (see `FreePracticeScreen`).
///
/// The language selector only ever shows the languages that actually
/// have at least one bundled path (SPEC.md §18 — only Go exists in v1),
/// so adding a second language's curriculum later is purely a content
/// change: this screen never needs a new case.
class LearningPathsScreen extends ConsumerStatefulWidget {
  /// Creates the roadmap screen.
  const new({super.key});

  @override
  ConsumerState<LearningPathsScreen> createState() =>
      _LearningPathsScreenState();
}

class _LearningPathsScreenState extends ConsumerState<LearningPathsScreen> {
  ProgrammingLanguage? _selectedLanguage;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overviewsAsync = ref.watch(learningPathsControllerProvider);
    final progressAsync = ref.watch(lessonProgressControllerProvider);

    // No `AppBar` title here: the nav rail/bar destination already reads
    // "Practice" right next to this screen, so repeating it would just be
    // noise (`SafeArea` stands in for the status-bar inset an `AppBar`
    // would otherwise have handled).
    return Scaffold(
      body: SafeArea(
        child: overviewsAsync.when(
          data: (overviews) {
            if (overviews.isEmpty) {
              return Center(child: Text(l10n.learningPathsEmptyState));
            }

            // Enum declaration order (Go first), not alphabetical — the
            // selector's default is the first present language, and that
            // should be the primary free-practice language, matching
            // `FreePracticeScreen`/`SnippetBrowserScreen`.
            final present = {for (final o in overviews) o.path.language};
            final languages = [
              for (final language in ProgrammingLanguage.values)
                if (present.contains(language)) language,
            ];
            _selectedLanguage ??= languages.first;
            final selected = languages.contains(_selectedLanguage)
                ? _selectedLanguage!
                : languages.first;

            final visible = [
              for (final overview in overviews)
                if (overview.path.language == selected) overview,
            ];
            final progress = progressAsync.value ?? const {};

            return Column(
              children: [
                if (languages.length > 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _LanguageSelector(
                      languages: languages,
                      selected: selected,
                      onSelected: (language) =>
                          setState(() => _selectedLanguage = language),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(label: Text(selected.label(l10n))),
                    ),
                  ),
                Expanded(
                  child: visible.isEmpty
                      ? Center(child: Text(l10n.learningPathsEmptyState))
                      : KeyboardScrollShortcuts(
                          controller: _scrollController,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: visible.length,
                            itemBuilder: (context, index) {
                              final overview = visible[index];
                              final completedCount = overview.path.lessons
                                  .where(
                                    (lesson) =>
                                        progress[lesson.id] ==
                                        LessonStatus.completed,
                                  )
                                  .length;
                              final nextIndex =
                                  LessonStatusResolver.findNextIndex(
                                    overview.path.lessons,
                                    progress,
                                  );
                              final totalLessons = overview.path.lessons.length;
                              final progressFraction = totalLessons == 0
                                  ? 0.0
                                  : completedCount / totalLessons;
                              // The entry-point difficulty (first lesson's
                              // snippet) — a quick "how hard is this to
                              // start" signal, shown as a chip instead of
                              // making the learner open the path to find
                              // out.
                              final entryDifficulty = totalLessons == 0
                                  ? null
                                  : overview
                                        .snippetsById[overview
                                            .path
                                            .lessons
                                            .first
                                            .snippetId]
                                        ?.difficulty;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                shape: AppShapes.of(context).mediumShape,
                                // `Card` defaults to `Clip.none`, so without
                                // this its child `ListTile`'s ink splash
                                // paints as a plain rectangle overflowing
                                // past the card's own rounded corners —
                                // this makes the ripple actually respect
                                // whatever corner style (SPEC.md's Settings
                                // "Corner style") the card itself is using.
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    8,
                                  ),
                                  title: Text(overview.path.titleFor(context)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 2),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          _MiniChip(
                                            label: overview.path.language.label(
                                              l10n,
                                            ),
                                          ),
                                          _MiniChip(
                                            label: overview.path.tagFor(
                                              context,
                                            ),
                                          ),
                                          if (entryDifficulty != null)
                                            _MiniChip(
                                              label: entryDifficulty.label(
                                                l10n,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        overview.path.descriptionFor(context),
                                      ),
                                    ],
                                  ),
                                  trailing: nextIndex == null
                                      ? null
                                      : _PlayProgressButton(
                                          progress: progressFraction,
                                          tooltip:
                                              l10n.learningPathsContinueAction,
                                          onPressed: () =>
                                              LessonNavigation.startLesson(
                                                context,
                                                overview,
                                                nextIndex,
                                              ),
                                        ),
                                  onTap: () => context.push(
                                    '/practice/${overview.path.id.value}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text(l10n.commonSomethingWrong)),
        ),
      ),
    );
  }
}

/// The roadmap card's Play affordance — a plain, unfilled icon button
/// wrapped in a chunky progress ring, so the ring itself (not a separate
/// bar or a filled button background) is what reads as the path's
/// progress (lessons completed / total).
class _PlayProgressButton extends StatelessWidget {
  const new({
    required this.progress,
    required this.tooltip,
    required this.onPressed,
  });

  final double progress;
  final String tooltip;
  final VoidCallback onPressed;

  static const _diameter = 84.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
          IconButton(
            iconSize: 22,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 72, height: 72),
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              foregroundColor: theme.colorScheme.primary,
              hoverColor: theme.colorScheme.primary.withValues(alpha: 0.14),
              highlightColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
            // A right-pointing triangle's visual weight sits left of its
            // bounding box's geometric center, so an unshifted play glyph
            // reads as off-center inside a perfectly round button — this
            // padding nudges it back to looking centered.
            icon: const Padding(
              padding: EdgeInsetsDirectional.only(start: 2),
              child: Icon(LucideIcons.play300),
            ),
            tooltip: tooltip,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

/// A small, dense identifying badge (language / topic / entry level) —
/// deliberately terser than a full [Chip] so 2-3 of these read as quick
/// tags rather than competing with the card's title for attention.
class _MiniChip extends StatelessWidget {
  const new({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppShapes.squircleRadius(AppRadius.full),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const new({
    required this.languages,
    required this.selected,
    required this.onSelected,
  });

  final List<ProgrammingLanguage> languages;
  final ProgrammingLanguage selected;
  final ValueChanged<ProgrammingLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<ProgrammingLanguage>(
      segments: [
        for (final language in languages)
          ButtonSegment(value: language, label: Text(language.label(l10n))),
      ],
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: (values) => onSelected(values.first),
    );
  }
}
