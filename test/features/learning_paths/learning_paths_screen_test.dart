import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_active_language_usecase.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_learning_paths_usecase.dart';
import 'package:ridge/features/learning_paths/application/usecases/set_active_language_usecase.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/repositories/active_language_repository.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/learning_paths/presentation/providers/active_language_providers.dart';
import 'package:ridge/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:ridge/features/learning_paths/presentation/screens/learning_paths_screen.dart';

LearningPath _path(String id, ProgrammingLanguage language, String title) {
  return LearningPath(
    id: LearningPathId(id),
    language: language,
    titleEn: title,
    titleEs: '$title (es)',
    descriptionEn: 'Description.',
    descriptionEs: 'Descripción.',
    tagEn: 'Tag',
    tagEs: 'Etiqueta',
    lessons: [
      Lesson(
        id: LessonId('$id-0'),
        snippetId: SnippetId('$id-snippet-0'),
        titleEn: 'Lesson',
        titleEs: 'Lección',
        order: 0,
      ),
    ],
  );
}

final _overviews = <LearningPathOverview>[
  (
    path: _path('go-foundations-v1', ProgrammingLanguage.go, 'Go path'),
    snippetsById: const {},
  ),
  (
    path: _path('rust-foundations-v1', ProgrammingLanguage.rust, 'Rust path'),
    snippetsById: const {},
  ),
];

class _FakeLearningPathsController extends LearningPathsController {
  @override
  Future<List<LearningPathOverview>> build() async => _overviews;
}

class _FakeLessonProgressController extends LessonProgressController {
  @override
  Stream<Map<LessonId, LessonStatus>> build() => Stream.value(const {});
}

class _FakeActiveLanguageRepository implements ActiveLanguageRepository {
  new([this.language]);

  ProgrammingLanguage? language;

  @override
  Future<Result<ProgrammingLanguage?, AppFailure>> read() async =>
      Result.ok(language);

  @override
  Future<Result<void, AppFailure>> write(ProgrammingLanguage? value) async {
    language = value;
    return const Result.ok(null);
  }
}

Future<_FakeActiveLanguageRepository> _pump(
  WidgetTester tester, {
  ProgrammingLanguage? initial,
}) async {
  final repository = _FakeActiveLanguageRepository(initial);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        learningPathsControllerProvider.overrideWith(
          _FakeLearningPathsController.new,
        ),
        lessonProgressControllerProvider.overrideWith(
          _FakeLessonProgressController.new,
        ),
        getActiveLanguageUseCaseProvider.overrideWithValue(
          GetActiveLanguageUseCase(repository),
        ),
        setActiveLanguageUseCaseProvider.overrideWithValue(
          SetActiveLanguageUseCase(repository),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LearningPathsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('shows the language catalog while no language is active', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Go'), findsOneWidget);
    expect(find.text('Rust'), findsOneWidget);
    expect(find.text('Go path'), findsNothing);
    expect(find.byTooltip('Change language'), findsNothing);
  });

  testWidgets('shows the persisted language guide directly', (tester) async {
    await _pump(tester, initial: ProgrammingLanguage.go);

    expect(find.text('Go path'), findsOneWidget);
    expect(find.byTooltip('Change language'), findsOneWidget);
    expect(find.text('Rust path'), findsNothing);
    expect(find.text('Rust'), findsNothing);
  });

  testWidgets('tapping a language activates it and opens its guide', (
    tester,
  ) async {
    final repository = await _pump(tester);

    await tester.tap(find.text('Rust'));
    await tester.pumpAndSettle();

    expect(repository.language, ProgrammingLanguage.rust);
    expect(find.text('Rust path'), findsOneWidget);
    expect(find.text('Go path'), findsNothing);
    expect(find.byTooltip('Change language'), findsOneWidget);
  });

  testWidgets('change language switches this same tab back to the catalog', (
    tester,
  ) async {
    final repository = await _pump(tester, initial: ProgrammingLanguage.go);

    await tester.tap(find.byTooltip('Change language'));
    await tester.pumpAndSettle();

    expect(find.text('Rust'), findsOneWidget);
    expect(find.text('Go path'), findsNothing);
    expect(find.byTooltip('Change language'), findsNothing);
    expect(repository.language, ProgrammingLanguage.go);

    await tester.tap(find.text('Rust'));
    await tester.pumpAndSettle();

    expect(repository.language, ProgrammingLanguage.rust);
    expect(find.text('Rust path'), findsOneWidget);
  });

  testWidgets('a persisted language with no paths falls back to the catalog', (
    tester,
  ) async {
    await _pump(tester, initial: ProgrammingLanguage.javascript);

    expect(find.text('Go'), findsOneWidget);
    expect(find.text('Go path'), findsNothing);
  });
}
