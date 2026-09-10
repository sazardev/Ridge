import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';

/// Shared "start/continue a learning-path lesson" navigation — one
/// source of truth for how a lesson attempt is pushed and chained, used
/// identically by the Lessons list (`LessonDetailScreen`) and the
/// Practice-tab roadmap (`LearningPathsScreen`) so jumping straight into
/// "the next lesson" from Home behaves exactly like tapping it from the
/// full list.
abstract final class LessonNavigation {
  /// Pushes `practice`'s session route for lesson [index] of [overview],
  /// wired to recurse into the next lesson via [continueCallbackFor] on
  /// a pass.
  static void startLesson(
    BuildContext context,
    LearningPathOverview overview,
    int index,
  ) {
    final lesson = overview.path.lessons[index];
    final snippet = overview.snippetsById[lesson.snippetId]!;
    unawaited(
      context.push(
        '/practice/session',
        extra: (
          snippet: snippet,
          mode: PracticeMode.learningRouteLesson(lessonId: lesson.id.value),
          onContinue: continueCallbackFor(context, overview, index),
        ),
      ),
    );
  }

  /// Builds the "Continue to next lesson" action for the lesson at
  /// [index] — `null` if it's the path's last lesson (nothing to
  /// continue to) or the next lesson's snippet hasn't loaded. Recurses
  /// so a whole path can be breezed through via repeated "Continue"
  /// taps, never needing a trip back to a lesson list in between.
  ///
  /// Uses `pushReplacement` (not another `push`) so continuing through
  /// several lessons in a row keeps exactly one session screen on top,
  /// rather than stacking a new route per lesson.
  static VoidCallback? continueCallbackFor(
    BuildContext context,
    LearningPathOverview overview,
    int index,
  ) {
    final nextIndex = index + 1;
    final lessons = overview.path.lessons;
    if (nextIndex >= lessons.length) return null;
    final nextLesson = lessons[nextIndex];
    final nextSnippet = overview.snippetsById[nextLesson.snippetId];
    if (nextSnippet == null) return null;

    return () {
      context.pushReplacement(
        '/practice/session',
        extra: (
          snippet: nextSnippet,
          mode: PracticeMode.learningRouteLesson(lessonId: nextLesson.id.value),
          onContinue: continueCallbackFor(context, overview, nextIndex),
        ),
      );
    };
  }
}
