// Data-completeness guard for `keyboard_shape_lookup.dart`, mirroring
// `snippet_catalog_completeness_test.dart`'s pattern: every curated
// keyboard model suggestion must resolve to a shape family, so a future
// addition to `kKeyboardModelSuggestions` can't silently ship unclassified
// (falling through to "no illustration" without anyone noticing).
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/profile/presentation/keyboard_shape_family.dart';
import 'package:just_in_time/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:just_in_time/features/profile/presentation/profile_suggestions.dart';

void main() {
  test(
    'every kKeyboardModelSuggestions entry except Other has a shape family',
    () {
      final unclassified = <String>[
        for (final model in kKeyboardModelSuggestions)
          if (model != 'Other' && keyboardShapeFamilyFor(model) == null) model,
      ];

      expect(unclassified, isEmpty, reason: unclassified.join(', '));
    },
  );

  test('unmatched, empty, and Other input all resolve to null', () {
    expect(keyboardShapeFamilyFor(null), isNull);
    expect(keyboardShapeFamilyFor(''), isNull);
    expect(keyboardShapeFamilyFor('Other'), isNull);
    expect(
      keyboardShapeFamilyFor('Some homemade board nobody curated'),
      isNull,
    );
  });

  test('spot-check a representative model from each family', () {
    expect(
      keyboardShapeFamilyFor('Cooler Master MK770'),
      KeyboardShapeFamily.fullSize,
    );
    expect(keyboardShapeFamilyFor('Keychron K8'), KeyboardShapeFamily.tkl);
    expect(
      keyboardShapeFamilyFor('Glorious GMMK Pro'),
      KeyboardShapeFamily.seventyFive,
    );
    expect(
      keyboardShapeFamilyFor('Keychron K6'),
      KeyboardShapeFamily.sixtyFive,
    );
    expect(
      keyboardShapeFamilyFor('HHKB Professional Classic'),
      KeyboardShapeFamily.sixty,
    );
    expect(
      keyboardShapeFamilyFor('ZSA Moonlander Mark I'),
      KeyboardShapeFamily.splitErgo,
    );
  });
}
