import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';

void main() {
  test('spring curves start at 0, settle at 1 and overshoot in between', () {
    for (final curve in [
      SpringCurve.bouncy,
      SpringCurve.snappy,
      SpringCurve.gentle,
    ]) {
      expect(curve.transform(0), 0);
      expect(curve.transform(1), closeTo(1, 0.02));
      final peak = [for (var t = 0.0; t <= 1; t += 0.01) curve.transform(t)]
          .reduce((a, b) => a > b ? a : b);
      expect(peak, greaterThan(1));
    }
  });

  testWidgets('BouncyTap shrinks while pressed and restores on release', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: BouncyTap(
            enabled: true,
            child: SizedBox(
              width: 80,
              height: 80,
              child: ColoredBox(color: Colors.red),
            ),
          ),
        ),
      ),
    );
    double scale() => tester
        .widget<ScaleTransition>(
          find.descendant(
            of: find.byType(BouncyTap),
            matching: find.byType(ScaleTransition),
          ),
        )
        .scale
        .value;
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(BouncyTap)),
    );
    await tester.pump();
    await tester.pump(AppMotion.spatialFast);
    expect(scale(), lessThan(1));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(scale(), closeTo(1, 0.001));
  });
}
