import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:just_in_time/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/services/lesson_status_resolver.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:just_in_time/features/learning_paths/presentation/lesson_navigation.dart';
import 'package:just_in_time/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:just_in_time/features/learning_paths/presentation/widgets/lesson_tree_tile.dart';

/// One learning path's ordered lesson tree (SPEC.md §5.7): locked/
/// unlocked/completed visual state per lesson. Tapping an
/// unlocked-or-completed lesson starts a Precision-style run against it
/// via `LessonNavigation`, which also drives the "Continue" chain — this
/// screen never builds its own session runner.
///
/// Every entry auto-scrolls straight to the next lesson to work on
/// (`LessonStatusResolver.findNextIndex`) rather than always landing at
/// the top — once a path has several completed lessons, starting at the
/// top would mean scrolling past everything already done just to find
/// where to pick back up.
class LessonDetailScreen extends ConsumerStatefulWidget {
  /// Creates the lesson detail screen for [pathId].
  const new({required this.pathId, super.key});

  /// The path whose lessons this screen renders.
  final LearningPathId pathId;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  /// Attached to whichever tile is currently "the next lesson to work
  /// on" so [_scrollToNextIfNeeded] has something to scroll into view.
  final GlobalKey _nextLessonKey = GlobalKey();

  /// Guards the auto-scroll to firing at most once per time this screen
  /// is entered — later rebuilds (e.g. a session finishing while this
  /// screen sits underneath it) must never yank the list back down
  /// again while the user is browsing on their own.
  bool _hasScrolledToNext = false;

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  LearningPathOverview? _overviewFor(List<LearningPathOverview> overviews) {
    for (final overview in overviews) {
      if (overview.path.id == widget.pathId) return overview;
    }
    return null;
  }

  void _scrollToNextIfNeeded(int? nextIndex) {
    if (nextIndex == null || _hasScrolledToNext) return;
    _hasScrolledToNext = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _nextLessonKey.currentContext;
      if (target == null) return;
      Scrollable.ensureVisible(
        target,
        alignment: 0.3,
        duration: AppMotion.spatialDefault,
        curve: AppMotion.spatial,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overviewsAsync = ref.watch(learningPathsControllerProvider);
    final progressAsync = ref.watch(lessonProgressControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.learningPathsLessonListTitle)),
      body: overviewsAsync.when(
        data: (overviews) {
          final overview = _overviewFor(overviews);
          if (overview == null) {
            return Center(child: Text(l10n.commonSomethingWrong));
          }
          final progress = progressAsync.value ?? const {};
          final orderedLessons = overview.path.lessons;
          final nextIndex = LessonStatusResolver.findNextIndex(
            orderedLessons,
            progress,
          );
          _scrollToNextIfNeeded(nextIndex);

          return KeyboardScrollShortcuts(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  for (var index = 0; index < orderedLessons.length; index++)
                    _lessonTile(
                      context,
                      overview,
                      orderedLessons,
                      progress,
                      index,
                      isNext: index == nextIndex,
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.commonSomethingWrong)),
      ),
    );
  }

  Widget _lessonTile(
    BuildContext context,
    LearningPathOverview overview,
    List<Lesson> orderedLessons,
    Map<LessonId, LessonStatus> progress,
    int index, {
    required bool isNext,
  }) {
    final lesson = orderedLessons[index];
    final status = LessonStatusResolver.resolve(
      lesson,
      orderedLessons,
      progress,
    );
    final snippet = overview.snippetsById[lesson.snippetId];
    return KeyedSubtree(
      key: isNext ? _nextLessonKey : null,
      child: LessonTreeTile(
        lesson: lesson,
        status: status,
        snippet: snippet,
        onTap: status == LessonStatus.locked || snippet == null
            ? null
            : () => LessonNavigation.startLesson(context, overview, index),
      ),
    );
  }
}
