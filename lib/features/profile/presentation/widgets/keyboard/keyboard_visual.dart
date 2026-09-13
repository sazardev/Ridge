import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/standard_family_key_specs.dart';

/// Resolves [model] to the key geometry [KeyboardVisual] would paint for
/// it — a curated real layout, the generic family silhouette, or `null` if
/// neither exists — factored out so a caller that wraps [KeyboardVisual]
/// in its own decoration (e.g. a hero card) can decide up front whether
/// anything will actually render, without duplicating the lookup order.
List<KeyboardKeySpec>? resolveKeyboardKeySpecs(WidgetRef ref, String model) {
  final curated = ref.watch(keyboardVisualLayoutsProvider).value?[model];
  final family = keyboardShapeFamilyFor(model);
  return curated?.keys ??
      (family != null ? standardFamilyKeySpecsFor(family) : null);
}

/// A real-3D keyboard visual for a profile's free-text `keyboardModel` —
/// the single integration point deciding *what* to draw, so callers (the
/// hero card, the edit screen's live preview, the fullscreen viewer) never
/// need to know about curated layouts or family fallbacks:
/// 1. A curated, real layout from the data bank
///    (`assets/content/keyboard_layouts/`), when [model] has one.
/// 2. Otherwise, `keyboard_shape_lookup.dart`'s generic family
///    silhouette, when [model] is a recognized `kKeyboardModelSuggestions`
///    entry.
/// 3. Otherwise nothing — an unrecognized free-text model has no shape
///    to guess at.
///
/// The board is genuine 3D geometry (case, plate, tapered keycaps) drawn
/// through a perspective camera: [tiltDegrees] is the resting pitch,
/// [pointerTilt]/[pointerTiltDegrees] add a slow parallax orbit that
/// follows a pointer tracked by the caller (the profile hero feeds the
/// whole card's pointer position through it), and [rotation] adds
/// caller-owned yaw/pitch degrees on top — the hero uses it for
/// drag-to-orbit, which must not animate, so it is applied directly.
/// When [interactive] (the default), each key responds to the pointer the
/// way a VIA-style configurator would: hover tints it, pressing sinks it
/// along its real z axis, using the same [KeyboardCamera] the painter
/// projects with, so pointer hit-testing stays exact at every angle.
class KeyboardVisual extends ConsumerStatefulWidget {
  /// Creates the visual for [model] (a profile's free-text
  /// `keyboardModel`, or `null`/empty if unset), painted at [height].
  const new({
    required this.model,
    this.height = 88,
    this.tiltDegrees = 0,
    this.pointerTilt = Offset.zero,
    this.pointerTiltDegrees = 0,
    this.rotation = Offset.zero,
    this.interactive = true,
    this.interactiveSuspended = false,
    super.key,
  });

  /// The profile's free-text `keyboardModel`.
  final String? model;

  /// The painted height, in logical pixels. Every proportion (bezel, key
  /// gap, depth, ...) is derived from the fitted key-unit scale, so this
  /// can be tuned per call site (a compact inline preview vs. a larger
  /// hero visual) without retuning the geometry.
  final double height;

  /// Resting pitch of the camera, in degrees (0 = top-down, the centered
  /// default).
  final double tiltDegrees;

  /// Normalized pointer position (-1..1 on each axis, origin at the
  /// board's centre) blended into [tiltDegrees] as a parallax orbit —
  /// callers track the pointer over a larger area (e.g. the whole hero
  /// card) and pass it down. The visual animates slowly toward new values
  /// implicitly, so callers can just hand over raw pointer positions.
  final Offset pointerTilt;

  /// How many degrees [pointerTilt] can add per axis (0 disables the
  /// parallax entirely and leaves only [tiltDegrees]).
  final double pointerTiltDegrees;

  /// Extra yaw/pitch rotation in degrees (dx = yaw around the vertical
  /// axis, dy = pitch around the horizontal one), applied on top of the
  /// tilt and parallax without animation — callers drive it 1:1 while the
  /// user drags, and it persists when they let go.
  final Offset rotation;

  /// Whether pointer hover/press feedback is wired up. Turning it off
  /// leaves the exact same painted result at rest.
  final bool interactive;

  /// Suppresses the press feedback while true — the hero sets it during a
  /// drag so holding a key doesn't look stuck while the board orbits.
  final bool interactiveSuspended;

  @override
  ConsumerState<KeyboardVisual> createState() => _KeyboardVisualState();
}

