// Widget test for `AchievementBadgeTile` — a locked badge's longer
// description text must not make it visually taller than an unlocked
// badge showing only a short unlock date; every tile in the Achievements
// screen's Wrap should render at the same height.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/achievements/domain/entities/achievement_id.dart';
import 'package:ridge/features/achievements/presentation/widgets/achievement_badge_tile.dart';

Future<void> _pump(WidgetTester tester, AchievementBadgeTile tile) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: SizedBox(width: 168, child: tile)),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'a locked tile and its unlocked counterpart render the same height',
    (tester) async {
      const id = AchievementId.ambidiestro();

      await _pump(tester, const AchievementBadgeTile(id: id));
      final lockedHeight = tester
          .getSize(find.byType(AchievementBadgeTile))
          .height;

      await _pump(
        tester,
        AchievementBadgeTile(id: id, unlockedAt: DateTime(2026)),
      );
      final unlockedHeight = tester
          .getSize(find.byType(AchievementBadgeTile))
          .height;

      expect(unlockedHeight, lockedHeight);
    },
  );
}
