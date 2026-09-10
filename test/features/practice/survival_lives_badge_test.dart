// Widget tests for `SurvivalLivesBadge` (SPEC.md §5.8) — proves the
// filled/outlined heart split tracks the tracker's lives exactly.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/domain/services/survival_run_tracker.dart';
import 'package:ridge/features/practice/presentation/widgets/survival_lives_badge.dart';

Future<void> _pump(WidgetTester tester, SurvivalRunTracker tracker) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: SurvivalLivesBadge(tracker: tracker)),
      ),
    ),
  );
}

void main() {
  testWidgets('a full run shows exactly one filled heart per life', (
    tester,
  ) async {
    final tracker = SurvivalRunTracker();
    await _pump(tester, tracker);
    expect(find.byIcon(LucideIcons.heart600), findsNWidgets(5));
    expect(find.byIcon(LucideIcons.heart100), findsNothing);
  });

  testWidgets('lost lives turn filled hearts into outlined ones', (
    tester,
  ) async {
    final tracker = SurvivalRunTracker()
      ..recordMistake()
      ..recordMistake();
    await _pump(tester, tracker);
    expect(tracker.livesRemaining, 3);
    expect(find.byIcon(LucideIcons.heart600), findsNWidgets(3));
    expect(find.byIcon(LucideIcons.heart100), findsNWidgets(2));
  });
}
