// Widget test for the in-app "What's new" screen — confirms it actually
// reads the bundled CHANGELOG.md asset and renders its content, since a
// FutureBuilder silently showing nothing would otherwise go unnoticed.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/settings/presentation/screens/changelog_screen.dart';

void main() {
  testWidgets('renders the bundled CHANGELOG.md content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangelogScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Changelog'), findsWidgets);
    expect(find.textContaining('Unreleased'), findsOneWidget);
    // The body is a lazy ListView, so only content visible without
    // scrolling renders — this must stay the *latest* released version
    // heading (the top-most one), never an older entry further down.
    expect(find.textContaining('[1.1.0] - 2026-09-10'), findsOneWidget);
  });
}
