import 'dart:math' as math;

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';

/// One flat, filled polygon of the keyboard scene, already projected to
/// screen space and shaded, ready to paint — the renderer's only drawing
/// primitive.
@immutable
class KeyboardFace {
  /// Creates a face from its projected [points] and resolved [color].
  const new({
    required this.points,
    required this.depth,
    required this.color,
    this.gradient,
    this.strokeColor,
    this.strokeWidth = 1,
    this.legend,
  });

  /// The polygon's vertices, in screen space, in order.
  final List<Offset> points;

  /// Camera-space distance of the face's centre — faces are painted in
  /// descending order of this value (farthest first).
  final double depth;

  /// The flat fill, before [gradient] (when set).
  final Color color;

  /// Optional two-stop sheen for keycap tops — the one sanctioned
  /// gradient of the design system (STACK.md §2.5).
  final Gradient? gradient;

  /// Optional outline, drawn after the fill.
  final Color? strokeColor;

  /// Outline stroke width in logical pixels.
  final double strokeWidth;

  /// Optional printed legend for keycap tops — painted after the fill,
  /// projected onto the cap's own top plane by the camera.
  final KeyboardLegend? legend;
}

/// A keycap's printed legend: up to two text rows (the shifted symbol
/// above the primary one, like a real `!` over `1`), positioned and sized
/// in board units and drawn by the painter through
/// [KeyboardCamera.canvasMatrix] so it lies flat on the cap in true
/// perspective.
@immutable
class KeyboardLegend {
  /// Creates a legend at [position] (the cap top's centre, board units).
  const new({
    required this.position,
    required this.maxWidth,
    required this.primaryFontSize,
    required this.secondaryFontSize,
    required this.lineOffset,
    required this.color,
    this.primary,
    this.secondary,
  });

  /// The main legend (centered, or below [secondary] when both exist).
  final String? primary;

  /// The shifted-symbol legend, drawn above [primary].
  final String? secondary;

  /// The cap top's centre in board space.
  final Vec3 position;

  /// How much room the legend has, in board units — longer labels are
  /// auto-shrunk to fit instead of spilling over neighbouring caps.
  final double maxWidth;

  /// Primary legend em-size, in board units.
  final double primaryFontSize;

  /// Secondary legend em-size, in board units.
  final double secondaryFontSize;

  /// Vertical distance from [position] to each legend row's centre, in
  /// board units — only used when both legends are present.
  final double lineOffset;

  /// Resolved ink color.
  final Color color;
}

/// How much a keycap's top face is inset from its base outline, as a
/// fraction of one key-unit — the classic tapered keycap silhouette.
const _taperFraction = 0.075;

/// How far the plate sits below the case's top face, in key-units.
const _plateRecessFraction = 0.06;

/// Legend sizing/detailing, as fractions of one key-unit.
const _legendPrimarySize = 0.34;
const _legendSecondarySize = 0.24;
const _legendLineOffset = 0.185;

/// Outline segments per rounded corner for the case — smoother than the
/// keycaps' default, since the chassis' curve is long.
const _caseCornerSegments = 4;

/// The direction the scene's single directional light comes from, fixed
/// to the viewer — so faces genuinely change brightness as the board
/// orbits under it.
final Vec3 _lightDirection = const Vec3(-0.35, -0.45, 0.82).normalized();

/// The height a keycap's top face sits at, in key-units above the case's
/// top face — where pointer hit-testing assumes the caps to be.
double keyTopZFor(KeyboardKeycapStyle style) =>
    style.keyDepthFraction - _plateRecessFraction;

/// Builds every face of the keyboard scene for one frame, farthest first:
/// the case (walls, top face, recessed plate) followed by the keycaps,
/// each sorted back-to-front by camera depth. Pressed keys sink along
/// their real z axis and hovered keys tint their top face.
List<KeyboardFace> buildKeyboardScene({
  required List<KeyboardKeySpec> keys,
  required KeyboardKeycapStyle style,
  required KeyboardCamera camera,
  int? hoveredIndex,
  int? pressedIndex,
  double pressProgress = 0,
}) {
  final faces = <KeyboardFace>[
    ..._caseFaces(camera, style),
    ..._plateFaces(camera, style),
  ];

  final byDepth = List.generate(keys.length, (index) => index)
    ..sort(
      (a, b) => _keyDepth(
        camera,
        style,
        keys[b],
      ).compareTo(_keyDepth(camera, style, keys[a])),
    );
  for (final index in byDepth) {
    final pressed = index == pressedIndex ? pressProgress : 0.0;
    faces.addAll(
      _keyFaces(
        camera: camera,
        style: style,
        key: keys[index],
        hovered: index == hoveredIndex,
        pressProgress: pressed,
      ),
    );
  }
  return faces;
}

