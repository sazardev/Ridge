import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:share_plus/share_plus.dart';

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
          onShare: () => _shareLesson(overview.path.id, lesson.id),
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
          onShare: () => _shareLesson(overview.path.id, nextLesson.id),
        ),
      );
    };
  }

  /// Resolves [pathId]/[lessonId] against [overviews] and, if found,
  /// replaces the current route with `practice`'s session route for that
  /// lesson — used by `LessonDeepLinkScreen` so an external link (or a
  /// future v2 push notification, STACK.md §14) lands straight on the
  /// exercise it names instead of the path's lesson list. Returns whether
  /// a match was found, so the caller can fall back to an error state
  /// instead of assuming success.
  static bool openLessonById(
    BuildContext context,
    List<LearningPathOverview> overviews,
    LearningPathId pathId,
    LessonId lessonId,
  ) {
    LearningPathOverview? overview;
    for (final candidate in overviews) {
      if (candidate.path.id == pathId) {
        overview = candidate;
        break;
      }
    }
    if (overview == null) return false;

    final lessons = overview.path.lessons;
    var index = -1;
    for (var i = 0; i < lessons.length; i++) {
      if (lessons[i].id == lessonId) {
        index = i;
        break;
      }
    }
    if (index == -1) return false;

    final lesson = lessons[index];
    final snippet = overview.snippetsById[lesson.snippetId];
    if (snippet == null) return false;
    final resolvedPathId = overview.path.id;

    context.pushReplacement(
      '/practice/session',
      extra: (
        snippet: snippet,
        mode: PracticeMode.learningRouteLesson(lessonId: lesson.id.value),
        onContinue: continueCallbackFor(context, overview, index),
        onShare: () => _shareLesson(resolvedPathId, lesson.id),
      ),
    );
    return true;
  }

  /// Builds the `ridge://` link that opens straight into [lessonId] of
  /// [pathId] — the reverse of [openLessonById]. `app` is an arbitrary
  /// placeholder host so [Uri.path] alone already equals the route
  /// [openLessonById] resolves (see `deep_link_providers.dart`).
  static Uri shareableLessonUri(LearningPathId pathId, LessonId lessonId) =>
      Uri(
        scheme: 'ridge',
        host: 'app',
        path: '/practice/${pathId.value}/lessons/${lessonId.value}',
      );

  /// Opens the OS share sheet with [shareableLessonUri] for [pathId]/
  /// [lessonId] — the `onShare` every `/practice/session` entry point in
  /// this file wires up, only ever surfaced once that session's result
  /// screen shows a pass (`PracticeSessionScreen`'s own gating).
  static void _shareLesson(LearningPathId pathId, LessonId lessonId) {
    unawaited(
      SharePlus.instance.share(
        ShareParams(uri: shareableLessonUri(pathId, lessonId)),
      ),
    );
  }
}
