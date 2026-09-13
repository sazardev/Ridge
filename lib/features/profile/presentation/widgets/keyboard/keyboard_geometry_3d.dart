import 'dart:math' as math;

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' show Matrix4;

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';

/// A point or direction in the keyboard's 3D space, in key-units: `x`
/// grows right, `y` grows down (matching the key-spec grid), `z` grows
/// toward the viewer out of the case's top face. Deliberately minimal —
/// the few operations the software renderer needs, not a general-purpose
/// vector library.
@immutable
class Vec3 {
  /// Creates a vector from its three components.
  const new(this.x, this.y, this.z);

  /// The x component (right).
  final double x;

  /// The y component (down).
  final double y;

  /// The z component (toward the viewer).
  final double z;

  /// The origin.
  static const zero = Vec3(0, 0, 0);

  /// Component-wise sum.
  Vec3 operator +(Vec3 other) => Vec3(x + other.x, y + other.y, z + other.z);

  /// Component-wise difference.
  Vec3 operator -(Vec3 other) => Vec3(x - other.x, y - other.y, z - other.z);

  /// Scalar multiplication.
  Vec3 operator *(double scalar) => Vec3(x * scalar, y * scalar, z * scalar);

  /// Dot product.
  double dot(Vec3 other) => x * other.x + y * other.y + z * other.z;

  /// Cross product, following the right-hand rule in this y-down space.
  Vec3 cross(Vec3 other) => Vec3(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  /// Euclidean length.
  double get length => math.sqrt(dot(this));

  /// A unit-length copy of this vector (itself when it's zero-length).
  Vec3 normalized() {
    final len = length;
    return len == 0 ? this : this * (1 / len);
  }

  @override
  bool operator ==(Object other) =>
      other is Vec3 && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'Vec3($x, $y, $z)';
}

/// Samples a rounded rectangle as a closed polyline in board units,
/// starting at the top-left corner's left edge and walking clockwise
/// (in this y-down space: along the top, down the right side, ...).
///
/// Every corner is approximated with [segmentsPerCorner] straight
/// segments — enough that keycaps read as rounded under the renderer's
/// per-face shading, without ballooning the face count (each segment
/// becomes one side quad of the extruded cap).
List<Offset> roundedRectOutline(
  Rect rect,
  double radius, {
  int segmentsPerCorner = 3,
}) {
  if (rect.isEmpty) return const [];
  final r = radius.clamp(0.0, math.min(rect.width, rect.height) / 2);
  if (r <= 0) {
    return [rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft];
  }

  final points = <Offset>[];
  void arc(Offset center, double startDegrees) {
    for (var i = 0; i < segmentsPerCorner; i++) {
      final angle = (startDegrees + 90 * i / segmentsPerCorner) * math.pi / 180;
      points.add(
        Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        ),
      );
    }
  }

  // y-down angles: 180° points left, 270° up, 0° right, 90° down.
  arc(Offset(rect.left + r, rect.top + r), 180);
  arc(Offset(rect.right - r, rect.top + r), 270);
  arc(Offset(rect.right - r, rect.bottom - r), 0);
  arc(Offset(rect.left + r, rect.bottom - r), 90);
  return points;
}

/// The resolved mapping from board space (key-units, `z = 0` at the
/// case's top face) to screen space for one frame of the 3D renderer:
/// where the board's centre lands, how many pixels one key-unit spans,
/// and the yaw/pitch the camera is orbiting to.
///
/// A single place resolves this so the face builder (which projects real
/// 3D geometry) and pointer hit-testing (which un-projects the pointer
/// back onto the keycap plane) can never drift apart — the same contract
/// the old 2D `KeyboardLayoutTransform` had.
class KeyboardCamera {
  /// Creates a camera from already-resolved values — callers go through
  /// [KeyboardCamera.fit] instead.
  const new({
    required this.keys,
    required this.bounds,
    required this.unit,
    required this.projectionCenter,
    required this.yawRadians,
    required this.pitchRadians,
    required this.distanceUnits,
  });