class _KeyboardVisualState extends ConsumerState<KeyboardVisual>
    with TickerProviderStateMixin {
  int? _hoveredIndex;
  int? _pressedIndex;

  late final AnimationController _pressController = AnimationController(
    vsync: this,
    duration: AppMotion.effectsFast,
    reverseDuration: AppMotion.spatialFast,
  );
  late final Animation<double> _pressProgress = CurvedAnimation(
    parent: _pressController,
    curve: AppMotion.effects,
    reverseCurve: AppMotion.spatial,
  );

  /// Owns the pointer parallax so the *displayed* orbit is available to
  /// both the painter and pointer hit-testing — the old 2D board leaned
  /// on the compositor inverting its widget transform for that, which a
  /// software camera has to do itself.
  late final AnimationController _tiltController = AnimationController(
    vsync: this,
    duration: AppMotion.spatialDefault,
  );
  Animation<Offset> _displayTilt = const AlwaysStoppedAnimation(Offset.zero);

  late final Listenable _repaint = Listenable.merge([
    _pressController,
    _tiltController,
  ]);

  @override
  void didUpdateWidget(KeyboardVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interactiveSuspended && !oldWidget.interactiveSuspended) {
      _release();
    }
    if (widget.pointerTilt != _displayTilt.value) {
      _displayTilt =
          Tween<Offset>(
            begin: _displayTilt.value,
            end: widget.pointerTilt,
          ).animate(
            CurvedAnimation(parent: _tiltController, curve: AppMotion.spatial),
          );
      _tiltController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  /// The live camera orbit: resting tilt, animated pointer parallax
  /// (clamped to the normalized -1..1 range) and the caller's drag
  /// rotation, combined exactly like the old matrix used to combine them.
  ({double yaw, double pitch}) _angles() {
    final tilt = widget.pointerTiltDegrees == 0
        ? Offset.zero
        : _displayTilt.value;
    final dx = tilt.dx.clamp(-1.0, 1.0);
    final dy = tilt.dy.clamp(-1.0, 1.0);
    return (
      yaw: dx * widget.pointerTiltDegrees + widget.rotation.dx,
      pitch:
          widget.tiltDegrees -
          dy * widget.pointerTiltDegrees +
          widget.rotation.dy,
    );
  }

  KeyboardCamera? _camera(
    List<KeyboardKeySpec> keys,
    KeyboardKeycapStyle style,
  ) {
    final size = context.size;
    if (size == null || size.isEmpty) return null;
    final angles = _angles();
    return KeyboardCamera.fit(
      keys: keys,
      size: size,
      depthFraction: style.caseDepthFraction,
      topFraction: keyTopZFor(style),
      yawDegrees: angles.yaw,
      pitchDegrees: angles.pitch,
    );
  }

  int? _keyIndexAt(
    List<KeyboardKeySpec> keys,
    KeyboardKeycapStyle style,
    Offset position,
  ) {
    final camera = _camera(keys, style);
    if (camera == null) return null;
    final point = camera.unprojectToPlane(position, keyTopZFor(style));
    return camera.keyIndexAtBoardPoint(Offset(point.x, point.y));
  }

  void _updateHover(
    List<KeyboardKeySpec> keys,
    KeyboardKeycapStyle style,
    Offset position,
  ) {
    final index = _keyIndexAt(keys, style, position);
    if (index != _hoveredIndex) setState(() => _hoveredIndex = index);
  }

  void _clearHover() {
    if (_hoveredIndex != null) setState(() => _hoveredIndex = null);
  }

  void _press(
    List<KeyboardKeySpec> keys,
    KeyboardKeycapStyle style,
    Offset position,
  ) {
    if (widget.interactiveSuspended) return;
    final index = _keyIndexAt(keys, style, position);
    if (index == null) return;
    setState(() => _pressedIndex = index);
    _pressController.forward();
  }

  void _release() {
    if (_pressedIndex == null) return;
    setState(() => _pressedIndex = null);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    if (model == null || model.isEmpty) return const SizedBox.shrink();

    final keys = resolveKeyboardKeySpecs(ref, model);
    if (keys == null || keys.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final shapes = AppShapes.of(context);
    final style = KeyboardKeycapStyle.fromScheme(
      colorScheme,
      keyCornerRadius: shapes.extraSmall,
      caseCornerRadius: shapes.medium,
    );

    return Semantics(
      label: l10n.profileKeyboardShapePreviewSemanticLabel(model),
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, widget.height);
            return MouseRegion(
              onHover: widget.interactive
                  ? (event) => _updateHover(keys, style, event.localPosition)
                  : null,
              onExit: widget.interactive ? (_) => _clearHover() : null,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: widget.interactive
                    ? (event) => _press(keys, style, event.localPosition)
                    : null,
                onPointerUp: widget.interactive ? (_) => _release() : null,
                onPointerCancel: widget.interactive ? (_) => _release() : null,
                child: AnimatedBuilder(
                  animation: _repaint,
                  builder: (context, _) {
                    final angles = _angles();
                    return CustomPaint(
                      size: size,
                      painter: KeyboardLayoutPainter(
                        keys: keys,
                        style: style,
                        yawDegrees: angles.yaw,
                        pitchDegrees: angles.pitch,
                        hoveredIndex: _hoveredIndex,
                        pressedIndex: _pressedIndex,
                        pressProgress: _pressProgress.value,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
