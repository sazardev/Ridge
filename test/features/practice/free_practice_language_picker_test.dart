import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/content/presentation/providers/content_providers.dart';
import 'package:ridge/features/daily_challenge/presentation/providers/daily_challenge_providers.dart';
import 'package:ridge/features/learning_paths/application/usecases/get_active_language_usecase.dart';
import 'package:ridge/features/learning_paths/application/usecases/set_active_language_usecase.dart';
import 'package:ridge/features/learning_paths/domain/repositories/active_language_repository.dart';
import 'package:ridge/features/learning_paths/presentation/providers/active_language_providers.dart';
import 'package:ridge/features/practice/presentation/screens/free_practice_screen.dart';

Snippet _snippet(String id, ProgrammingLanguage language) {
  return Snippet(
    id: SnippetId(id),
    revision: 1,
    language: language,
    difficulty: Difficulty.beginner,
    category: ContentCategory.variablesAndTypes,
    symbolFocus: const {},
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
}

final _snippets = <Snippet>[
  _snippet('go-test-001', ProgrammingLanguage.go),
  _snippet('rust-test-001', ProgrammingLanguage.rust),
  _snippet('python-test-001', ProgrammingLanguage.python),
];

class _FakeSnippetCatalogController extends SnippetCatalogController {
  @override
  Stream<List<Snippet>> build() => Stream.value(_snippets);
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

Future<void> _pump(WidgetTester tester, {ProgrammingLanguage? active}) async {
  final repository = _FakeActiveLanguageRepository(active);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        snippetCatalogControllerProvider.overrideWith(
          _FakeSnippetCatalogController.new,
        ),
        dailyChallengeCardProvider.overrideWith((ref) async => null),
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
        home: FreePracticeScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('its language chip follows the active language', (tester) async {
    await _pump(tester, active: ProgrammingLanguage.rust);

    expect(find.text('Rust'), findsOneWidget);
  });

  testWidgets('falls back to Go when no language is active', (tester) async {
    await _pump(tester);

    expect(find.text('Go'), findsOneWidget);
  });

  testWidgets('picking another language in the sheet updates the chip', (
    tester,
  ) async {
    await _pump(tester, active: ProgrammingLanguage.rust);

    await tester.tap(find.text('Rust'));
    await tester.pumpAndSettle();

    expect(find.text('Python'), findsOneWidget);
    await tester.tap(find.text('Python'));
    await tester.pumpAndSettle();

    expect(find.text('Python'), findsOneWidget);
    expect(find.text('Rust'), findsNothing);
  });
}