  /// Resolves how [keys] fit into [size] with the camera tilted by
  /// [yawDegrees]/[pitchDegrees], so the projected case (with the caps'
  /// [topFraction] and the case's [depthFraction] accounted for) always
  /// stays in frame: the board is fitted at rest, then only ever *shrinks*
  /// as it orbits — a diagonal board projects taller than it looks at
  /// rest, and scaling it down beats clipping keycaps at the frame edge.
  factory fit({
    required List<KeyboardKeySpec> keys,
    required Size size,
    double depthFraction = 0,
    double topFraction = 0,
    double yawDegrees = 0,
    double pitchDegrees = 0,
  }) {
    final bounds = contentBoundsOf(keys);
    final caseRect = bounds.inflate(bezelFraction);
    final distanceUnits =
        math.max(bounds.width, bounds.height) * perspectiveFactor;

    KeyboardCamera probe(double yaw, double pitch) => KeyboardCamera(
      keys: keys,
      bounds: bounds,
      unit: 1,
      projectionCenter: Offset.zero,
      yawRadians: yaw * math.pi / 180,
      pitchRadians: pitch * math.pi / 180,
      distanceUnits: distanceUnits,
    );

    Rect projectedBox(KeyboardCamera camera) {
      var minX = double.infinity;
      var minY = double.infinity;
      var maxX = double.negativeInfinity;
      var maxY = double.negativeInfinity;
      for (final x in [caseRect.left, caseRect.right]) {
        for (final y in [caseRect.top, caseRect.bottom]) {
          for (final z in [-depthFraction, topFraction]) {
            final point = camera.project(Vec3(x, y, z));
            minX = math.min(minX, point.dx);
            minY = math.min(minY, point.dy);
            maxX = math.max(maxX, point.dx);
            maxY = math.max(maxY, point.dy);
          }
        }
      }
      return Rect.fromLTRB(minX, minY, maxX, maxY);
    }

    double unitFor(Rect box) =>
        math.min(size.width / box.width, size.height / box.height);

    final restUnit = unitFor(projectedBox(probe(0, 0)));
    final currentBox = projectedBox(probe(yawDegrees, pitchDegrees));
    final unit = math.min(restUnit, unitFor(currentBox));
    return KeyboardCamera(
      keys: keys,
      bounds: bounds,
      unit: unit,
      projectionCenter: Offset(
        size.width / 2 - currentBox.center.dx * unit,
        size.height / 2 - currentBox.center.dy * unit,
      ),
      yawRadians: yawDegrees * math.pi / 180,
      pitchRadians: pitchDegrees * math.pi / 180,
      distanceUnits: distanceUnits,
    );
  }

  /// The keys this camera maps, in the painter's draw order.
  final List<KeyboardKeySpec> keys;

  /// The board's bounding box in key-units (rotation-aware).
  final Rect bounds;

  /// How many logical pixels one key-unit spans at the board's
  /// mid-plane (where the camera is focus-calibrated).
  final double unit;

  /// Where the board's centre (`bounds.center`, `z = 0`) lands on screen.
  final Offset projectionCenter;

  /// Camera orbit around the vertical axis, in radians.
  final double yawRadians;

  /// Camera orbit around the horizontal axis, in radians.
  final double pitchRadians;

  /// Camera distance from the board's centre, in key-units. Larger is a
  /// flatter, more telephoto look.
  final double distanceUnits;

  /// Gap between adjacent keycaps, as a fraction of one key-unit.
  static const keyGapFraction = 0.14;

  /// How far the case extends past the outermost keys per side, as a
  /// fraction of one key-unit.
  static const bezelFraction = 0.45;

  /// How far the plate is inset from the case edge, as a fraction of the
  /// bezel.
  static const plateInsetFraction = 0.55;

  /// Camera distance as a multiple of the board's longest side — a mild
  /// product-shot perspective, far enough that the allowed drag angles
  /// never magnify the near edge out of its frame.
  static const perspectiveFactor = 4.0;

  /// The board's centre in board space.
  Vec3 get _center => Vec3(bounds.center.dx, bounds.center.dy, 0);

  /// The rectangle the outer case covers, in board units.
  Rect get caseRect => bounds.inflate(bezelFraction);

  /// Whether [key] has a second, distinct rectangle (stepped keys).
  bool hasSecondaryRect(KeyboardKeySpec key) =>
      key.x2 != 0 || key.y2 != 0 || key.w2 != key.w || key.h2 != key.h;

  /// [key]'s gap-inset rectangle in board units — the primary one, or the
  /// stepped key's secondary one when [secondary] is set.
  Rect rectFor(KeyboardKeySpec key, {bool secondary = false}) {
    final x = secondary ? key.x + key.x2 : key.x;
    final y = secondary ? key.y + key.y2 : key.y;
    final w = secondary ? key.w2 : key.w;
    final h = secondary ? key.h2 : key.h;
    return Rect.fromLTWH(
      x + keyGapFraction / 2,
      y + keyGapFraction / 2,
      w - keyGapFraction,
      h - keyGapFraction,
    );
  }

