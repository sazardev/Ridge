// Widget tests for `WeeklySummaryCard` — renders nothing with no
// provider data, the empty-week copy on a sessionless week, and the full
// stat grid plus speed delta on a practiced week. The provider is
// overridden directly with fixed data (mirrors `warm_up_card_test.dart`).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/progression/domain/services/weekly_summary_calculator.dart';
import 'package:ridge/features/progression/presentation/providers/weekly_summary_providers.dart';
import 'package:ridge/features/progression/presentation/widgets/weekly_summary_card.dart';

Future<void> _pumpCard(
  WidgetTester tester, {
  required Future<WeeklySummary?> Function(Ref ref) override,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [weeklySummaryProvider.overrideWith(override)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: WeeklySummaryCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('renders nothing while there is no summary', (tester) async {
    await _pumpCard(tester, override: (ref) async => null);

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('a sessionless week shows the empty copy', (tester) async {
    await _pumpCard(
      tester,
      override: (ref) async => (
        sessions: 0,
        previousSessions: 2,
        totalDuration: Duration.zero,
        previousTotalDuration: const Duration(minutes: 60),
        totalXp: 0,
        averageNetSpeedCpm: 0.0,
        previousAverageNetSpeedCpm: 64.0,
        averageAccuracyPct: 0.0,
        activeDays: 0,
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.progressWeeklyEmpty), findsOneWidget);
    expect(find.text(l10n.progressWeeklySessions), findsNothing);
  });

  testWidgets('a practiced week shows the stats and the speed delta', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      override: (ref) async => (
        sessions: 3,
        previousSessions: 2,
        totalDuration: const Duration(minutes: 95),
        previousTotalDuration: const Duration(minutes: 60),
        totalXp: 120,
        averageNetSpeedCpm: 72.4,
        previousAverageNetSpeedCpm: 64.0,
        averageAccuracyPct: 97.3,
        activeDays: 3,
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('1h 35m'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('72'), findsOneWidget);
    expect(find.text('97.3%'), findsOneWidget);
    expect(find.text('3/7'), findsOneWidget);
    expect(find.text(l10n.progressWeeklySpeedDelta('+8')), findsOneWidget);
  });
}
