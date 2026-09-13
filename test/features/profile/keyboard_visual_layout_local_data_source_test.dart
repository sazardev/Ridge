// Loads the real bundled data bank (`assets/content/keyboard_layouts/`)
// end to end — a pure asset-parsing check (same pattern as
// `snippet_catalog_completeness_test.dart`) so a curation mistake (a
// manifest entry pointing at a missing file, a malformed key) fails fast
// in CI instead of silently rendering an empty keyboard in the app.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_visual_layout_local_data_source.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/profile_suggestions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'loads at least one curated layout from the real bundled assets',
    () async {
      final layouts = await KeyboardVisualLayoutLocalDataSource()
          .loadCuratedLayouts();

      expect(layouts, isNotEmpty);
    },
  );

  test('every curated layout carries legends on almost every key', () async {
    // Legends come from each board's real QMK default keymap (see
    // THIRD_PARTY_SOURCES.md); a handful of truly blank keys per board
    // is legitimate (layer-transparent macros, combos, encoders).
    final layouts = await KeyboardVisualLayoutLocalDataSource()
        .loadCuratedLayouts();

    for (final MapEntry(key: model, value: layout) in layouts.entries) {
      final labeled = layout.keys.where((key) => key.label != null).length;
      expect(
        labeled / layout.keys.length,
        greaterThanOrEqualTo(0.9),
        reason:
            '"$model" only has $labeled/${layout.keys.length} labeled '
            'keys — did the keymap-derived legends regress?',
      );
    }
  });

  test(
    'every curated model is a real kKeyboardModelSuggestions entry',
    () async {
      final layouts = await KeyboardVisualLayoutLocalDataSource()
          .loadCuratedLayouts();

      for (final model in layouts.keys) {
        expect(
          kKeyboardModelSuggestions,
          contains(model),
          reason:
              '"$model" is curated in the data bank but missing from '
              'kKeyboardModelSuggestions — the two must stay in sync so a '
              'curated layout is actually reachable from the edit-profile '
              'autocomplete.',
        );
        expect(
          keyboardShapeFamilyFor(model),
          isNotNull,
          reason: '"$model" has no `keyboard_shape_lookup.dart` family either',
        );
      }
    },
  );

  test('every curated layout has well-formed, positive-sized keys', () async {
    final layouts = await KeyboardVisualLayoutLocalDataSource()
        .loadCuratedLayouts();

    for (final MapEntry(key: model, value: layout) in layouts.entries) {
      expect(layout.keys, isNotEmpty, reason: '"$model" has no keys');
      for (final key in layout.keys) {
        expect(key.w, greaterThan(0), reason: '"$model" has a zero-width key');
        expect(key.h, greaterThan(0), reason: '"$model" has a zero-height key');
        expect(
          key.w2,
          greaterThan(0),
          reason: '"$model" has a zero-width secondary rect',
        );
        expect(
          key.h2,
          greaterThan(0),
          reason: '"$model" has a zero-height secondary rect',
        );
      }
    }
  });

  test(
    'an unknown manifest asset path yields an empty map, not a throw',
    () async {
      final layouts = await KeyboardVisualLayoutLocalDataSource(
        'assets/content/keyboard_layouts/does_not_exist.json',
      ).loadCuratedLayouts();

      expect(layouts, isEmpty);
    },
  );
}
