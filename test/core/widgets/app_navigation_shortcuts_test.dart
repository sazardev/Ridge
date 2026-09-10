// Widget tests for `AppNavigationShortcuts` — direct-jump and cycle
// actions resolved from a caller-supplied `Map<AppShortcutAction,
// ShortcutBinding>` (mirrors `AppSettings.shortcutBindings`), including a
// customized (non-default) binding, plus proof that an unbound key never
// triggers a jump.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/widgets/app_navigation_shortcuts.dart';
import 'package:ridge/features/settings/domain/entities/app_shortcut_action.dart';
import 'package:ridge/features/settings/domain/entities/shortcut_binding.dart';

const Map<AppShortcutAction, ShortcutBinding> _defaultBindings = {
  AppShortcutAction.goToPractice: ShortcutBinding(
    keyId: 0x31,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToProgress: ShortcutBinding(
    keyId: 0x32,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToFreePractice: ShortcutBinding(
    keyId: 0x33,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToProfile: ShortcutBinding(
    keyId: 0x34,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.goToSettings: ShortcutBinding(
    keyId: 0x35,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.cycleNextSection: ShortcutBinding(
    keyId: 0x100000009,
    control: true,
    alt: false,
    shift: false,
  ),
  AppShortcutAction.cyclePreviousSection: ShortcutBinding(
    keyId: 0x100000009,
    control: true,
    alt: false,
    shift: true,
  ),
};

Future<void> _pump(
  WidgetTester tester, {
  required int currentIndex,
  required int branchCount,
  required Map<AppShortcutAction, ShortcutBinding> bindings,
  required ValueChanged<int> onSelectBranch,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: AppNavigationShortcuts(
        currentIndex: currentIndex,
        branchCount: branchCount,
        bindings: bindings,
        onSelectBranch: onSelectBranch,
        child: const Focus(autofocus: true, child: SizedBox.shrink()),
      ),
    ),
  );
}

void main() {
  testWidgets('Ctrl+2 jumps directly to branch index 1', (tester) async {
    var selected = -1;
    await _pump(
      tester,
      currentIndex: 0,
      branchCount: 5,
      bindings: _defaultBindings,
      onSelectBranch: (i) => selected = i,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    expect(selected, 1);
  });

  testWidgets('Ctrl+Tab from the last branch wraps to the first', (
    tester,
  ) async {
    var selected = -1;
    await _pump(
      tester,
      currentIndex: 4,
      branchCount: 5,
      bindings: _defaultBindings,
      onSelectBranch: (i) => selected = i,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    expect(selected, 0);
  });

  testWidgets('Ctrl+Shift+Tab from the first branch wraps to the last', (
    tester,
  ) async {
    var selected = -1;
    await _pump(
      tester,
      currentIndex: 0,
      branchCount: 5,
      bindings: _defaultBindings,
      onSelectBranch: (i) => selected = i,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    expect(selected, 4);
  });

  testWidgets('a bare Tab (no modifier) never triggers a jump', (tester) async {
    var selected = -1;
    await _pump(
      tester,
      currentIndex: 0,
      branchCount: 5,
      bindings: _defaultBindings,
      onSelectBranch: (i) => selected = i,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);

    expect(selected, -1);
  });

  testWidgets('a customized binding (Alt+2 instead of Ctrl+1) fires too', (
    tester,
  ) async {
    var selected = -1;
    final customized = {
      ..._defaultBindings,
      AppShortcutAction.goToPractice: const ShortcutBinding(
        keyId: 0x32,
        control: false,
        alt: true,
        shift: false,
      ),
    };
    await _pump(
      tester,
      currentIndex: 0,
      branchCount: 5,
      bindings: customized,
      onSelectBranch: (i) => selected = i,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);

    expect(selected, 0);
  });
}
