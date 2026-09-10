import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/profile/presentation/keyboard_shape_family.dart';
import 'package:just_in_time/features/profile/presentation/widgets/keyboard_shape_preview.dart';

void main() {
  for (final family in KeyboardShapeFamily.values) {
    testWidgets('paints $family without throwing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: KeyboardShapePreview(family: family, modelLabel: 'Test'),
          ),
        ),
      );

      expect(find.byType(KeyboardShapePreview), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
