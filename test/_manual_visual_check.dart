// Throwaway visual-check harness — not part of the suite, deleted after use.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_theme.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_keyboard_hero_card.dart';

Future<void> _capture(
  WidgetTester tester,
  GuestProfile profile,
  String filename, {
  bool dark = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: dark ? AppTheme.dark() : AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: const Key('capture'),
              child: SizedBox(
                width: 360,
                child: ProfileKeyboardHeroCard(profile: profile),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final boundary = tester.renderObject(
    find.byKey(const Key('capture')),
  ) as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 2);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(filename).writeAsBytesSync(bytes!.buffer.asUint8List());
}

void main() {
  testWidgets('curated layout hero card', (tester) async {
    await _capture(
      tester,
      GuestProfile(
        id: ProfileId.generate(),
        username: 'Omar',
        createdAt: DateTime(2026),
        keyboardBrand: 'Glorious',
        keyboardModel: 'Glorious GMMK Pro',
      ),
      '/tmp/hero_curated.png',
    );
  });

  testWidgets('generic family fallback hero card', (tester) async {
    await _capture(
      tester,
      GuestProfile(
        id: ProfileId.generate(),
        username: 'Omar',
        createdAt: DateTime(2026),
        keyboardBrand: 'Keychron',
        keyboardModel: 'Keychron K8',
      ),
      '/tmp/hero_family.png',
    );
  });

  testWidgets('curated layout hero card, dark', (tester) async {
    await _capture(
      tester,
      GuestProfile(
        id: ProfileId.generate(),
        username: 'Omar',
        createdAt: DateTime(2026),
        keyboardBrand: 'Glorious',
        keyboardModel: 'Glorious GMMK Pro',
      ),
      '/tmp/hero_curated_dark.png',
      dark: true,
    );
  });
}
