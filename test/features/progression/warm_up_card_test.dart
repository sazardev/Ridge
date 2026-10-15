// Widget tests for `WarmUpCard` — renders nothing while there's no
// recommendation, shows the character warm-up with its weak-character
// chips for a one-option profile, and offers finger/hand target chips
// (each switching the selection without navigating) when available.
// `warmUpOptionsProvider` is overridden directly with fixed data so this
// stays a pure rendering test (mirrors `daily_challenge_card_test.dart`).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/hand.dart';
import 'package:ridge/features/progression/domain/entities/warm_up_target.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';
import 'package:ridge/features/progression/presentation/widgets/warm_up_card.dart';

const _snippet = Snippet(
  id: SnippetId('go-warmup-test'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Test snippet',
  titleEs: 'Snippet de prueba',
  code: 'abcd',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

Future<void> _pumpCard(
  WidgetTester tester, {
  required Future<List<WarmUpOption>> Function(Ref ref) override,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [warmUpOptionsProvider.overrideWith(override)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: WarmUpCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders nothing while there is no recommendation', (
    tester,
  ) async {
    await _pumpCard(tester, override: (ref) async => const []);

    expect(find.byType(Card), findsNothing);
  });

  testWidgets(
    'shows the character drill with its weak characters (whitespace made '
    'visible) as the only target chip',
    (tester) async {
      await _pumpCard(
        tester,
        override: (ref) async => const [
          (
            target: WarmUpTarget.characters,
            snippet: _snippet,
            finger: null,
            hand: null,
            weakCharacters: ['}', ' ', '\n'],
          ),
        ],
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.practiceWarmUpTitle), findsOneWidget);
      expect(find.text(l10n.practiceWarmUpTargetCharacters), findsOneWidget);
      expect(find.text('}'), findsOneWidget);
      expect(find.text('␣'), findsOneWidget);
      expect(find.text('⏎'), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets);
    },
  );

  testWidgets('offers finger and hand chips and switching targets is '
      'purely visual (no navigation)', (tester) async {
    await _pumpCard(
      tester,
      override: (ref) async => const [
        (
          target: WarmUpTarget.characters,
          snippet: _snippet,
          finger: null,
          hand: null,
          weakCharacters: ['}'],
        ),
        (
          target: WarmUpTarget.finger,
          snippet: _snippet,
          finger: Finger.rightPinky,
          hand: null,
          weakCharacters: [],
        ),
        (
          target: WarmUpTarget.hand,
          snippet: _snippet,
          finger: null,
          hand: Hand.right,
          weakCharacters: [],
        ),
      ],
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.progressFingerRightPinky), findsOneWidget);
    expect(find.text(l10n.practiceWarmUpHandRight), findsOneWidget);

    await tester.tap(find.text(l10n.progressFingerRightPinky));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(Card), findsOneWidget);
  });
}
