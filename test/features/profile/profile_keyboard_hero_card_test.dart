// Widget tests for `ProfileKeyboardHeroCard`'s pointer parallax and
// drag-to-orbit: moving the mouse anywhere over the card must orbit the
// 3D camera with it, and leaving the card must reset the parallax. The
// layout source is faked so these stay pure interaction tests.
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/domain/repositories/keyboard_visual_layout_source.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';
import 'package:ridge/features/profile/presentation/widgets/profile_keyboard_hero_card.dart';

class _FakeKeyboardVisualLayoutSource implements KeyboardVisualLayoutSource {
  const new();

  @override
  Future<Map<String, KeyboardVisualLayout>> loadCuratedLayouts() async => {
    'Glorious GMMK Pro': const KeyboardVisualLayout(
      model: 'Glorious GMMK Pro',
      keys: [
        KeyboardKeySpec(
          x: 0,
          y: 0,
          w: 1,
          h: 1,
          x2: 0,
          y2: 0,
          w2: 1,
          h2: 1,
          rotationAngle: 0,
          rotationX: 0,
          rotationY: 0,
        ),
      ],
    ),
  };
}

final Finder _card = find.byType(ProfileKeyboardHeroCard);

/// The camera orbit backing the hero — that state *is* the rendered
/// result now that the visual is genuinely 3D.
KeyboardLayoutPainter _painter(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byType(KeyboardVisual),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is CustomPaint &&
                      widget.painter is KeyboardLayoutPainter,
                ),
              ),
            )
            .painter!
        as KeyboardLayoutPainter;

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        keyboardVisualLayoutSourceProvider.overrideWithValue(
          const _FakeKeyboardVisualLayoutSource(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: ProfileKeyboardHeroCard(
                profile: GuestProfile(
                  id: ProfileId.generate(),
                  username: 'Omar',
                  createdAt: DateTime(2026),
                  keyboardBrand: 'Glorious',
                  keyboardModel: 'Glorious GMMK Pro',
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('the pointer tilts the board and leaving the card resets it', (
    tester,
  ) async {
    await _pump(tester);
    final restingYaw = _painter(tester).yawDegrees;

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);

    await mouse.moveTo(tester.getCenter(_card) + const Offset(80, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(_painter(tester).yawDegrees, isNot(closeTo(restingYaw, 1e-6)));

    await mouse.moveTo(const Offset(-200, -200));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(_painter(tester).yawDegrees, closeTo(restingYaw, 1e-6));
  });

  testWidgets('dragging orbits the board and the angle persists', (
    tester,
  ) async {
    await _pump(tester);
    final center = tester.getCenter(_card);
    final restingYaw = _painter(tester).yawDegrees;

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);

    await mouse.moveTo(center);
    await mouse.down(center);
    // Below the click threshold nothing rotates: a simple click must stay
    // a click on the keyboard.
    await mouse.moveTo(center + const Offset(2, 0));
    await tester.pump();
    expect(_painter(tester).yawDegrees, closeTo(restingYaw, 1e-6));

    // Crossing the threshold starts the orbit; that first travel is
    // swallowed, and the following moves rotate 1:1.
    await mouse.moveTo(center + const Offset(80, 0));
    await tester.pump();
    await mouse.moveTo(center + const Offset(140, 0));
    await tester.pump();
    final draggedYaw = _painter(tester).yawDegrees;
    expect(draggedYaw, isNot(closeTo(restingYaw, 1e-6)));

    await mouse.up();
    await mouse.moveTo(const Offset(-200, -200));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(_painter(tester).yawDegrees, closeTo(draggedYaw, 1e-3));
  });

  testWidgets('the expand action opens the fullscreen keyboard viewer', (
    tester,
  ) async {
    final profile = GuestProfile(
      id: ProfileId.generate(),
      username: 'Omar',
      createdAt: DateTime(2026),
      keyboardBrand: 'Glorious',
      keyboardModel: 'Glorious GMMK Pro',
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: ProfileKeyboardHeroCard(profile: profile),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/keyboard',
          builder: (context, state) =>
              const Scaffold(body: Text('keyboard-viewer')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyboardVisualLayoutSourceProvider.overrideWithValue(
            const _FakeKeyboardVisualLayoutSource(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.maximize2));
    await tester.pumpAndSettle();

    expect(find.text('keyboard-viewer'), findsOneWidget);
  });
}
