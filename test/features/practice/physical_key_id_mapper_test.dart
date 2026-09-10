// Regression guard for the physical-key mapper's layout coverage: the
// ISO `intlBackslash` key (between Left Shift and `Z` on every European
// ISO layout, and US-International) must resolve to its own
// `PhysicalKeyId` and produce the `<`/`>` fallback pair, so typing Go
// generics/comparisons works on a Spanish keyboard instead of being
// silently dropped (the reported bug this test pins down).
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/practice/domain/entities/keyboard_row.dart';
import 'package:just_in_time/features/practice/domain/services/key_layout_map.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/presentation/physical_key_id_mapper.dart';

void main() {
  test('the ISO intlBackslash key resolves to its own PhysicalKeyId', () {
    expect(
      physicalKeyIdFor(PhysicalKeyboardKey.intlBackslash),
      PhysicalKeyId.intlBackslash,
    );
  });

  test('fallbackCharFor yields the < > pair on the ISO key', () {
    expect(
      fallbackCharFor(PhysicalKeyId.intlBackslash, shiftPressed: false),
      '<',
    );
    expect(
      fallbackCharFor(PhysicalKeyId.intlBackslash, shiftPressed: true),
      '>',
    );
  });

  test('intlBackslash has a stable finger/row assignment for metrics', () {
    final entry = keyLayoutMap[PhysicalKeyId.intlBackslash];
    expect(entry, isNotNull);
    expect(entry!.finger, Finger.leftPinky);
    expect(entry.row, KeyboardRow.bottomRow);
  });
}
