// Widget test for `EscapeToPop` — Escape pops the current route.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/widgets/escape_to_pop.dart';

void main() {
  testWidgets('Escape pops the pushed route back to the previous one', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const EscapeToPop(
                  child: Focus(autofocus: true, child: Text('second')),
                ),
              ),
            ),
            child: const Text('first'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('first'));
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsNothing);
  });
}
