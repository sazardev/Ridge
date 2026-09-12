import 'dart:math' as math;
import 'dart:ui' show Offset, Rect, Size;

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';

/// Rotates [point] by [degrees] around [pivot] — plain 2D rotation, pulled
/// out of `KeyboardLayoutPainter` so the math is unit-testable without a
/// real `Canvas`.
Offset rotatePoint(Offset point, Offset pivot, double degrees) {
  final rad = degrees * math.pi / 180;
  final dx = point.dx - pivot.dx;
  final dy = point.dy - pivot.dy;
  return Offset(
    pivot.dx + dx * math.cos(rad) - dy * math.sin(rad),
    pivot.dy + dx * math.sin(rad) + dy * math.cos(rad),
  );
}

/// A [key]'s eight corners, in key-units, before rotation — both the
/// primary rectangle and the secondary one (which equals the primary one
/// for a plain, non-stepped key).
List<Offset> cornersOf(KeyboardKeySpec key) => [
  Offset(key.x, key.y),
  Offset(key.x + key.w, key.y),
  Offset(key.x, key.y + key.h),
  Offset(key.x + key.w, key.y + key.h),
  Offset(key.x + key.x2, key.y + key.y2),
  Offset(key.x + key.x2 + key.w2, key.y + key.y2),
  Offset(key.x + key.x2, key.y + key.y2 + key.h2),
  Offset(key.x + key.x2 + key.w2, key.y + key.y2 + key.h2),
];

/// The bounding box of every [keys] entry, in key-units, accounting for
/// per-key rotation — every key's (possibly rotated) corners are
/// considered, not just its unrotated footprint, so a rotated thumb
/// cluster never clips out of frame.
Rect contentBoundsOf(List<KeyboardKeySpec> keys) {
  var minX = double.infinity;
  var minY = double.infinity;
  var maxX = double.negativeInfinity;
  var maxY = double.negativeInfinity;

  for (final key in keys) {
    final pivot = Offset(key.rotationX, key.rotationY);
    for (final corner in cornersOf(key)) {
      final rotated = key.rotationAngle == 0
          ? corner
          : rotatePoint(corner, pivot, key.rotationAngle);
      minX = math.min(minX, rotated.dx);
      minY = math.min(minY, rotated.dy);
      maxX = math.max(maxX, rotated.dx);
      maxY = math.max(maxY, rotated.dy);
    }
  }
  return Rect.fromLTRB(minX, minY, maxX, maxY);
}

/// The resolved screen-space mapping of a key-unit grid into a paint
/// [Size]: which scale one key-unit got, where key-space (0, 0) landed,
/// and the gap-inset rectangle every key actually covers. One place
/// computes this so `KeyboardLayoutPainter` (which draws) and the
/// interactive `KeyboardVisual` (which hit-tests the pointer against the
/// same rectangles) can never drift apart.
class KeyboardLayoutTransform {
  /// Creates a transform from already-resolved values — callers go
  /// through [KeyboardLayoutTransform.fit] instead.
  const new({
    required this.keys,
    required this.bounds,
    required this.unit,
    required this.origin,
    required this.gap,
  });

  /// Resolves how [keys] fit into [size], reserving room for
  /// [depthFraction]'s downward extrusion at the bottom so it never clips.
  factory fit({
    required List<KeyboardKeySpec> keys,
    required Size size,
    double depthFraction = 0,
  }) {
    final bounds = contentBoundsOf(keys);
    final unit = math.min(
      size.width / (bounds.width + bezelFraction * 2),
      size.height / (bounds.height + bezelFraction * 2 + depthFraction),
    );
    final gridWidth = unit * bounds.width;
    final gridHeight = unit * bounds.height;
    final depth = unit * depthFraction;
    return KeyboardLayoutTransform(
      keys: keys,
      bounds: bounds,
      unit: unit,
      origin: Offset(
        (size.width - gridWidth) / 2 - bounds.left * unit,
        (size.height - gridHeight - depth) / 2 - bounds.top * unit,
      ),
      gap: unit * keyGapFraction,
    );
  }

  /// The keys this transform maps, in the painter's back-to-front order.
  final List<KeyboardKeySpec> keys;

  /// The layouts's bounding box in key-units (rotation-aware).
  final Rect bounds;

  /// How many logical pixels one key-unit spans.
  final double unit;

  /// The screen position of key-space origin (0, 0).
  final Offset origin;

  /// The gap between adjacent keycaps, in logical pixels.
  final double gap;

  /// Gap between adjacent keycaps, as a fraction of one key-unit.
  static const keyGapFraction = 0.14;

  /// How far the case extends past the outermost keys per side, as a
  /// fraction of one key-unit.
  static const bezelFraction = 0.45;

  /// How far the plate is inset from the case edge, as a fraction of the
  /// bezel.
  static const plateInsetFraction = 0.55;

  /// The case's bezel width in logical pixels.
  double get bezel => unit * bezelFraction;

  /// The rectangle the outer case covers, in screen space.
  Rect get caseRect => Rect.fromLTRB(
    origin.dx + bounds.left * unit - bezel,
    origin.dy + bounds.top * unit - bezel,
    origin.dx + bounds.right * unit + bezel,
    origin.dy + bounds.bottom * unit + bezel,
  );

  /// Whether [key] has a second, distinct rectangle (stepped keys).
  bool hasSecondaryRect(KeyboardKeySpec key) =>
      key.x2 != 0 || key.y2 != 0 || key.w2 != key.w || key.h2 != key.h;

  /// [key]'s gap-inset rectangle in screen space — the primary one, or
  /// the stepped key's secondary one when [secondary] is set.
  Rect rectFor(KeyboardKeySpec key, {bool secondary = false}) {
    final x = secondary ? key.x + key.x2 : key.x;
    final y = secondary ? key.y + key.y2 : key.y;
    final w = secondary ? key.w2 : key.w;
    final h = secondary ? key.h2 : key.h;
    return Rect.fromLTWH(
      origin.dx + x * unit + gap / 2,
      origin.dy + y * unit + gap / 2,
      w * unit - gap,
      h * unit - gap,
    );
  }

  /// The screen position of [key]'s rotation pivot.
  Offset pivotFor(KeyboardKeySpec key) => Offset(
    origin.dx + key.rotationX * unit,
    origin.dy + key.rotationY * unit,
  );

  /// Whether [point] (in screen space) falls on [key]'s primary or
  /// secondary rectangle, undoing the key's rotation first.
  bool hitTest(KeyboardKeySpec key, Offset point) {
    final local = key.rotationAngle == 0
        ? point
        : rotatePoint(point, pivotFor(key), -key.rotationAngle);
    if (rectFor(key).contains(local)) return true;
    return hasSecondaryRect(key) &&
        rectFor(key, secondary: true).contains(local);
  }

  /// The index of the last-drawn key under [point], or `null` — drawing
  /// order means later keys win, which matches what the user sees.
  int? keyIndexAt(Offset point) {
    for (var i = keys.length - 1; i >= 0; i--) {
      if (hitTest(keys[i], point)) return i;
    }
    return null;
  }
}
