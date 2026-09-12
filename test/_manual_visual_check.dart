// Throwaway visual-check harness — not part of the suite, deleted after use.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_theme.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_keyboard_hero_card.dart';
import 'package:ridge/features/settings/domain/entities/app_palette.dart';

final Finder _painted = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is KeyboardLayoutPainter,
);

GuestProfile _profile(String brand, String model) => GuestProfile(
  id: ProfileId.generate(),
  username: 'Omar',
  createdAt: DateTime(2026),
  keyboardBrand: brand,
  keyboardModel: model,
);

Future<void> _pump(
  WidgetTester tester,
  GuestProfile profile, {
  bool dark = false,
  AppPaletteId palette = AppPaletteId.ember,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: dark
            ? AppTheme.dark(palette: palette)
            : AppTheme.light(palette: palette),
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _save(WidgetTester tester, String filename) async {
  // `toImage` is real engine async — without `runAsync` the capture
  // completes but the test never finishes its teardown.
  await tester.runAsync(() async {
    final boundary = tester.renderObject(
      find.byKey(const Key('capture')),
    ) as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    File(filename).writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

void main() {
  testWidgets('ember light', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'));
    await _save(tester, '/tmp/hero_curated.png');
  });

  testWidgets('family fallback', (tester) async {
    await _pump(tester, _profile('Keychron', 'Keychron K8'));
    await _save(tester, '/tmp/hero_family.png');
  });

  testWidgets('ember dark', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'), dark: true);
    await _save(tester, '/tmp/hero_curated_dark.png');
  });

  testWidgets('gruvbox dark', (tester) async {
    await _pump(
      tester,
      _profile('Glorious', 'Glorious GMMK Pro'),
      dark: true,
      palette: AppPaletteId.gruvbox,
    );
    await _save(tester, '/tmp/hero_gruvbox_dark.png');
  });

  testWidgets('blackWhite light', (tester) async {
    await _pump(
      tester,
      _profile('Keychron', 'Keychron K8'),
      palette: AppPaletteId.blackWhite,
    );
    await _save(tester, '/tmp/hero_blackwhite_light.png');
  });

  testWidgets('hover state', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'));
    final center = tester.getCenter(_painted);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: center);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(center);
    await tester.pump();
    await _save(tester, '/tmp/hero_hover.png');
  });

  testWidgets('pressed state', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'));
    final center = tester.getCenter(_painted);
    final touch = await tester.startGesture(center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await _save(tester, '/tmp/hero_pressed.png');
    await touch.up();
  });

  testWidgets('pointer parallax top-right', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    final card = find.byType(ProfileKeyboardHeroCard);
    await mouse.moveTo(tester.getTopRight(card) + const Offset(-16, 8));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await _save(tester, '/tmp/hero_pointer_top_right.png');
  });

  testWidgets('pointer parallax bottom-left', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    final card = find.byType(ProfileKeyboardHeroCard);
    await mouse.moveTo(tester.getBottomLeft(card) + const Offset(16, -8));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await _save(tester, '/tmp/hero_pointer_bottom_left.png');
  });

  testWidgets('drag orbit', (tester) async {
    await _pump(tester, _profile('Glorious', 'Glorious GMMK Pro'));
    final card = find.byType(ProfileKeyboardHeroCard);
    final center = tester.getCenter(card);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(center);
    await mouse.down(center);
    await mouse.moveTo(center + const Offset(80, -50));
    await tester.pump();
    await mouse.moveTo(center + const Offset(130, -80));
    await tester.pump();
    await _save(tester, '/tmp/hero_drag_orbit.png');
    await mouse.up();
  });
}
