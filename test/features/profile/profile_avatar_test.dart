// Widget tests for `ProfileAvatar` — the GitHub picture when a handle is
// set, the username initial otherwise. The network fetch itself isn't
// asserted here: in the test binding `Image.network` fails and the
// `errorBuilder` fallback renders, which is exactly the offline behavior
// this widget must guarantee.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_avatar.dart';

Future<void> _pump(
  WidgetTester tester, {
  required String username,
  String? github,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ProfileAvatar(username: username, githubUsername: github),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the username initial with no GitHub handle', (
    tester,
  ) async {
    await _pump(tester, username: 'sazar');

    expect(find.text('S'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('falls back to ? for an empty username', (tester) async {
    await _pump(tester, username: '');

    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('requests the GitHub avatar when a handle is set', (
    tester,
  ) async {
    await _pump(tester, username: 'sazar', github: 'sazar');

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      image.image,
      isA<NetworkImage>().having(
        (provider) => provider.url,
        'url',
        'https://github.com/sazar.png?size=200',
      ),
    );
  });
}
