// Widget test for the result panel's own title-row share action — the
// only action this panel renders itself (everything else lives in
// `SessionResultFooter`, pinned outside its scroll view).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/domain/entities/session_metrics.dart';
import 'package:ridge/features/practice/presentation/widgets/session_result_panel.dart';

const _metrics = SessionMetrics(
  rawSpeedCpm: 200,
  netSpeedCpm: 190,
  accuracyPct: 97,
  consistencyScore: 80,
  maxStreak: 40,
  fatigueFirstThirdCpm: 200,
  fatigueMiddleThirdCpm: 195,
  fatigueLastThirdCpm: 190,
  handBalanceRatio: 0.5,
  characterStats: {},
  fingerStats: {},
  ngramStats: [],
  keyHeatmap: {},
);

Future<void> _pumpPanel(WidgetTester tester, {VoidCallback? onShare}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SessionResultPanel(metrics: _metrics, onShare: onShare),
      ),
    ),
  );
}

void main() {
  testWidgets('the share icon only shows up when onShare is supplied', (
    tester,
  ) async {
    await _pumpPanel(tester);
    expect(find.byIcon(LucideIcons.share300), findsNothing);

    var shared = false;
    await _pumpPanel(tester, onShare: () => shared = true);
    expect(find.byIcon(LucideIcons.share300), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.share300));
    expect(shared, isTrue);
  });
}
