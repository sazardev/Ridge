// Widget tests for `ResumeCourseCard` — renders nothing with nothing to
// resume, and the path/lesson summary when there is.
// `resumeCourseProvider` is overridden directly with fixed data so this
// stays a pure rendering test (mirrors `warm_up_card_test.dart`).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:ridge/features/learning_paths/presentation/widgets/resume_course_card.dart';

LearningPathOverview _overview() {
  const path = LearningPath(
    id: LearningPathId('go-foundations-v1'),
    language: ProgrammingLanguage.go,
    titleEn: 'Go: Foundations',
    titleEs: 'Go: Fundamentos',
    descriptionEn: 'Description.',
    descriptionEs: 'Descripción.',
    tagEn: 'Tag',
    tagEs: 'Etiqueta',
    lessons: [
      Lesson(
        id: LessonId('go-foundations-v1-0'),
        snippetId: SnippetId('go-foundations-001'),
        titleEn: 'Hello, Go',
        titleEs: 'Hola, Go',
        order: 0,
      ),
      Lesson(
        id: LessonId('go-foundations-v1-1'),
        snippetId: SnippetId('go-foundations-002'),
        titleEn: 'Error handling',
        titleEs: 'Manejo de errores',
        order: 1,
      ),
    ],
  );
  return (path: path, snippetsById: const {});
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required Future<ResumeCourseCardData?> Function(Ref ref) override,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [resumeCourseProvider.overrideWith(override)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ResumeCourseCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders nothing while there is nothing to resume', (
    tester,
  ) async {
    await _pumpCard(tester, override: (ref) async => null);

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('shows the path and its next lesson with the lesson count', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      override: (ref) async => (overview: _overview(), nextLessonIndex: 1),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.learningPathsResumeTitle), findsOneWidget);
    expect(find.text('Go: Foundations'), findsOneWidget);
    expect(
      find.text(l10n.learningPathsResumeLessonLabel(2, 2, 'Error handling')),
      findsOneWidget,
    );
    expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNotNull);
  });
}
