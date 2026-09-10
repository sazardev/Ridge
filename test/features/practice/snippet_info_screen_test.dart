// Widget test for the result screen's full-screen "what did you just
// type?" reading view — the syntax-highlighted code plus its
// locale-resolved explanation, opened from `SessionResultFooter`'s info
// action.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/inline_code_text.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/presentation/screens/snippet_info_screen.dart';

const _snippet = Snippet(
  id: SnippetId('go-test-info-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Short variable declarations',
  titleEs: 'Declaraciones de variables cortas',
  code: 'x := 1',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'The `:=` operator declares and infers types at once.',
  explanationEs: 'El operador `:=` declara e infiere tipos a la vez.',
);

void main() {
  testWidgets('shows the snippet title, its full code, and the English '
      'explanation under an English locale', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SnippetInfoScreen(snippet: _snippet),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Short variable declarations'), findsWidgets);
    expect(find.textContaining('x := 1'), findsOneWidget);
    expect(
      tester
          .widgetList<InlineCodeText>(find.byType(InlineCodeText))
          .map((w) => w.text),
      contains('The `:=` operator declares and infers types at once.'),
    );
  });

  testWidgets('shows the Spanish explanation under a Spanish locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SnippetInfoScreen(snippet: _snippet),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Declaraciones de variables cortas'), findsWidgets);
    expect(
      tester
          .widgetList<InlineCodeText>(find.byType(InlineCodeText))
          .map((w) => w.text),
      contains('El operador `:=` declara e infiere tipos a la vez.'),
    );
  });
}
