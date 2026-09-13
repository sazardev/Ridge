import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_effects.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_faces.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_shading.dart';

export 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_faces.dart';

/// Legend sizing/detailing, as fractions of one key-unit.
const _legendPrimarySize = 0.27;
const _legendSecondarySize = 0.19;
const _legendLineOffset = 0.10;

/// Outline segments per rounded corner for the case — smoother than the
/// keycaps' default, since the chassis' curve is long.
const _caseCornerSegments = 4;

/// The height a keycap's top face sits at, in key-units above the case's
/// top face — where pointer hit-testing assumes the caps to be.
double keyTopZFor(KeyboardKeycapStyle style) =>
    style.keyDepthFraction - plateRecessFraction;

/// Builds every face of the keyboard scene for one frame, farthest first:
/// the case (walls, top face, recessed plate) followed by the keycaps,
/// each sorted back-to-front by camera depth. Pressed keys sink along
/// their real z axis and hovered keys tint their top face. With RGB
/// enabled, an ambient glow is laid down before everything else and the
/// caps/plate are tinted toward the current light color; [rgbPhase] (0..1,
/// repeating) drives the animated effects and is ignored by the static
/// effect (see `keyboard_scene_shading.dart`). [keyPulses] adds the
/// reactive per-key flash (0..1, decaying) on top of whatever the effect
/// is doing, [rippleAges] spreads the typewriter splash from each pressed
/// key's origin (seconds of age per origin key), and [keyPressLevels]
/// sinks caps held down by an external source (the real keyboard, in the
/// viewer/editor) alongside the pointer's own [pressedIndex].
List<KeyboardFace> buildKeyboardScene({
  required List<KeyboardKeySpec> keys,
  required KeyboardKeycapStyle style,
  required KeyboardCamera camera,
  int? hoveredIndex,
  int? pressedIndex,
  double pressProgress = 0,
  double rgbPhase = 0,
  List<int?>? keyLightColors,
  List<double>? keyPressLevels,
  List<double>? keyPulses,
  List<double>? rippleAges,
}) {
  final faces = <KeyboardFace>[
    if (style.rgbEnabled) ...rgbGlowFaces(camera, style, rgbPhase),
    ..._caseFaces(camera, style),
    ..._plateFaces(camera, style, rgbPhase),
    if (style.rgbEnabled)
      ...plateGlowFaces(
        camera,
        style,
        rgbPhase,
        keys,
        keyLightColors,
        keyPressLevels,
        keyPulses,
        rippleAges,
      ),
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
    final pointerPress = index == pressedIndex ? pressProgress : 0.0;
    final held = levelAt(keyPressLevels, index);
    final boost = math.min(
      1.6,
      levelAt(keyPulses, index) + rippleBoost(keys, index, rippleAges),
    );
    faces.addAll(
      _keyFaces(
        camera: camera,
        style: style,
        key: keys[index],
        hovered: index == hoveredIndex,
        pressProgress: math.max(pointerPress, held),
        pulse: boost,
        rgbPhase: rgbPhase,
        lightColor: _lightColorFor(keyLightColors, index),
      ),
    );
  }
  return faces;
}

int? _lightColorFor(List<int?>? keyLightColors, int index) =>
    (keyLightColors != null && index < keyLightColors.length)
    ? keyLightColors[index]
    : null;

/// One key: its tapered cap (primary plus, for stepped keys, secondary
/// rectangle) as side quads plus a gradient-lit top face.
/// The case's extruded walls and top face, walls first (far to near) so
/// the top face's outline always stays crisp.
List<KeyboardFace> _caseFaces(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
) {
  final rect = camera.caseRect;
  // Theme radii are screen pixels; converting them with the fitted unit
  // would make corners balloon on small screens (a phone's unit is a
  // third of a desktop's), so they are capped to a size-independent
  // fraction — big screens keep the exact px radius, small screens keep
  // the same *shape*.
  final outline = roundedRectOutline(
    rect,
    caseCornerUnits(style, camera),
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
    color: shadeFace(style.caseTop, const Vec3(0, 0, 1), camera),
    strokeColor: style.caseBorder,
    strokeWidth: 1.5,
  );
  return [...walls, topFace];
}

