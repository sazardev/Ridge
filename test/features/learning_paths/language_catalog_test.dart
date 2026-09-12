import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/widgets/language_catalog.dart';

LearningPath _path(String id, ProgrammingLanguage language, int lessonCount) {
  return LearningPath(
    id: LearningPathId(id),
    language: language,
    titleEn: 'Path',
    titleEs: 'Ruta',
    descriptionEn: 'Description.',
    descriptionEs: 'Descripción.',
    tagEn: 'Tag',
    tagEs: 'Etiqueta',
    lessons: [
      for (var index = 0; index < lessonCount; index++)
        Lesson(
          id: LessonId('$id-$index'),
          snippetId: SnippetId('$id-snippet-$index'),
          titleEn: 'Lesson',
          titleEs: 'Lección',
          order: index,
        ),
    ],
  );
}

final _overviews = <LearningPathOverview>[
  (
    path: _path('go-foundations-v1', ProgrammingLanguage.go, 2),
    snippetsById: const {},
  ),
  (
    path: _path('rust-foundations-v1', ProgrammingLanguage.rust, 1),
    snippetsById: const {},
  ),
  (
    path: _path('python-foundations-v1', ProgrammingLanguage.python, 1),
    snippetsById: const {},
  ),
];

// Go is 1/2 (continue), Rust 0/1 (start), Python 1/1 (review).
final _progress = <LessonId, LessonStatus>{
  const LessonId('go-foundations-v1-0'): LessonStatus.completed,
  const LessonId('go-foundations-v1-1'): LessonStatus.unlocked,
  const LessonId('python-foundations-v1-0'): LessonStatus.completed,
};

Future<void> _pump(
  WidgetTester tester, {
  ProgrammingLanguage? activeLanguage,
  ValueChanged<ProgrammingLanguage>? onSelected,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: LanguageCatalog(
          overviews: _overviews,
          progress: _progress,
          activeLanguage: activeLanguage,
          onLanguageSelected: onSelected ?? (_) {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists exactly the languages present in the curriculum', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Go'), findsOneWidget);
    expect(find.text('Rust'), findsOneWidget);
    expect(find.text('Python'), findsOneWidget);
    expect(find.text('Bash'), findsNothing);
    expect(find.text('SQL'), findsNothing);
    expect(find.text('JavaScript'), findsNothing);
  });

  testWidgets('describes each language with its one-line blurb', (
    tester,
  ) async {
    await _pump(tester);

    expect(
      find.text('Simple and fast — ideal for backend and cloud.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Memory-safe systems programming, without a garbage collector.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('draws one progress bar per language with its real progress', (
    tester,
  ) async {
    await _pump(tester);

    final bars = tester
        .widgetList<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        )
        .toList();

    expect(bars, hasLength(3));
    expect(bars[0].value, 0.5);
    expect(bars[1].value, 0);
    expect(bars[2].value, 1);
  });

  testWidgets('marks the active language with a check', (tester) async {
    await _pump(tester, activeLanguage: ProgrammingLanguage.rust);

    expect(find.byIcon(LucideIcons.check300), findsOneWidget);
  });

  testWidgets('tapping a card reports that language', (tester) async {
    ProgrammingLanguage? picked;
    await _pump(tester, onSelected: (language) => picked = language);

    await tester.tap(find.text('Python'));

    expect(picked, ProgrammingLanguage.python);
  });
}
