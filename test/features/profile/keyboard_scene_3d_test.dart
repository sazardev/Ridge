// Unit tests for the 3D scene builder: real faces out of key specs, with
// hover/press affecting the rendered result (color and z sink), and the
// stepped-key extension adding geometry.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_3d.dart';

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

final _style = KeyboardKeycapStyle.fromScheme(
  ColorScheme.fromSeed(seedColor: Colors.blue),
  keyCornerRadius: 8,
  caseCornerRadius: 12,
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
}
