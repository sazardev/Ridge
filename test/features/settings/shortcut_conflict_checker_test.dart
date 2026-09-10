// Unit tests for `findShortcutConflict` — pure and stateless.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:ridge/features/settings/domain/entities/shortcut_binding.dart';
import 'package:ridge/features/settings/domain/services/shortcut_conflict_checker.dart';

void main() {
  const ctrl1 = ShortcutBinding(
    keyId: 0x31,
    control: true,
    alt: false,
    shift: false,
  );
  const ctrl2 = ShortcutBinding(
    keyId: 0x32,
    control: true,
    alt: false,
    shift: false,
  );

  test('a free combination has no conflict', () {
    final conflict = findShortcutConflict(
      {AppShortcutAction.goToPractice: ctrl1},
      AppShortcutAction.goToProgress,
      ctrl2,
    );
    expect(conflict, isNull);
  });

  test('a combination already used by another action returns that action', () {
    final conflict = findShortcutConflict(
      {
        AppShortcutAction.goToPractice: ctrl1,
        AppShortcutAction.goToProgress: ctrl2,
      },
      AppShortcutAction.goToFreePractice,
      ctrl2,
    );
    expect(conflict, AppShortcutAction.goToProgress);
  });

  test("an action's own current binding never conflicts with itself", () {
    final conflict = findShortcutConflict(
      {AppShortcutAction.goToPractice: ctrl1},
      AppShortcutAction.goToPractice,
      ctrl1,
    );
    expect(conflict, isNull);
  });
}
