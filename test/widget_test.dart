import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/theme/app_theme.dart';

void main() {
  testWidgets('AppTheme renders Material 3 widgets without shadows', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Column(
            children: [
              const Text('Just In Time'),
              FilledButton(onPressed: () {}, child: const Text('New task')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Just In Time'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'New task'), findsOneWidget);

    final card = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(card.theme?.cardTheme.elevation, 0);
    expect(card.theme?.appBarTheme.elevation, 0);
  });
}
