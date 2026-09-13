import 'dart:math' as math;
import 'dart:ui' show Offset, Rect;

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';

/// Rotates [point] by [degrees] around [pivot] — plain 2D rotation, pulled
/// out of the keyboard rendering so the math is unit-testable without a
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
