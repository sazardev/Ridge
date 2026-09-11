import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/lesson_navigation.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';

/// Resolves the `/practice/:pathId/lessons/:lessonId` route (an incoming
/// share link, or — once v2 push notifications exist, STACK.md §14 — a
/// notification tap) straight into that lesson's practice session, via
/// [LessonNavigation.openLessonById]. Never shown as a destination in its
/// own right: it renders only long enough to resolve [pathId]/[lessonId]
/// against the loaded catalog, then replaces itself.
class LessonDeepLinkScreen extends ConsumerStatefulWidget {
  /// Creates the resolver for [lessonId] within [pathId].
  const new({required this.pathId, required this.lessonId, super.key});

  /// The path the linked lesson belongs to.
  final LearningPathId pathId;

  /// The linked lesson within [pathId].
  final LessonId lessonId;

  @override
  ConsumerState<LessonDeepLinkScreen> createState() =>
      _LessonDeepLinkScreenState();
}

class _LessonDeepLinkScreenState extends ConsumerState<LessonDeepLinkScreen> {
  /// Set once resolution has been attempted against a populated catalog —
  /// deliberately does *not* count an empty overview list (the catalog
  /// seed hasn't landed yet on a cold start, `LearningPathsController`'s
  /// own doc comment) as a final answer, only a genuine "no such
  /// path/lesson" lookup miss.
  bool _handled = false;

  /// Whether resolution ran against a non-empty catalog and still found
  /// no match — a stale or malformed link, distinct from "still loading".
  bool _notFound = false;

  void _resolveOnceLoaded(List<LearningPathOverview> overviews) {
    if (_handled || overviews.isEmpty) return;
    _handled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final opened = LessonNavigation.openLessonById(
        context,
        overviews,
        widget.pathId,
        widget.lessonId,
      );
      if (!opened) setState(() => _notFound = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overviewsAsync = ref.watch(learningPathsControllerProvider);

    return overviewsAsync.when(
      data: (overviews) {
        _resolveOnceLoaded(overviews);
        if (_notFound) {
          return Scaffold(body: Center(child: Text(l10n.commonSomethingWrong)));
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text(l10n.commonSomethingWrong))),
    );
  }
}