/// The case's extruded walls and top face, walls first (far to near) so
/// the top face's outline always stays crisp.
List<KeyboardFace> _caseFaces(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
) {
  final rect = camera.caseRect;
  final cornerUnits = style.caseCornerRadius / camera.unit;
  final outline = roundedRectOutline(
    rect,
    cornerUnits,
    segmentsPerCorner: _caseCornerSegments,
  );
  if (outline.isEmpty) return const [];

  final baseZ = -style.caseDepthFraction;
  final inside = Vec3(rect.center.dx, rect.center.dy, baseZ / 2);
  final walls = <KeyboardFace>[];
  for (var i = 0; i < outline.length; i++) {
    final a = outline[i];
    final b = outline[(i + 1) % outline.length];
    final face = _quad(
      camera: camera,
      baseColor: style.caseSide,
      inside: inside,
      a: Vec3(a.dx, a.dy, baseZ),
      b: Vec3(b.dx, b.dy, baseZ),
      c: Vec3(b.dx, b.dy, 0),
      d: Vec3(a.dx, a.dy, 0),
    );
    if (face != null) walls.add(face);
  }
  walls.sort((a, b) => b.depth.compareTo(a.depth));

  final topFace = KeyboardFace(
    points: [
      for (final point in outline) camera.project(Vec3(point.dx, point.dy, 0)),
    ],
    depth: camera.depthOf(Vec3(rect.center.dx, rect.center.dy, 0)),
    color: _shade(style.caseTop, const Vec3(0, 0, 1), camera),
    strokeColor: style.caseBorder,
    strokeWidth: 1.5,
  );
  return [...walls, topFace];
}

/// The darker plate the keys are mounted on, recessed below the case's
/// top face.
List<KeyboardFace> _plateFaces(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
) {
  final rect = camera.caseRect.deflate(
    KeyboardCamera.bezelFraction * KeyboardCamera.plateInsetFraction,
  );
  if (rect.isEmpty) return const [];
  final outline = roundedRectOutline(
    rect,
    style.caseCornerRadius / camera.unit * 0.7,
    segmentsPerCorner: _caseCornerSegments,
  );
  return [
    KeyboardFace(
      points: [
        for (final point in outline)
          camera.project(Vec3(point.dx, point.dy, -_plateRecessFraction)),
      ],
      depth: camera.depthOf(
        Vec3(rect.center.dx, rect.center.dy, -_plateRecessFraction),
      ),
      color: _shade(style.plate, const Vec3(0, 0, 1), camera),
      strokeColor: style.caseBorder,
    ),
  ];
}

/// One key: its tapered cap (primary plus, for stepped keys, secondary
/// rectangle) as side quads plus a gradient-lit top face.
List<KeyboardFace> _keyFaces({
  required KeyboardCamera camera,
  required KeyboardKeycapStyle style,
  required KeyboardKeySpec key,
  required bool hovered,
  required double pressProgress,
}) {
  final cornerUnits = (style.keyCornerRadius / camera.unit).clamp(0.02, 0.24);
  final sink = style.keyDepthFraction * pressProgress;
  final baseZ = -_plateRecessFraction - sink;
  final topZ = style.keyDepthFraction - _plateRecessFraction - sink;
  final accent = key.w > 1.05 || key.h > 1.05;

  final caps = [
    _capFaces(
      camera: camera,
      style: style,
      key: key,
      rect: camera.rectFor(key),
      cornerUnits: cornerUnits,
      baseZ: baseZ,
      topZ: topZ,
      sideColor: accent ? style.keySideAccent : style.keySide,
      topColor: accent ? style.keyTopAccent : style.keyTop,
      hovered: hovered,
      pressProgress: pressProgress,
      withLabel: true,
    ),
  ];
  if (camera.hasSecondaryRect(key)) {
    caps.add(
      _capFaces(
        camera: camera,
        style: style,
        key: key,
        rect: camera.rectFor(key, secondary: true),
        cornerUnits: cornerUnits,
        baseZ: baseZ,
        topZ: topZ,
        sideColor: accent ? style.keySideAccent : style.keySide,
        topColor: accent ? style.keyTopAccent : style.keyTop,
        hovered: hovered,
        pressProgress: pressProgress,
        withLabel: false,
      ),
    );
  }
  return [for (final cap in caps) ...cap];
}

