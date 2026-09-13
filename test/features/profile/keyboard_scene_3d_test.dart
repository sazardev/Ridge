// Unit tests for the 3D scene builder: real faces out of key specs, with
// hover/press affecting the rendered result (color and z sink), and the
// stepped-key extension adding geometry.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_effects.dart';

const _key = KeyboardKeySpec(
  x: 0,
  y: 0,
  w: 1,
  h: 1,
  x2: 0,
  y2: 0,
  w2: 1,
  h2: 1,
  rotationAngle: 0,
  rotationX: 0,
  rotationY: 0,
);

final _scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
final _style = KeyboardKeycapStyle.fromScheme(
  _scheme,
  keyCornerRadius: 8,
  caseCornerRadius: 12,
);

KeyboardKeycapStyle _customStyle(KeyboardCustomization customization) =>
    KeyboardKeycapStyle.fromScheme(
      _scheme,
      keyCornerRadius: 8,
      caseCornerRadius: 12,
      customization: customization,
    );

KeyboardCamera _camera(
  List<KeyboardKeySpec> keys, {
  double yawDegrees = 0,
  double pitchDegrees = 0,
}) => KeyboardCamera.fit(
  keys: keys,
  size: const Size(300, 200),
  depthFraction: _style.caseDepthFraction,
  yawDegrees: yawDegrees,
  pitchDegrees: pitchDegrees,
);

List<KeyboardFace> _scene(
  List<KeyboardKeySpec> keys, {
  int? hoveredIndex,
  int? pressedIndex,
  double pressProgress = 0,
  double yawDegrees = 0,
  double pitchDegrees = 0,
}) => buildKeyboardScene(
  keys: keys,
  style: _style,
  camera: _camera(keys, yawDegrees: yawDegrees, pitchDegrees: pitchDegrees),
  hoveredIndex: hoveredIndex,
  pressedIndex: pressedIndex,
  pressProgress: pressProgress,
);

/// The cap's top face is the only gradient-bearing face in the scene.
KeyboardFace _topFace(List<KeyboardFace> faces) =>
    faces.singleWhere((face) => face.gradient != null);

double _centroidY(KeyboardFace face) =>
    face.points.map((point) => point.dy).reduce((a, b) => a + b) /
    face.points.length;

