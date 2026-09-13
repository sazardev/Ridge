// Unit tests for the 3D keyboard camera — the projection math the whole
// renderer and pointer hit-testing build on: fit, project, un-project to
// a plane, depth sorting and the rounded-rectangle outline sampler.
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';

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

KeyboardCamera _camera({
  List<KeyboardKeySpec>? keys,
  Size size = const Size(200, 200),
  double depthFraction = 0,
  double topFraction = 0,
  double yawDegrees = 0,
  double pitchDegrees = 0,
}) => KeyboardCamera.fit(
  keys: keys ?? [_spec()],
  size: size,
  depthFraction: depthFraction,
  topFraction: topFraction,
  yawDegrees: yawDegrees,
  pitchDegrees: pitchDegrees,
);

void main() {
  group('Vec3', () {
    test('adds, subtracts and scales component-wise', () {
      const a = Vec3(1, 2, 3);
      const b = Vec3(4, 5, 6);
      expect(a + b, const Vec3(5, 7, 9));
      expect(b - a, const Vec3(3, 3, 3));
      expect(a * 2, const Vec3(2, 4, 6));
    });

    test('dot and cross follow the right-hand rule in y-down space', () {
      const x = Vec3(1, 0, 0);
      const y = Vec3(0, 1, 0);
      expect(x.dot(y), 0);
      expect(x.cross(y), const Vec3(0, 0, 1));
    });

    test('normalized keeps the direction and unit length', () {
      final n = const Vec3(0, 3, 4).normalized();
      expect(n.length, closeTo(1, 1e-9));
      expect(n.x, 0);
      expect(n.y, closeTo(0.6, 1e-9));
      expect(n.z, closeTo(0.8, 1e-9));
      expect(Vec3.zero.normalized(), Vec3.zero);
    });
  });

  group('roundedRectOutline', () {
    test('without a radius it is the four corners', () {
      final points = roundedRectOutline(const Rect.fromLTWH(0, 0, 10, 6), 0);
      expect(points, hasLength(4));
      expect(points, contains(Offset.zero));
      expect(points, contains(const Offset(10, 6)));
    });

    test('samples every corner and stays inside the rectangle', () {
      const rect = Rect.fromLTWH(2, 3, 10, 6);
      final points = roundedRectOutline(rect, 1.5);
      expect(points, hasLength(12));
      for (final point in points) {
        // `Rect.contains` excludes the right/bottom edges, and
        // mid-edge outline points sit exactly on them.
        expect(rect.inflate(1e-6).contains(point), isTrue, reason: '$point');
      }
    });

    test('clamps an oversized radius to half the shortest side', () {
      final points = roundedRectOutline(
        const Rect.fromLTWH(0, 0, 10, 4),
        100,
        segmentsPerCorner: 2,
      );
      for (final point in points) {
        expect(point.dy, inInclusiveRange(0, 4));
        expect(point.dx, inInclusiveRange(0, 10));
      }
    });
  });

  group('KeyboardCamera.fit', () {
    test('fits the rest board edge-to-edge inside the view', () {
      final camera = _camera(size: const Size(100, 100));

      // One key-unit wins the smaller dimension: 100 / 1.9.
      expect(camera.unit, closeTo(100 / 1.9, 1e-9));
    });

    test('the projected case stays in frame at every orbit angle', () {
      final keys = [_spec(), _spec(x: 4)];
      const size = Size(320, 176);
      for (final angles in [
        (0.0, 0.0),
        (60.0, 30.0),
        (-60.0, -30.0),
        (75.0, 45.0),
      ]) {
        final camera = _camera(
          keys: keys,
          size: size,
          depthFraction: 0.4,
          topFraction: 0.2,
          yawDegrees: angles.$1,
          pitchDegrees: angles.$2,
        );
        final rect = camera.caseRect;
        for (final x in [rect.left, rect.right]) {
          for (final y in [rect.top, rect.bottom]) {
            for (final z in [-0.4, 0.2]) {
              final point = camera.project(Vec3(x, y, z));
              expect(point.dx, inInclusiveRange(-1e-6, size.width + 1e-6));
              expect(point.dy, inInclusiveRange(-1e-6, size.height + 1e-6));
            }
          }
        }
      }
    });

    test('orbiting never grows the board past its rest scale', () {
      final keys = [_spec(), _spec(x: 4)];
      final rest = _camera(keys: keys, depthFraction: 0.4, topFraction: 0.2);
      final turned = _camera(
        keys: keys,
        depthFraction: 0.4,
        topFraction: 0.2,
        yawDegrees: -60,
        pitchDegrees: -30,
      );

      expect(turned.unit, lessThanOrEqualTo(rest.unit + 1e-9));
    });

    test('the board centre lands exactly on the projection centre', () {
      final camera = _camera();
      final projected = camera.project(
        Vec3(camera.bounds.center.dx, camera.bounds.center.dy, 0),
      );
      expect(projected.dx, closeTo(camera.projectionCenter.dx, 1e-9));
      expect(projected.dy, closeTo(camera.projectionCenter.dy, 1e-9));
    });

    test('at rest one key-unit is exactly `unit` pixels', () {
      final camera = _camera();
      final center = camera.bounds.center;
      final oneRight = camera.project(Vec3(center.dx + 1, center.dy, 0));
      expect(
        oneRight.dx - camera.projectionCenter.dx,
        closeTo(camera.unit, 1e-9),
      );
      expect(oneRight.dy - camera.projectionCenter.dy, closeTo(0, 1e-9));
    });

    test('the canvas matrix reproduces project for any board point', () {
      final camera = _camera(yawDegrees: 35, pitchDegrees: 20);
      final m = camera.canvasMatrix.storage;
      Offset transform(Vec3 point) {
        final w = m[3] * point.x + m[7] * point.y + m[11] * point.z + m[15];
        return Offset(
          (m[0] * point.x + m[4] * point.y + m[8] * point.z + m[12]) / w,
          (m[1] * point.x + m[5] * point.y + m[9] * point.z + m[13]) / w,
        );
      }

      final bounds = camera.bounds;
      for (final point in [
        Vec3(bounds.center.dx, bounds.center.dy, 0),
        Vec3(bounds.left, bounds.top, 0.2),
        Vec3(bounds.right, bounds.top, 0.2),
        Vec3(bounds.right, bounds.bottom, -0.4),
        Vec3(bounds.left, bounds.bottom, -0.4),
      ]) {
        final expected = camera.project(point);
        final actual = transform(point);
        expect(actual.dx, closeTo(expected.dx, 1e-6), reason: '$point');
        expect(actual.dy, closeTo(expected.dy, 1e-6), reason: '$point');
      }
    });
  });

  group('project / unprojectToPlane', () {
    test('round-trips board points through both orbit angles', () {
      final camera = _camera(yawDegrees: 35, pitchDegrees: 20);
      const planeZ = 0.2;
      final points = [
        Vec3(camera.bounds.left, camera.bounds.top, planeZ),
        Vec3(camera.bounds.right, camera.bounds.top, planeZ),
        Vec3(camera.bounds.right, camera.bounds.bottom, planeZ),
        Vec3(camera.bounds.left, camera.bounds.bottom, planeZ),
        Vec3(camera.bounds.center.dx, camera.bounds.center.dy, planeZ),
      ];

      for (final point in points) {
        final roundTripped = camera.unprojectToPlane(
          camera.project(point),
          planeZ,
        );
        expect(roundTripped.x, closeTo(point.x, 1e-6), reason: '$point');
        expect(roundTripped.y, closeTo(point.y, 1e-6), reason: '$point');
        expect(roundTripped.z, closeTo(planeZ, 1e-6), reason: '$point');
      }
    });

    test('the pointer at the projection centre un-projects to the centre', () {
      final camera = _camera(yawDegrees: -40, pitchDegrees: 25);
      final point = camera.unprojectToPlane(camera.projectionCenter, 0);
      expect(point.x, closeTo(camera.bounds.center.dx, 1e-6));
      expect(point.y, closeTo(camera.bounds.center.dy, 1e-6));
    });
  });

  group('depthOf', () {
    test('points toward the viewer are nearer at rest', () {
      final camera = _camera();
      final center = camera.bounds.center;
      expect(
        camera.depthOf(Vec3(center.dx, center.dy, 1)),
        lessThan(camera.depthOf(Vec3(center.dx, center.dy, -1))),
      );
    });

    test('yaw turns the right edge away from the viewer', () {
      final camera = _camera(yawDegrees: 30);
      final center = camera.bounds.center;
      expect(
        camera.depthOf(Vec3(center.dx + 1, center.dy, 0)),
        greaterThan(camera.depthOf(Vec3(center.dx - 1, center.dy, 0))),
      );
    });

    test('pitch brings the bottom edge toward the viewer', () {
      final camera = _camera(pitchDegrees: 30);
      final center = camera.bounds.center;
      expect(
        camera.depthOf(Vec3(center.dx, center.dy + 1, 0)),
        lessThan(camera.depthOf(Vec3(center.dx, center.dy - 1, 0))),
      );
    });
  });

  group('hit testing', () {
    test('keyIndexAtBoardPoint accepts the centre and rejects the gap', () {
      final keys = [_spec(), _spec(x: 1)];
      final camera = _camera(keys: keys);

      expect(camera.keyIndexAtBoardPoint(const Offset(0.5, 0.5)), 0);
      expect(camera.keyIndexAtBoardPoint(const Offset(1.5, 0.5)), 1);
      // The midpoint between two 1u keys sits in the gap.
      expect(camera.keyIndexAtBoardPoint(const Offset(1, 0.5)), isNull);
      expect(camera.keyIndexAtBoardPoint(const Offset(-5, -5)), isNull);
    });

    test('keyIndexAtBoardPoint prefers the last key under the point', () {
      final keys = [_spec(), _spec()];
      final camera = _camera(keys: keys);
      expect(camera.keyIndexAtBoardPoint(const Offset(0.5, 0.5)), 1);
    });

    test('hit testing undoes a key rotation', () {
      // A 2u-wide key rotated 90 degrees clockwise around its top-left
      // corner points its long axis down, so a point 1.5u below and 0.5u
      // left of the pivot is inside it even though the unrotated rect
      // stops at 2u to the right.
      final key = _spec(w: 2, rotationAngle: 90, rotationX: 0, rotationY: 0);
      final camera = _camera(keys: [key]);
      expect(camera.keyIndexAtBoardPoint(const Offset(-0.5, 1.5)), 0);
    });

    test('a projected point un-projects onto the key it belongs to', () {
      final keys = [_spec(), _spec(x: 1)];
      final camera = _camera(keys: keys, yawDegrees: 25, pitchDegrees: 15);
      const planeZ = 0.2;

      // The centre of the second key's cap, projected and fed back in.
      final projected = camera.project(const Vec3(1.5, 0.5, planeZ));
      final boardPoint = camera.unprojectToPlane(projected, planeZ);
      expect(
        camera.keyIndexAtBoardPoint(Offset(boardPoint.x, boardPoint.y)),
        1,
      );
    });

    test('stepped keys expose their secondary rectangle to hit testing', () {
      final key = _spec(w: 1.25, x2: 0.25, w2: 1.5, h2: 2);
      final camera = _camera(keys: [key]);
      // Inside the secondary extension, beyond the primary's right edge.
      expect(camera.keyIndexAtBoardPoint(const Offset(1.6, 0.5)), 0);
    });
  });
}
