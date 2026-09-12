// Widget tests for `KeyboardVisual` — the single integration point
// deciding whether to paint a curated real layout, the generic family
// fallback, or nothing at all. `keyboardVisualLayoutSourceProvider` is
// overridden with a fake so these stay pure rendering tests, independent
// of the real bundled data bank (that's `keyboard_visual_layout_local_
// data_source_test.dart`'s job).
import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/domain/repositories/keyboard_visual_layout_source.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// Matches only the [KeyboardVisual]'s own painted surface — plain
/// `find.byType(CustomPaint)` would also catch unrelated `CustomPaint`s
/// Material/Scaffold render internally.
final Finder _painted = find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is KeyboardLayoutPainter,
);

class _FakeKeyboardVisualLayoutSource implements KeyboardVisualLayoutSource {
  const new([this._layouts = const {}]);

  final Map<String, KeyboardVisualLayout> _layouts;

  @override
  Future<Map<String, KeyboardVisualLayout>> loadCuratedLayouts() async =>
      _layouts;
}

const _oneKeySpec = KeyboardKeySpec(
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
);

Future<void> _pump(
  WidgetTester tester,
  String? model, {
  Map<String, KeyboardVisualLayout> curated = const {},
  double tiltDegrees = 0,
  Offset pointerTilt = Offset.zero,
  double pointerTiltDegrees = 0,
  Offset rotation = Offset.zero,
  bool interactive = true,
  bool interactiveSuspended = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        keyboardVisualLayoutSourceProvider.overrideWithValue(
          _FakeKeyboardVisualLayoutSource(curated),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: KeyboardVisual(
            model: model,
            tiltDegrees: tiltDegrees,
            pointerTilt: pointerTilt,
            pointerTiltDegrees: pointerTiltDegrees,
            rotation: rotation,
            interactive: interactive,
            interactiveSuspended: interactiveSuspended,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// The visual's tilt transform — absent when neither the base tilt nor the
/// pointer parallax is enabled.
final Finder _tiltTransform = find.descendant(
  of: find.byType(KeyboardVisual),
  matching: find.byType(Transform),
);

/// The painter currently backing the visual — interaction tests read its
/// hover/press state directly, since that state *is* the rendered result.
KeyboardLayoutPainter _painter(WidgetTester tester) =>
    tester.widget<CustomPaint>(_painted).painter! as KeyboardLayoutPainter;

const _curatedOneKey = {
  'Glorious GMMK Pro': KeyboardVisualLayout(
    model: 'Glorious GMMK Pro',
    keys: [_oneKeySpec],
  ),
};

void main() {
  // Representative model per `KeyboardShapeFamily`, mirroring
  // `keyboard_shape_lookup_test.dart`'s spot-check list.
  const modelsByFamily = [
    'Cooler Master MK770',
    'Keychron K8',
    'Glorious GMMK Pro',
    'Keychron K6',
    'HHKB Professional Classic',
    'ZSA Moonlander Mark I',
  ];

  for (final model in modelsByFamily) {
    testWidgets('falls back to the family silhouette for $model', (
      tester,
    ) async {
      await _pump(tester, model);

      expect(_painted, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('prefers a curated layout over the family fallback', (
    tester,
  ) async {
    await _pump(tester, 'Glorious GMMK Pro', curated: _curatedOneKey);

    expect(_painted, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders nothing for null, empty, or unrecognized model', (
    tester,
  ) async {
    for (final model in [null, '', 'Some homemade board nobody curated']) {
      await _pump(tester, model);
      expect(find.byType(KeyboardVisual), findsOneWidget);
      expect(_painted, findsNothing);
    }
  });

  testWidgets('hover tracks the key under the pointer', (tester) async {
    await _pump(tester, 'Glorious GMMK Pro', curated: _curatedOneKey);
    final center = tester.getCenter(_painted);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);

    await mouse.moveTo(center);
    await tester.pump();
    expect(_painter(tester).hoveredIndex, 0);

    await mouse.moveTo(Offset(center.dx, center.dy + 500));
    await tester.pump();
    expect(_painter(tester).hoveredIndex, isNull);
  });

  testWidgets('pressing a key sinks it and releasing brings it back', (
    tester,
  ) async {
    await _pump(tester, 'Glorious GMMK Pro', curated: _curatedOneKey);

    final touch = await tester.startGesture(tester.getCenter(_painted));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    expect(_painter(tester).pressedIndex, 0);
    expect(_painter(tester).pressProgress, greaterThan(0));

    await tester.pump(const Duration(milliseconds: 120));
    expect(_painter(tester).pressProgress, closeTo(1, 0.001));

    await touch.up();
    await tester.pump();
    expect(_painter(tester).pressedIndex, isNull);
    await tester.pump(const Duration(milliseconds: 400));
    expect(_painter(tester).pressProgress, closeTo(0, 0.001));
  });

  testWidgets('interactive: false leaves hover and press untouched', (
    tester,
  ) async {
    await _pump(
      tester,
      'Glorious GMMK Pro',
      curated: _curatedOneKey,
      interactive: false,
    );
    final center = tester.getCenter(_painted);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(center);
    await tester.pump();
    expect(_painter(tester).hoveredIndex, isNull);

    final touch = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 200));
    expect(_painter(tester).pressedIndex, isNull);
    await touch.up();
  });

  testWidgets('the hero tilt keeps pointer hit-testing accurate', (
    tester,
  ) async {
    await _pump(
      tester,
      'Glorious GMMK Pro',
      curated: _curatedOneKey,
      tiltDegrees: 6,
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(_painted));
    await tester.pump();

    expect(_painter(tester).hoveredIndex, 0);
  });

  testWidgets('pointerTilt rotates the board with the pointer', (tester) async {
    Future<Matrix4> boardTransform(Offset pointerTilt) async {
      await _pump(
        tester,
        'Glorious GMMK Pro',
        curated: _curatedOneKey,
        tiltDegrees: 6,
        pointerTilt: pointerTilt,
        pointerTiltDegrees: 4,
      );
      await tester.pump(const Duration(milliseconds: 300));
      return tester.widget<Transform>(_tiltTransform).transform;
    }

    final right = await boardTransform(const Offset(1, 0));
    final left = await boardTransform(const Offset(-1, 0));

    // Yawing left vs. right flips the sign of the rotateY shear entry.
    expect(right.entry(0, 2), isNot(closeTo(left.entry(0, 2), 1e-6)));
  });

  testWidgets('rotation adds drag yaw on top of the parallax', (tester) async {
    await _pump(
      tester,
      'Glorious GMMK Pro',
      curated: _curatedOneKey,
      pointerTiltDegrees: 6,
      rotation: const Offset(30, 0),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final yaw = tester.widget<Transform>(_tiltTransform).transform;
    expect(yaw.entry(0, 2), closeTo(math.sin(30 * math.pi / 180), 1e-6));
  });

  testWidgets('interactiveSuspended releases a held key', (tester) async {
    await _pump(tester, 'Glorious GMMK Pro', curated: _curatedOneKey);
    final touch = await tester.startGesture(tester.getCenter(_painted));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(_painter(tester).pressedIndex, 0);

    await _pump(
      tester,
      'Glorious GMMK Pro',
      curated: _curatedOneKey,
      interactiveSuspended: true,
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(_painter(tester).pressedIndex, isNull);
    await touch.up();
  });

  testWidgets('no tilt at all leaves the board untransformed', (tester) async {
    await _pump(tester, 'Glorious GMMK Pro', curated: _curatedOneKey);

    expect(_tiltTransform, findsNothing);
  });
}
