// Widget tests for the `/practice/:pathId/lessons/:lessonId` resolver —
// exercises the real `LessonNavigation.openLessonById` + `GoRouter`
// wiring end to end, standing in for a tapped share link (or, once v2
// push notifications exist, a notification tap).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:ridge/features/learning_paths/presentation/screens/lesson_deep_link_screen.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';

const _snippet = Snippet(
  id: SnippetId('go-test-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Test snippet',
  titleEs: 'Fragmento de prueba',
  code: 'x := 1',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Explanation.',
  explanationEs: 'Explicación.',
);

final _lesson = Lesson(
  id: const LessonId('go-foundations-v1-01'),
  snippetId: _snippet.id,
  titleEn: 'Lesson one',
  titleEs: 'Lección uno',
  order: 0,
);

final _path = LearningPath(
  id: const LearningPathId('go-foundations-v1'),
  language: ProgrammingLanguage.go,
  titleEn: 'Go foundations',
  titleEs: 'Fundamentos de Go',
  descriptionEn: 'A test path.',
  descriptionEs: 'Una ruta de prueba.',
  tagEn: 'Fundamentals',
  tagEs: 'Fundamentos',
  lessons: [_lesson],
);

final _overviews = <LearningPathOverview>[
  (path: _path, snippetsById: {_snippet.id: _snippet}),
];

class _FakeLearningPathsController extends LearningPathsController {
  @override
  Future<List<LearningPathOverview>> build() async => _overviews;
}

GoRouter _routerAt(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: '/practice/:pathId/lessons/:lessonId',
      builder: (context, state) => LessonDeepLinkScreen(
        pathId: LearningPathId(state.pathParameters['pathId']!),
        lessonId: LessonId(state.pathParameters['lessonId']!),
      ),
    ),
    GoRoute(
      path: '/practice/session',
      builder: (context, state) {
        final extra =
            state.extra!
                as ({
                  Snippet snippet,
                  PracticeMode mode,
                  VoidCallback? onContinue,
                  VoidCallback? onShare,
                });
        return Scaffold(body: Text('session:${extra.snippet.id.value}'));
      },
    ),
  ],
);

Future<void> _pump(WidgetTester tester, GoRouter router) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        learningPathsControllerProvider.overrideWith(
          _FakeLearningPathsController.new,
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("a valid lesson link lands on that lesson's practice session", (
    tester,
  ) async {
    await _pump(
      tester,
      _routerAt('/practice/go-foundations-v1/lessons/go-foundations-v1-01'),
    );

    expect(find.text('session:go-test-001'), findsOneWidget);
  });

  testWidgets('an unknown lesson id falls back instead of crashing', (
    tester,
  ) async {
    await _pump(
      tester,
      _routerAt('/practice/go-foundations-v1/lessons/does-not-exist'),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.commonSomethingWrong), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
