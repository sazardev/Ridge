// Widget tests for `ProfileLinksCard` — renders one tappable row per set
// link, opens through the injected `onOpenUrl` seam (instead of reaching
// for the url_launcher platform channel, which isn't registered in the
// test binding), and collapses to nothing when no link is set.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_links_card.dart';

GuestProfile _profile({String? github, String? website}) => GuestProfile(
  id: const ProfileId('profile-1'),
  username: 'sazar',
  createdAt: DateTime.utc(2026),
  githubUsername: github,
  websiteUrl: website,
);

Future<void> _pump(
  WidgetTester tester,
  GuestProfile profile,
  List<Uri> opened,
) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ProfileLinksCard(profile: profile, onOpenUrl: opened.add),
      ),
    ),
  );
}

void main() {
  testWidgets('renders a row per link and opens each through the seam', (
    tester,
  ) async {
    final opened = <Uri>[];
    await _pump(
      tester,
      _profile(github: 'sazar', website: 'https://example.com/path'),
      opened,
    );

    expect(find.text('github.com/sazar'), findsOneWidget);
    expect(find.text('example.com/path'), findsOneWidget);

    await tester.tap(find.text('github.com/sazar'));
    expect(opened, [Uri.parse('https://github.com/sazar')]);

    await tester.tap(find.text('example.com/path'));
    expect(opened, [
      Uri.parse('https://github.com/sazar'),
      Uri.parse('https://example.com/path'),
    ]);
  });

  testWidgets('renders only the rows that are set', (tester) async {
    await _pump(tester, _profile(website: 'https://example.com'), <Uri>[]);

    expect(find.text('example.com'), findsOneWidget);
    expect(find.textContaining('github.com/'), findsNothing);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('renders nothing when no link is set', (tester) async {
    await _pump(tester, _profile(), <Uri>[]);

    expect(find.byType(Card), findsNothing);
  });
}