void main() {
  test('builds a whole scene — case and cap — from one key spec', () {
    final faces = _scene([_key]);

    // Case walls + top + plate + a 12-quad cap with its top.
    expect(faces.length, greaterThan(12));
    for (final face in faces) {
      expect(face.points.length, greaterThanOrEqualTo(3));
      for (final point in face.points) {
        expect(point.dx.isFinite, isTrue);
        expect(point.dy.isFinite, isTrue);
      }
    }
  });

  test('a stepped key adds the secondary rectangle geometry', () {
    const stepped = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1.25,
      h: 1,
      x2: 0.25,
      y2: 0,
      w2: 1.5,
      h2: 2,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
    );

    expect(_scene([stepped]).length, greaterThan(_scene([_key]).length));
  });

  test('pressing sinks the cap along its z axis', () {
    final rest = _centroidY(_topFace(_scene([_key], pitchDegrees: 30)));
    final pressed = _centroidY(
      _topFace(
        _scene([_key], pressedIndex: 0, pressProgress: 1, pitchDegrees: 30),
      ),
    );

    // With the board pitched forward, sinking the cap moves it down-screen.
    expect(pressed, greaterThan(rest));
  });

  test('hovering tints the cap top', () {
    final rest = _topFace(_scene([_key])).color;
    final hovered = _topFace(_scene([_key], hoveredIndex: 0)).color;

    expect(hovered, isNot(rest));
  });

  test('a labeled key carries its legend on the cap top', () {
    const labeled = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
      label: 'A',
    );
    final top = _topFace(_scene([labeled]));

    expect(top.legend, isNotNull);
    expect(top.legend!.primary, 'A');
    expect(top.legend!.secondary, isNull);
    expect(top.legend!.color, _style.keyLegend);
  });

  test('shifted legends ride above the primary one', () {
    const labeled = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
      label: '1',
      label2: '!',
    );
    final legend = _topFace(_scene([labeled])).legend!;

    expect(legend.primary, '1');
    expect(legend.secondary, '!');
    expect(legend.primaryFontSize, greaterThan(legend.secondaryFontSize));
  });

  test('stepped keys print their legend exactly once', () {
    const stepped = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1.25,
      h: 1,
      x2: 0.25,
      y2: 0,
      w2: 1.5,
      h2: 2,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
      label: 'Enter',
    );

    final legends = _scene([stepped]).where((face) => face.legend != null);
    expect(legends, hasLength(1));
    expect(legends.single.legend!.primary, 'Enter');
  });

  test('unlabeled keys paint no legend', () {
    expect(_scene([_key]).where((face) => face.legend != null), isEmpty);
  });

  test('orbiting changes the projected geometry', () {
    final rest = _scene([_key]);
    final turned = _scene([_key], yawDegrees: 45, pitchDegrees: 20);

    expect(_topFace(rest).points.first, isNot(_topFace(turned).points.first));
  });

  test('shading varies between side faces of one cap', () {
    final faces = _scene([_key], pitchDegrees: 25);
    final sideColors = {
      for (final face in faces)
        if (face.gradient == null && face.strokeColor == null) face.color,
    };

    expect(sideColors.length, greaterThan(1));
  });

  test('round keycaps render circular top faces', () {
    final style = _customStyle(
      const KeyboardCustomization(keycapShape: KeycapShape.round),
    );
    final faces = buildKeyboardScene(
      keys: const [_key],
      style: style,
      camera: _camera(const [_key]),
    );
    final top = faces.lastWhere((face) => face.gradient != null);

    // Four quarter-circles with the doubled segment count.
    expect(top.points, hasLength(24));
    final centerX =
        top.points.map((p) => p.dx).reduce((a, b) => a + b) / top.points.length;
    final centerY =
        top.points.map((p) => p.dy).reduce((a, b) => a + b) / top.points.length;
    final distances = [
      for (final point in top.points)
        (point - Offset(centerX, centerY)).distance,
    ];
    for (final distance in distances) {
      expect(distance, closeTo(distances.first, 1e-6));
    }
  });

  test('square keycaps keep sharper corners than rounded ones', () {
    final square = _customStyle(
      const KeyboardCustomization(keycapShape: KeycapShape.square),
    );
    final rounded = _customStyle(KeyboardCustomization.empty);
    final camera = _camera(const [_key]);

    final squareTop = buildKeyboardScene(
      keys: const [_key],
      style: square,
      camera: camera,
    ).lastWhere((face) => face.gradient != null);
    final roundedTop = buildKeyboardScene(
      keys: const [_key],
      style: rounded,
      camera: camera,
    ).lastWhere((face) => face.gradient != null);

    // The tapered top rectangle's corner, in board units — the point both
    // outlines cut away from, by their own radius.
    final corner = camera.project(Vec3(0.145, 0.145, keyTopZFor(square)));
    double cornerDistance(KeyboardFace face) => face.points
        .map((point) => (point - corner).distance)
        .reduce((a, b) => a < b ? a : b);

    expect(cornerDistance(squareTop), lessThan(cornerDistance(roundedTop)));
  });

  test('RGB lays down a glow before the board and tints the caps', () {
    final plain = buildKeyboardScene(
      keys: const [_key],
      style: _style,
      camera: _camera(const [_key]),
    );
    final rgb = buildKeyboardScene(
      keys: const [_key],
      style: _customStyle(
        const KeyboardCustomization(rgbEnabled: true, rgbColor: 0xFF00FF00),
      ),
      camera: _camera(const [_key]),
    );

    // The RGB scene adds the ambient halo as an extra gradient face.
    expect(
      rgb.where((face) => face.gradient != null).length,
      greaterThan(plain.where((face) => face.gradient != null).length),
    );
    final rgbTop = rgb.lastWhere((face) => face.gradient != null);
    final plainTop = plain.lastWhere((face) => face.gradient != null);
    expect(rgbTop.color, isNot(plainTop.color));
  });

  test('breathing RGB changes the cap tint across its phase', () {
    final style = _customStyle(
      const KeyboardCustomization(
        rgbEnabled: true,
        rgbEffect: RgbEffect.breathing,
        rgbColor: 0xFFFF5A36,
      ),
    );
    Color topColorAt(double phase) => buildKeyboardScene(
      keys: const [_key],
      style: style,
      camera: _camera(const [_key]),
      rgbPhase: phase,
    ).lastWhere((face) => face.gradient != null).color;

    // Phase 0 is the sine's trough, 0.25 its crest.
    expect(topColorAt(0), isNot(topColorAt(0.25)));
  });

  test('rainbow RGB tints keys by horizontal position', () {
    const left = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
    );
    const right = KeyboardKeySpec(
      x: 4,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 4,
      rotationY: 0,
    );
    final style = _customStyle(
      const KeyboardCustomization(
        rgbEnabled: true,
        rgbEffect: RgbEffect.rainbow,
        rgbColor: 0xFFFF5A36,
      ),
    );
    final faces = buildKeyboardScene(
      keys: const [left, right],
      style: style,
      camera: _camera(const [left, right]),
      rgbPhase: 0.3,
    );

    final topColors = [
      for (final face in faces)
        if (face.gradient != null && face.color.a > 0) face.color,
    ];
    // Two cap tops (the glow's color is fully transparent).
    expect(topColors, hasLength(2));
    expect(topColors.first, isNot(topColors.last));
  });

  test('a per-key light overrides the board-wide RGB color for its key', () {
    const left = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
    );
    const right = KeyboardKeySpec(
      x: 1,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 1,
      rotationY: 0,
    );
    final style = _customStyle(
      const KeyboardCustomization(rgbEnabled: true, rgbColor: 0xFF00FF00),
    );
    final faces = buildKeyboardScene(
      keys: const [left, right],
      style: style,
      camera: _camera(const [left, right]),
      keyLightColors: const [null, 0xFFFF0000],
    );

    final glows = [
      for (final face in faces)
        if (face.glowColor != null) face.glowColor!,
    ];
    expect(glows, hasLength(2));
    // The left key keeps the green global light; the right one is red.
    expect(glows.first.g, greaterThan(glows.first.r));
    expect(glows.last.r, greaterThan(glows.last.g));
  });

  test('the wave effect brightens keys as the band passes them', () {
    const left = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
    );
    const right = KeyboardKeySpec(
      x: 10,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 10,
      rotationY: 0,
    );
    final style = _customStyle(
      const KeyboardCustomization(
        rgbEnabled: true,
        rgbEffect: RgbEffect.wave,
        rgbColor: 0xFF00FF00,
      ),
    );

    /// Glow alphas of the two caps, ordered left→right on screen.
    List<double> glowAlphasByX(double phase) {
      final faces = buildKeyboardScene(
        keys: const [left, right],
        style: style,
        camera: _camera(const [left, right]),
        rgbPhase: phase,
      );
      final entries = [
        for (final face in faces)
          if (face.glowColor != null)
            (
              x:
                  face.points.map((p) => p.dx).reduce((a, b) => a + b) /
                  face.points.length,
              a: face.glowColor!.a,
            ),
      ]..sort((a, b) => a.x.compareTo(b.x));
      return [for (final entry in entries) entry.a];
    }

    // At phase 0 the band sits on the left; by 0.9 it has travelled right.
    final atZero = glowAlphasByX(0);
    expect(atZero, hasLength(2));
    expect(atZero.first, greaterThan(atZero.last));
    final atNinety = glowAlphasByX(0.9);
    expect(atNinety.last, greaterThan(atNinety.first));
  });

  test('a reactive pulse flashes a key brighter than its rest state', () {
    final style = _customStyle(
      const KeyboardCustomization(rgbEnabled: true, rgbColor: 0xFF00FF00),
    );
    Color topColor({double pulse = 0}) => buildKeyboardScene(
      keys: const [_key],
      style: style,
      camera: _camera(const [_key]),
      keyPulses: [pulse],
    ).lastWhere((face) => face.gradient != null).color;

    expect(topColor(pulse: 1), isNot(topColor()));
  });

  test('reactive mode keeps a held key lit above its dim base', () {
    final style = _customStyle(
      const KeyboardCustomization(
        rgbEnabled: true,
        rgbEffect: RgbEffect.reactive,
        rgbColor: 0xFF00FF00,
      ),
    );
    Color topColor({double held = 0}) => buildKeyboardScene(
      keys: const [_key],
      style: style,
      camera: _camera(const [_key]),
      keyPressLevels: [held],
    ).lastWhere((face) => face.gradient != null).color;

    expect(topColor(held: 1), isNot(topColor()));
  });

  test('a ripple spreads outward from its origin', () {
    const origin = KeyboardKeySpec(
      x: 0,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 0,
      rotationY: 0,
    );
    const far = KeyboardKeySpec(
      x: 3,
      y: 0,
      w: 1,
      h: 1,
      x2: 0,
      y2: 0,
      w2: 1,
      h2: 1,
      rotationAngle: 0,
      rotationX: 3,
      rotationY: 0,
    );
    final style = _customStyle(
      const KeyboardCustomization(
        rgbEnabled: true,
        rgbEffect: RgbEffect.ripple,
        rgbColor: 0xFFFF5A36,
      ),
    );
    // Glow alphas ordered left→right for a ripple of [age] seconds.
    List<double> glows(double age) {
      final faces = buildKeyboardScene(
        keys: const [origin, far],
        style: style,
        camera: _camera(const [origin, far]),
        rippleAges: [age, 0],
      );
      final entries = [
        for (final face in faces)
          if (face.glowColor != null)
            (
              x:
                  face.points.map((p) => p.dx).reduce((a, b) => a + b) /
                  face.points.length,
              a: face.glowColor!.a,
            ),
      ]..sort((a, b) => a.x.compareTo(b.x));
      return [for (final entry in entries) entry.a];
    }

    // Ring at the origin: the origin cap is lit, the far one isn't yet.
    final start = glows(0.02);
    expect(start, hasLength(2));
    expect(start.first, greaterThan(start.last));
    // Ring travelled ~3u (at 7 u/s): the far cap takes the light.
    final arrived = glows(3.0 / rippleSpeedUnitsPerSecond);
    expect(arrived.last, greaterThan(arrived.first));
  });

  test('color cycle shifts the board hue over time', () {
    final style = _customStyle(
      const KeyboardCustomization(
        rgbEnabled: true,
        rgbEffect: RgbEffect.colorCycle,
        rgbColor: 0xFF00FF00,
      ),
    );
    Color topAt(double phase) => buildKeyboardScene(
      keys: const [_key],
      style: style,
      camera: _camera(const [_key]),
      rgbPhase: phase,
    ).lastWhere((face) => face.gradient != null).color;

    expect(topAt(0), isNot(topAt(1 / 3)));
  });
}
