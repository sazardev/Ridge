// Widget tests for `KeyboardVisual` — the single integration point
// deciding whether to paint a curated real layout, the generic family
// fallback, or nothing at all. `keyboardVisualLayoutSourceProvider` is
// overridden with a fake so these stay pure rendering tests, independent
// of the real bundled data bank (that's `keyboard_visual_layout_local_
// data_source_test.dart`'s job).
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
        home: Scaffold(body: KeyboardVisual(model: model)),
      ),
    ),
  );
  await tester.pump();
}

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
    await _pump(
      tester,
      'Glorious GMMK Pro',
      curated: const {
        'Glorious GMMK Pro': KeyboardVisualLayout(
          model: 'Glorious GMMK Pro',
          keys: [_oneKeySpec],
        ),
      },
    );

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
}
