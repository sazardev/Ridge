// Widget test for `KeyboardRequiredNotice` — a pure rendering check
// (mirrors `session_result_footer_test.dart`'s l10n setup) that the
// explanatory copy actually shows up; the connected/disconnected
// decision itself lives in `PracticeSessionScreen`, not here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/presentation/widgets/keyboard_required_notice.dart';

void main() {
  testWidgets('shows the connect-a-keyboard title and explanation', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: KeyboardRequiredNotice()),
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.practiceKeyboardRequiredTitle), findsOneWidget);
    expect(find.text(l10n.practiceKeyboardRequiredBody), findsOneWidget);
  });
}