List<KeyboardFace> _capFaces({
  required KeyboardCamera camera,
  required KeyboardKeycapStyle style,
  required KeyboardKeySpec key,
  required Rect rect,
  required double cornerUnits,
  required double baseZ,
  required double topZ,
  required Color sideColor,
  required Color topColor,
  required bool hovered,
  required double pressProgress,
  required bool withLabel,
}) {
  Offset rotate(Offset point) => key.rotationAngle == 0
      ? point
      : rotatePoint(
          point,
          Offset(key.rotationX, key.rotationY),
          key.rotationAngle,
        );

  final baseOutline = [
    for (final point in roundedRectOutline(rect, cornerUnits)) rotate(point),
  ];
  final topRect = rect.deflate(_taperFraction);
  if (baseOutline.isEmpty || topRect.isEmpty) return const [];
  final topOutline = [
    for (final point in roundedRectOutline(
      topRect,
      // Keep a strictly positive radius: `roundedRectOutline` falls back
      // to a 4-point outline at radius 0, which would no longer match the
      // base outline's segment count.
      math.max(0.001, cornerUnits - _taperFraction * 0.35),
    ))
      rotate(point),
  ];

  final center = rotate(rect.center);
  final inside = Vec3(center.dx, center.dy, (baseZ + topZ) / 2);
  final sides = <KeyboardFace>[];
  for (var i = 0; i < baseOutline.length; i++) {
    final next = (i + 1) % baseOutline.length;
    final a = baseOutline[i];
    final b = baseOutline[next];
    final topA = topOutline[i];
    final topB = topOutline[next];
    final face = _quad(
      camera: camera,
      baseColor: sideColor,
      inside: inside,
      a: Vec3(a.dx, a.dy, baseZ),
      b: Vec3(b.dx, b.dy, baseZ),
      c: Vec3(topB.dx, topB.dy, topZ),
      d: Vec3(topA.dx, topA.dy, topZ),
    );
    if (face != null) sides.add(face);
  }
  sides.sort((a, b) => b.depth.compareTo(a.depth));

  var faceColor = hovered
      ? Color.lerp(topColor, style.hoverTint, 0.35)!
      : topColor;
  if (pressProgress > 0) {
    faceColor = Color.lerp(faceColor, sideColor, 0.25 * pressProgress)!;
  }
  // Shade the top face too, so the caps dim and brighten as the board
  // turns under the light instead of staying artificially constant.
  final litTop = _shade(faceColor, const Vec3(0, 0, 1), camera);

  final topPoints = [
    for (final point in topOutline)
      camera.project(Vec3(point.dx, point.dy, topZ)),
  ];
  return [
    ...sides,
    KeyboardFace(
      points: topPoints,
      depth: camera.depthOf(Vec3(center.dx, center.dy, topZ)),
      color: litTop,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          KeyboardKeycapStyle.shiftLightness(litTop, style.topLightnessDelta),
          KeyboardKeycapStyle.shiftLightness(
            litTop,
            -style.bottomLightnessDelta,
          ),
        ],
      ),
      strokeColor: style.keyBorder,
      legend: withLabel && (key.label != null || key.label2 != null)
          ? KeyboardLegend(
              primary: key.label,
              secondary: key.label2,
              position: Vec3(center.dx, center.dy, topZ),
              maxWidth: topRect.width * 0.86,
              primaryFontSize: _legendPrimarySize,
              secondaryFontSize: _legendSecondarySize,
              lineOffset: _legendLineOffset,
              color: style.keyLegend,
            )
          : null,
    ),
  ];
}

/// One shaded, culled quad — or `null` when it's degenerate or facing
/// away from the camera.
KeyboardFace? _quad({
  required KeyboardCamera camera,
  required Color baseColor,
  required Vec3 inside,
  required Vec3 a,
  required Vec3 b,
  required Vec3 c,
  required Vec3 d,
}) {
  var normal = (b - a).cross(c - a);
  if (normal.length < 1e-9) return null;
  normal = normal.normalized();
  if (normal.dot(a - inside) < 0) normal = normal * -1;
  if (camera.rotate(normal).z <= 0) return null;

  final points = [
    camera.project(a),
    camera.project(b),
    camera.project(c),
    camera.project(d),
  ];
  return KeyboardFace(
    points: points,
    depth:
        (camera.depthOf(a) +
            camera.depthOf(b) +
            camera.depthOf(c) +
            camera.depthOf(d)) /
        4,
    color: _shade(baseColor, normal, camera),
  );
}

/// Lambert-ish shading against [_lightDirection], with a wrap term so
/// faces turned fully away from the light stay readable instead of black.
/// The resting top-face intensity is the zero point, so the designed
/// keycap colors survive at rest (STACK.md §2.5, contrast test).
Color _shade(Color base, Vec3 boardNormal, KeyboardCamera camera) {
  final normal = camera.rotate(boardNormal);
  final intensity = _intensity(normal);
  return KeyboardKeycapStyle.shiftLightness(
    base,
    (intensity - _restingTopIntensity) * 0.45,
  );
}

double _intensity(Vec3 cameraNormal) =>
    0.45 + 0.55 * (0.5 + 0.5 * _lightDirection.dot(cameraNormal));

final double _restingTopIntensity = _intensity(const Vec3(0, 0, 1));

/// Sort depth for [key]: the middle of its footprint at mid-cap height.
double _keyDepth(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
  KeyboardKeySpec key,
) => camera.depthOf(
  Vec3(key.x + key.w / 2, key.y + key.h / 2, keyTopZFor(style)),
);
