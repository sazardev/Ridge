// Widget tests for `KeyboardViewerScreen` — the fullscreen keyboard
// inspector opened from Profile's keyboard hero card. The layout source
// is faked so these stay pure interaction tests, mirroring
// `keyboard_visual_test.dart`.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/domain/repositories/keyboard_visual_layout_source.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/screens/keyboard_viewer_screen.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

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

/// Matches only the viewer's own painted board — plain
/// `find.byType(CustomPaint)` would also catch unrelated `CustomPaint`s
/// Material/Scaffold render internally.
final Finder _painted = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is KeyboardLayoutPainter,
);

/// The viewer's outer zoom `Transform.scale` — the nearest `Transform`
/// ancestor of the visual (the orbit is part of the painter's camera now).
final Finder _zoomTransform = find
    .ancestor(of: find.byType(KeyboardVisual), matching: find.byType(Transform))
    .first;

KeyboardLayoutPainter _painter(WidgetTester tester) =>
    tester.widget<CustomPaint>(_painted).painter! as KeyboardLayoutPainter;

double _zoom(WidgetTester tester) =>
    tester.widget<Transform>(_zoomTransform).transform.getMaxScaleOnAxis();

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
        home: KeyboardViewerScreen(
          profile: GuestProfile(
            id: ProfileId.generate(),
            username: 'Omar',
            createdAt: DateTime(2026),
            keyboardModel: 'Glorious GMMK Pro',
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows the captioned board with controls and the hint', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Glorious GMMK Pro'), findsOneWidget);
    expect(_painted, findsOneWidget);
    expect(find.byIcon(LucideIcons.zoomOut), findsOneWidget);
    expect(find.byIcon(LucideIcons.rotateCcw), findsOneWidget);
    expect(find.byIcon(LucideIcons.zoomIn), findsOneWidget);
    expect(
      find.text('Drag to rotate · Pinch or scroll to zoom'),
      findsOneWidget,
    );
  });

  testWidgets('a mouse drag orbits the board', (tester) async {
    await _pump(tester);
    expect(_painter(tester).yawDegrees, 0);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);

    final center = tester.getCenter(_painted);
    await mouse.moveTo(center);
    await mouse.down(center);
    await mouse.moveTo(center + const Offset(60, 0));
    await tester.pump();

    expect(_painter(tester).yawDegrees, isNot(closeTo(0, 1e-6)));

    await mouse.up();
    await tester.pump();
  });

  testWidgets('a two-finger pinch zooms the board', (tester) async {
    await _pump(tester);
    expect(_zoom(tester), 1);

    final center = tester.getCenter(_painted);
    final first = await tester.createGesture();
    final second = await tester.createGesture();
    await first.down(center - const Offset(40, 0));
    await second.down(center + const Offset(40, 0));
    await tester.pump();

    await first.moveTo(center - const Offset(60, 0));
    await second.moveTo(center + const Offset(60, 0));
    await tester.pump();
    await first.moveTo(center - const Offset(120, 0));
    await second.moveTo(center + const Offset(120, 0));
    await tester.pump();

    expect(_zoom(tester), greaterThan(1));

    await first.up();
    await second.up();
    await tester.pump();
  });

  testWidgets('the wheel zooms the board', (tester) async {
    await _pump(tester);

    final pointer = TestPointer(1, PointerDeviceKind.mouse);
    await tester.sendEventToBinding(pointer.hover(tester.getCenter(_painted)));
    await tester.sendEventToBinding(pointer.scroll(const Offset(0, -120)));
    await tester.pump();

    expect(_zoom(tester), greaterThan(1));
  });

  testWidgets('zoom buttons move the view and reset restores it', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.byIcon(LucideIcons.zoomIn));
    await tester.pump();
    expect(_zoom(tester), closeTo(1.25, 1e-6));

    await tester.tap(find.byIcon(LucideIcons.rotateCcw));
    await tester.pump();
    expect(_zoom(tester), 1);
  });

  testWidgets('keys still sink under the pointer through the zoom transform', (
    tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.byIcon(LucideIcons.zoomIn));
    await tester.pump();

    final gesture = await tester.startGesture(tester.getCenter(_painted));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    expect(_painter(tester).pressedIndex, 0);

    await gesture.up();
    await tester.pump();
  });
}
