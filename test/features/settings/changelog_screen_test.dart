// Widget test for the in-app "What's new" screen — confirms it actually
// reads the bundled CHANGELOG.md asset and renders its content, since a
// FutureBuilder silently showing nothing would otherwise go unnoticed.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/settings/presentation/screens/changelog_screen.dart';

void main() {
  testWidgets('renders the bundled CHANGELOG.md content', (tester) async {
    // Derived from the asset itself rather than hardcoded: the release
    // automation bumps the latest listed version on every push to main,
    // which used to leave a hardcoded assertion stale (see the 1.1.0->
    // 1.2.0 bump). Parsing the top-most semver heading keeps this test
    // valid across releases while still proving the *latest* entry is
    // what renders first.
    final changelog = await rootBundle.loadString('CHANGELOG.md');
    // Just the semver, not the trailing " - date": the widget renders the
    // version and its date as two separate Text widgets side by side.
    final latestReleasedVersion = RegExp(
      r'^## \[(\d+\.\d+\.\d+)\]',
      multiLine: true,
    ).firstMatch(changelog)?.group(1);
    expect(
      latestReleasedVersion,
      isNotNull,
      reason: 'CHANGELOG.md should list at least one released version',
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangelogScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // The screen title ("What's new") rather than the markdown's own "#
    // Changelog" preamble, which the body intentionally skips to start
    // straight at the most recent version heading.
    expect(find.textContaining("What's new"), findsWidgets);
    expect(find.textContaining('Unreleased'), findsOneWidget);
    // The body is a lazy ListView, so only content visible without
    // scrolling renders — the latest released heading (the top-most one)
    // must be visible, not an older entry further down.
    expect(find.textContaining(latestReleasedVersion!), findsOneWidget);
  });
}
