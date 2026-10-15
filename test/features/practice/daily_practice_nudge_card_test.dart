// Widget tests for `DailyPracticeNudgeCard` — renders nothing while
// there's nothing to nudge about, a streak-protection variant when a
// streak is alive, and a gap variant when it isn't.
// `dailyPracticeNudgeProvider` is overridden directly with fixed data so
// this stays a pure rendering test (mirrors `warm_up_card_test.dart`).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/practice/presentation/widgets/daily_practice_nudge_card.dart';

Future<void> _pumpCard(
  WidgetTester tester, {
  required Future<DailyPracticeNudgeData?> Function(Ref ref) override,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [dailyPracticeNudgeProvider.overrideWith(override)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DailyPracticeNudgeCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders nothing while there is nothing to nudge about', (
    tester,
  ) async {
    await _pumpCard(tester, override: (ref) async => null);

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('an alive streak shows the streak-protection copy', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      override: (ref) async => (streakDays: 4, daysSinceLastSession: 1),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.practiceNudgeStreakTitle(4)), findsOneWidget);
    expect(find.text(l10n.practiceNudgeBody), findsOneWidget);
    expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNotNull);
  });

  testWidgets('a broken streak shows the days-without-practice copy', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      override: (ref) async => (streakDays: 0, daysSinceLastSession: 3),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.practiceNudgeInactiveTitle(3)), findsOneWidget);
  });
}