/// The darker plate the keys are mounted on, recessed below the case's
/// top face. With RGB on it takes a pronounced share of the current light
/// color, which is what reads as "the light is underneath the keys".
List<KeyboardFace> _plateFaces(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
  double rgbPhase,
) {
  final rect = camera.caseRect.deflate(
    KeyboardCamera.bezelFraction * KeyboardCamera.plateInsetFraction,
  );
  if (rect.isEmpty) return const [];
  final outline = roundedRectOutline(
    rect,
    plateCornerUnits(style, camera),
    segmentsPerCorner: _caseCornerSegments,
  );
  final plateColor = style.rgbEnabled
      ? Color.lerp(
          style.plate,
          rgbTint(style, rgbPhase, null, camera),
          0.30 * rgbIntensity(style, rgbPhase),
        )!
      : style.plate;
  return [
    KeyboardFace(
      points: [
        for (final point in outline)
          camera.project(Vec3(point.dx, point.dy, -plateRecessFraction)),
      ],
      depth: camera.depthOf(
        Vec3(rect.center.dx, rect.center.dy, -plateRecessFraction),
      ),
      color: shadeFace(plateColor, const Vec3(0, 0, 1), camera),
      strokeColor: style.caseBorder,
    ),
  ];
}

List<KeyboardFace> _keyFaces({
  required KeyboardCamera camera,
  required KeyboardKeycapStyle style,
  required KeyboardKeySpec key,
  required bool hovered,
  required double pressProgress,
  required double pulse,
  required double rgbPhase,
  required int? lightColor,
}) {
  final sink = style.keyDepthFraction * pressProgress;
  final baseZ = -plateRecessFraction - sink;
  final topZ = style.keyDepthFraction - plateRecessFraction - sink;
  final accent = key.w > 1.05 || key.h > 1.05;

  final caps = [
    _capFaces(
      camera: camera,
      style: style,
      key: key,
      rect: camera.rectFor(key),
      baseZ: baseZ,
      topZ: topZ,
      sideColor: accent ? style.keySideAccent : style.keySide,
      topColor: accent ? style.keyTopAccent : style.keyTop,
      hovered: hovered,
      pressProgress: pressProgress,
      pulse: pulse,
      withLabel: true,
      rgbPhase: rgbPhase,
      lightColor: lightColor,
    ),
  ];
  if (camera.hasSecondaryRect(key)) {
    caps.add(
      _capFaces(
        camera: camera,
        style: style,
        key: key,
        rect: camera.rectFor(key, secondary: true),
        baseZ: baseZ,
        topZ: topZ,
        sideColor: accent ? style.keySideAccent : style.keySide,
        topColor: accent ? style.keyTopAccent : style.keyTop,
        hovered: hovered,
        pressProgress: pressProgress,
        pulse: pulse,
        withLabel: false,
        rgbPhase: rgbPhase,
        lightColor: lightColor,
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
  required double baseZ,
  required double topZ,
  required Color sideColor,
  required Color topColor,
  required bool hovered,
  required double pressProgress,
  required double pulse,
  required bool withLabel,
  required double rgbPhase,
  required int? lightColor,
}) {
  Offset rotate(Offset point) => key.rotationAngle == 0
      ? point
      : rotatePoint(
          point,
          Offset(key.rotationX, key.rotationY),
          key.rotationAngle,
        );

  final segments = style.keycapShape == KeycapShape.round
      ? roundCornerSegments
      : 3;
  final baseCornerUnits = keyBaseCornerUnits(style, rect, camera);
  final baseOutline = [
    for (final point in roundedRectOutline(
      rect,
      baseCornerUnits,
      segmentsPerCorner: segments,
    ))
      rotate(point),
  ];
  final topRect = rect.deflate(keycapTaperFraction);
  if (baseOutline.isEmpty || topRect.isEmpty) return const [];
  final topOutline = [
    for (final point in roundedRectOutline(
      topRect,
      keyTopCornerUnits(style, baseCornerUnits, topRect),
      segmentsPerCorner: segments,
    ))
      rotate(point),
  ];

  final center = rotate(rect.center);
  final inside = Vec3(center.dx, center.dy, (baseZ + topZ) / 2);
  // With RGB on, the cap's sides pick up a share of the current light
  // color (light spilling out around the cap), the top face gets a wash
  // and the legend is tinted — all scaled by the cap's light transmission
  // (`KeycapTransparency`: opaque caps keep a dark legend and barely wash;
  // pudding caps glow from the sides; translucent ones light up whole). A
  // per-key light (when set) replaces the board-wide color for this cap.
  final tint = style.rgbEnabled
      ? (lightColor != null
            ? Color(lightColor)
            : rgbTint(style, rgbPhase, key, camera))
      : null;
  // The effect's per-key brightness; the reactive mode keeps held keys
  // lit, and any pulse/ripple adds on top before everything saturates.
  var glow = style.rgbEnabled
      ? effectIntensity(style, rgbPhase, key, camera)
      : 0.0;
  if (style.rgbEnabled &&
      style.rgbEffect == RgbEffect.reactive &&
      pressProgress > 0) {
    glow = math.max(glow, pressProgress * 1.2);
  }
  glow = math.min(1.6, glow + pulse);
  final litSide = tint == null
      ? sideColor
      : Color.lerp(
          sideColor,
          tint,
          (style.sideLightFraction * glow + 0.3 * pulse).clamp(0.0, 1.0),
        )!;
  final sides = <KeyboardFace>[];
  for (var i = 0; i < baseOutline.length; i++) {
    final next = (i + 1) % baseOutline.length;
    final a = baseOutline[i];
    final b = baseOutline[next];
    final topA = topOutline[i];
    final topB = topOutline[next];
    final face = _quad(
      camera: camera,
      baseColor: litSide,
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
  if (tint != null) {
    faceColor = Color.lerp(
      faceColor,
      tint,
      (style.topLightFraction * glow + 0.35 * pulse).clamp(0.0, 0.8),
    )!;
  }
  if (pressProgress > 0) {
    faceColor = Color.lerp(faceColor, sideColor, 0.25 * pressProgress)!;
  }
  // Shade the top face too, so the caps dim and brighten as the board
  // turns under the light instead of staying artificially constant.
  final litTop = shadeFace(faceColor, const Vec3(0, 0, 1), camera);

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
      glowColor: tint?.withValues(
        alpha: (style.glowLightFraction * glow + 0.30 * pulse).clamp(0.0, 0.8),
      ),
      legend: withLabel && (key.label != null || key.label2 != null)
          ? KeyboardLegend(
              primary: key.label,
              secondary: key.label2,
              position: Vec3(center.dx, center.dy, topZ),
              maxWidth: topRect.width * 0.86,
              primaryFontSize: _legendPrimarySize,
              secondaryFontSize: _legendSecondarySize,
              lineOffset: _legendLineOffset,
              color: tint == null
                  ? style.keyLegend
                  : Color.lerp(
                      style.keyLegend,
                      tint,
                      (style.legendLightFraction * math.min(1.0, glow) +
                              0.4 * pulse)
                          .clamp(0.0, 1.0),
                    )!,
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
    color: shadeFace(baseColor, normal, camera),
  );
}

/// Sort depth for [key]: the middle of its footprint at mid-cap height.
double _keyDepth(
  KeyboardCamera camera,
  KeyboardKeycapStyle style,
  KeyboardKeySpec key,
) => camera.depthOf(
  Vec3(key.x + key.w / 2, key.y + key.h / 2, keyTopZFor(style)),
);
