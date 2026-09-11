// Widget tests for `DailyChallengeCard` — renders nothing while there's
// no data, an actionable state before today's challenge is played, and a
// disabled "already played" state afterwards. `dailyChallengeCardProvider`
// is overridden directly with fixed data so this stays a pure rendering
// test, independent of the real catalog/drift/profile chain (mirrors
// `session_result_footer_test.dart`'s l10n setup).
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
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/daily_challenge/presentation/providers/daily_challenge_providers.dart';
import 'package:ridge/features/daily_challenge/presentation/widgets/daily_challenge_card.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

const _snippet = Snippet(
  id: SnippetId('go-daily-test'),
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

final _challengeDate = ChallengeDate(DateTime.utc(2026, 3, 4));

Future<void> _pumpCard(
  WidgetTester tester, {
  required Future<
    ({
      Snippet snippet,
      ChallengeDate challengeDate,
      DailyChallengeCompletion? completion,
      int streak,
    })?
  >
  Function(Ref ref)
  override,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dailyChallengeCardProvider.overrideWith(override)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DailyChallengeCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders nothing while there is no data to show', (tester) async {
    await _pumpCard(tester, override: (ref) async => null);

    expect(find.byType(Card), findsNothing);
  });

  testWidgets(
    'not yet played today: shows the subtitle and an enabled tap target',
    (tester) async {
      await _pumpCard(
        tester,
        override: (ref) async => (
          snippet: _snippet,
          challengeDate: _challengeDate,
          completion: null,
          streak: 0,
        ),
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.dailyChallengeCardTitle), findsOneWidget);
      expect(find.text(l10n.dailyChallengeCardSubtitle), findsOneWidget);
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNotNull);
    },
  );

  testWidgets(
    'already played today: shows the score, disables the tap target, and '
    'has no streak flame when the streak is 0',
    (tester) async {
      final completion = DailyChallengeCompletion(
        profileId: ProfileId.generate(),
        date: _challengeDate,
        snippetId: _snippet.id,
        snippetRevision: _snippet.revision,
        sessionId: TypingSessionId.generate(),
        score: 9,
        passed: true,
        completedAtUtc: DateTime.utc(2026, 3, 4, 12),
      );
      await _pumpCard(
        tester,
        override: (ref) async => (
          snippet: _snippet,
          challengeDate: _challengeDate,
          completion: completion,
          streak: 0,
        ),
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(l10n.dailyChallengeCardAlreadyPlayed(9)),
        findsOneWidget,
      );
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
      expect(find.text(l10n.dailyChallengeCardStreakLabel(0)), findsNothing);
    },
  );

  testWidgets('a positive streak shows the streak badge', (tester) async {
    await _pumpCard(
      tester,
      override: (ref) async => (
        snippet: _snippet,
        challengeDate: _challengeDate,
        completion: null,
        streak: 5,
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.dailyChallengeCardStreakLabel(5)), findsOneWidget);
  });
}
