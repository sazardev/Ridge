// Widget tests for the result screen's fixed footer — Retry/Continue
// side by side (Retry left, Continue right) plus an optional info
// action, pinned outside the scrollable metrics panel so a long result
// never buries them out of reach.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/presentation/widgets/session_result_footer.dart';

Future<void> _pumpFooter(
  WidgetTester tester, {
  VoidCallback? onRetry,
  VoidCallback? onContinue,
  VoidCallback? onShowInfo,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        bottomNavigationBar: SessionResultFooter(
          onRetry: onRetry,
          onContinue: onContinue,
          onShowInfo: onShowInfo,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders nothing when neither retry nor continue is offered', (
    tester,
  ) async {
    await _pumpFooter(tester);

    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('retry alone renders as a full-width tonal button, no continue', (
    tester,
  ) async {
    var retried = false;
    await _pumpFooter(tester, onRetry: () => retried = true);

    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);

    await tester.tap(find.byType(FilledButton));
    expect(retried, isTrue);
  });

  testWidgets(
    'retry and continue side by side render retry as outlined (left) and '
    'continue as filled (right)',
    (tester) async {
      var retried = false;
      var continued = false;
      await _pumpFooter(
        tester,
        onRetry: () => retried = true,
        onContinue: () => continued = true,
      );

      final outlined = find.byType(OutlinedButton);
      final filled = find.byType(FilledButton);
      expect(outlined, findsOneWidget);
      expect(filled, findsOneWidget);

      final outlinedX = tester.getCenter(outlined).dx;
      final filledX = tester.getCenter(filled).dx;
      expect(outlinedX, lessThan(filledX));

      await tester.tap(outlined);
      expect(retried, isTrue);
      await tester.tap(filled);
      expect(continued, isTrue);
    },
  );

  testWidgets('the info action alone still renders even with neither retry nor '
      'continue offered, e.g. Zen/Sprint (SPEC.md §5.1/§5.2 have no '
      'pass/fail gate)', (tester) async {
    var infoShown = false;
    await _pumpFooter(tester, onShowInfo: () => infoShown = true);

    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byIcon(LucideIcons.info300), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.info300));
    expect(infoShown, isTrue);
  });

  testWidgets('the info action only shows up when onShowInfo is supplied', (
    tester,
  ) async {
    await _pumpFooter(tester, onRetry: () {});
    expect(find.byIcon(LucideIcons.info300), findsNothing);

    var infoShown = false;
    await _pumpFooter(
      tester,
      onRetry: () {},
      onShowInfo: () => infoShown = true,
    );
    expect(find.byIcon(LucideIcons.info300), findsOneWidget);
    expect(find.text('I'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.info300));
    expect(infoShown, isTrue);
  });
}
