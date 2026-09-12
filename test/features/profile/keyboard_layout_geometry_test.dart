import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';

KeyboardKeySpec _spec({
  double x = 0,
  double y = 0,
  double w = 1,
  double h = 1,
  double? x2,
  double? y2,
  double? w2,
  double? h2,
  double rotationAngle = 0,
  double? rotationX,
  double? rotationY,
}) => KeyboardKeySpec(
  x: x,
  y: y,
  w: w,
  h: h,
  x2: x2 ?? 0,
  y2: y2 ?? 0,
  w2: w2 ?? w,
  h2: h2 ?? h,
  rotationAngle: rotationAngle,
  rotationX: rotationX ?? x,
  rotationY: rotationY ?? y,
);

void main() {
  group('rotatePoint', () {
    test('leaves the pivot itself unchanged', () {
      final result = rotatePoint(const Offset(2, 3), const Offset(2, 3), 90);
      expect(result.dx, closeTo(2, 1e-9));
      expect(result.dy, closeTo(3, 1e-9));
    });

    test('rotates 90 degrees clockwise around the origin', () {
      final result = rotatePoint(const Offset(1, 0), Offset.zero, 90);
      expect(result.dx, closeTo(0, 1e-9));
      expect(result.dy, closeTo(1, 1e-9));
    });

    test('rotates 180 degrees around an arbitrary pivot', () {
      final result = rotatePoint(const Offset(3, 1), const Offset(1, 1), 180);
      expect(result.dx, closeTo(-1, 1e-9));
      expect(result.dy, closeTo(1, 1e-9));
    });
  });

  group('contentBoundsOf', () {
    test('a single 1u key at the origin is a 1x1 box', () {
      final bounds = contentBoundsOf([_spec()]);
      expect(bounds, const Rect.fromLTWH(0, 0, 1, 1));
    });

    test('spans multiple unrotated keys', () {
      final bounds = contentBoundsOf([_spec(), _spec(x: 4, y: 2, w: 2)]);
      expect(bounds, const Rect.fromLTWH(0, 0, 6, 3));
    });

    test('widens to fit a key rotated around its own corner', () {
      final unrotated = contentBoundsOf([_spec(x: 2)]);
      final rotated = contentBoundsOf([_spec(x: 2, rotationAngle: 45)]);

      expect(rotated.width, greaterThan(unrotated.width));
      expect(rotated.height, greaterThan(unrotated.height));
    });

    test('a 90-degree rotation around an explicit pivot swaps its extent', () {
      // A 2u-wide, 1u-tall key rotated 90 degrees around its own top-left
      // corner should occupy the same footprint as a 1u-wide, 2u-tall key.
      final bounds = contentBoundsOf([
        _spec(w: 2, rotationAngle: 90, rotationX: 0, rotationY: 0),
      ]);
      expect(bounds.width, closeTo(1, 1e-9));
      expect(bounds.height, closeTo(2, 1e-9));
    });

    test('includes the secondary rectangle of a stepped key', () {
      final bounds = contentBoundsOf([_spec(w: 1.25, x2: 0.25, w2: 1.5)]);
      // Primary rect: [0, 1.25]; secondary rect: [0.25, 1.75].
      expect(bounds.right, closeTo(1.75, 1e-9));
    });
  });

  group('KeyboardLayoutTransform', () {
    test('rectFor insets by half the gap on every side', () {
      final transform = KeyboardLayoutTransform.fit(
        keys: [_spec()],
        size: const Size(100, 100),
      );
      // One key-unit wins the smaller dimension: 100 / 1.9.
      const unit = 100 / (1 + KeyboardLayoutTransform.bezelFraction * 2);
      final rect = transform.rectFor(_spec());

      expect(transform.unit, closeTo(unit, 1e-9));
      expect(rect.width, closeTo(unit - unit * 0.14, 1e-9));
      expect(
        transform.caseRect.width,
        closeTo(unit + unit * KeyboardLayoutTransform.bezelFraction * 2, 1e-9),
      );
    });

    test('rectFor maps the secondary rectangle of a stepped key', () {
      final transform = KeyboardLayoutTransform.fit(
        keys: [_spec(w: 1.25, x2: 0.25, w2: 1.5)],
        size: const Size(200, 200),
      );

      expect(
        transform.rectFor(_spec(x2: 0.25, w2: 1.5), secondary: true).left,
        closeTo(transform.rectFor(_spec()).left + transform.unit * 0.25, 1e-9),
      );
    });

    test('hitTest accepts the key centre and rejects the gap between keys', () {
      final keys = [_spec(), _spec(x: 1)];
      final transform = KeyboardLayoutTransform.fit(
        keys: keys,
        size: const Size(200, 200),
      );

      expect(
        transform.hitTest(keys.first, transform.rectFor(keys.first).center),
        isTrue,
      );
      // The midpoint between two 1u keys at x=0 and x=1 sits in the gap.
      final gapPoint = Offset(
        transform.rectFor(keys.first).right + transform.gap / 2,
        transform.rectFor(keys.first).center.dy,
      );
      expect(transform.hitTest(keys.first, gapPoint), isFalse);
      expect(transform.hitTest(keys.last, gapPoint), isFalse);
    });

    test('hitTest undoes a key rotation', () {
      // A 2u-wide key rotated 90 degrees clockwise around its top-left
      // corner points its long axis down (and its thickness left of the
      // pivot), so a point 1.5u below and 0.5u left of the pivot is inside
      // it even though the unrotated rect stops at 2u to the right.
      final key = _spec(w: 2, rotationAngle: 90, rotationX: 0, rotationY: 0);
      final transform = KeyboardLayoutTransform.fit(
        keys: [key],
        size: const Size(200, 200),
      );
      final belowPivot = Offset(
        transform.origin.dx - transform.unit * 0.5,
        transform.origin.dy + transform.unit * 1.5,
      );

      expect(transform.hitTest(key, belowPivot), isTrue);
    });

    test('keyIndexAt prefers the last-drawn key under the point', () {
      final keys = [_spec(), _spec()];
      final transform = KeyboardLayoutTransform.fit(
        keys: keys,
        size: const Size(200, 200),
      );

      expect(transform.keyIndexAt(transform.rectFor(keys.first).center), 1);
      expect(transform.keyIndexAt(const Offset(-100, -100)), isNull);
    });

    test('reserves room for the extrusion so the case stays in frame', () {
      final key = _spec();
      const size = Size(120, 120);
      const depth = 0.2;
      final transform = KeyboardLayoutTransform.fit(
        keys: [key],
        size: size,
        depthFraction: depth,
      );
      final extrudedBottom = transform.caseRect.bottom + transform.unit * depth;

      expect(extrudedBottom, lessThanOrEqualTo(size.height + 1e-9));
    });
  });
}