  /// The board-space position of [key]'s rotation pivot.
  Offset pivotFor(KeyboardKeySpec key) => Offset(key.rotationX, key.rotationY);

  /// Whether [point] (in board units) falls on [key]'s primary or
  /// secondary rectangle, undoing the key's rotation first.
  bool hitTestKey(KeyboardKeySpec key, Offset point) {
    final local = key.rotationAngle == 0
        ? point
        : rotatePoint(point, pivotFor(key), -key.rotationAngle);
    if (rectFor(key).contains(local)) return true;
    return hasSecondaryRect(key) &&
        rectFor(key, secondary: true).contains(local);
  }

  /// The index of the last key whose rectangle contains [boardPoint]
  /// (board units), or `null` — later keys win, matching the draw order.
  int? keyIndexAtBoardPoint(Offset boardPoint) {
    for (var i = keys.length - 1; i >= 0; i--) {
      if (hitTestKey(keys[i], boardPoint)) return i;
    }
    return null;
  }

  /// Rotates [vector] (a board-space direction, no translation) into
  /// camera space — used for lighting, so faces change brightness as the
  /// board turns under a light fixed to the viewer.
  Vec3 rotate(Vec3 vector) {
    final cy = math.cos(yawRadians);
    final sy = math.sin(yawRadians);
    final x1 = vector.x * cy + vector.z * sy;
    final z1 = -vector.x * sy + vector.z * cy;

    final cp = math.cos(pitchRadians);
    final sp = math.sin(pitchRadians);
    return Vec3(x1, vector.y * cp - z1 * sp, vector.y * sp + z1 * cp);
  }

  /// Projects [boardPoint] to screen space.
  Offset project(Vec3 boardPoint) {
    final r = rotate(boardPoint - _center);
    final depth = math.max(distanceUnits - r.z, distanceUnits * 0.05);
    final scale = unit * distanceUnits / depth;
    return projectionCenter + Offset(r.x * scale, r.y * scale);
  }

  /// The same projection as [project], but as a matrix the engine can
  /// apply to a whole canvas via `Canvas.transform` — this is what puts
  /// keycap legends on their cap's top plane with real perspective
  /// instead of just scaling flat text. The projection-centre translation
  /// is pre-multiplied (not appended), because the perspective term has
  /// to multiply it too for the homogeneous divide to match [project]
  /// exactly.
  Matrix4 get canvasMatrix {
    final model = Matrix4.identity()
      ..scaleByDouble(unit, unit, 1, 1)
      ..setEntry(3, 2, -1 / distanceUnits)
      ..rotateX(pitchRadians)
      ..rotateY(yawRadians)
      ..translateByDouble(-bounds.center.dx, -bounds.center.dy, 0, 1);
    return Matrix4.translationValues(
      projectionCenter.dx,
      projectionCenter.dy,
      0,
    )..multiply(model);
  }

  /// Camera-space distance of [boardPoint] — bigger is farther away.
  /// Faces are painted in descending order of this value.
  double depthOf(Vec3 boardPoint) =>
      distanceUnits - rotate(boardPoint - _center).z;

  /// Un-projects [screen] back onto the horizontal plane `z = zPlane` (in
  /// board units) — the inverse of [project] restricted to that plane,
  /// which is exactly what pointer hit-testing needs: a screen position
  /// becomes a board-space position that can be checked against the key
  /// rectangles regardless of the camera's current tilt.
  Vec3 unprojectToPlane(Offset screen, double zPlane) {
    final offset = screen - projectionCenter;
    final center = _center;

    Vec3 at(double t) {
      final depth = distanceUnits - t;
      final rx = offset.dx * depth / (unit * distanceUnits);
      final ry = offset.dy * depth / (unit * distanceUnits);
      return center + _inverseRotate(Vec3(rx, ry, t));
    }

    final atZero = at(0);
    final atOne = at(1);
    final dz = atOne.z - atZero.z;
    if (dz.abs() < 1e-9) return atZero;
    return at((zPlane - atZero.z) / dz);
  }

  Vec3 _inverseRotate(Vec3 vector) {
    final cp = math.cos(pitchRadians);
    final sp = math.sin(pitchRadians);
    final y1 = vector.y * cp + vector.z * sp;
    final z1 = -vector.y * sp + vector.z * cp;

    final cy = math.cos(yawRadians);
    final sy = math.sin(yawRadians);
    return Vec3(vector.x * cy - z1 * sy, y1, vector.x * sy + z1 * cy);
  }
}
