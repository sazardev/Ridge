import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/profile_labels.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_customization_geometry.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_geometry_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_key_effects.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_3d.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/standard_family_key_specs.dart';

/// Resolves [model] to the key geometry [KeyboardVisual] would paint for
/// it — a curated real layout, the generic family silhouette, or `null` if
/// neither exists — factored out so a caller that wraps [KeyboardVisual]
/// in its own decoration (e.g. a hero card) can decide up front whether
/// anything will actually render, without duplicating the lookup order.
///
/// Total freedom over the geometry: an explicit [customization]
/// `shapeFamily` always wins, even over a curated model's real layout
/// (including `KeyboardShapeFamily.custom`, the blank canvas the user
/// builds from extra keys). Only with no explicit family does the curated
/// layout — or, failing that, the model's suggested family — apply.
List<KeyboardKeySpec>? resolveKeyboardKeySpecs(
  WidgetRef ref,
  String? model, [
  KeyboardCustomization customization = KeyboardCustomization.empty,
]) {
  final family = customization.shapeFamily;
  if (family != null) return standardFamilyKeySpecsFor(family);
  final curated = model == null
      ? null
      : ref.watch(keyboardVisualLayoutsProvider).value?[model];
  final suggested = keyboardShapeFamilyFor(model);
  return curated?.keys ??
      (suggested != null ? standardFamilyKeySpecsFor(suggested) : null);
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
    this.customization = KeyboardCustomization.empty,
    this.height = 88,
    this.tiltDegrees = 0,
    this.pointerTilt = Offset.zero,
    this.pointerTiltDegrees = 0,
    this.rotation = Offset.zero,
    this.interactive = true,
    this.interactiveSuspended = false,
    this.pressedPhysicalKeys = const <String>{},
    this.onKeyTap,
    super.key,
  });

  /// The profile's free-text `keyboardModel`.
  final String? model;

  /// The profile's persisted keyboard personalization — keycap shape,
  /// custom colors, RGB and the per-key overrides/extra keys merged into
  /// the resolved geometry.
  final KeyboardCustomization customization;

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

  /// Physical keys currently held down on the *real* keyboard, by
  /// `PhysicalKeyId.name` (e.g. `"keyA"`). Each one sinks its matching cap
  /// and (with RGB on) pulses it — the viewer/editor's "type on your own
  /// board" reaction. Position-based on purpose: a functional remap
  /// changes what the key types, never which cap is under the finger.
  final Set<String> pressedPhysicalKeys;

  /// Called when the pointer is released over the key it pressed, with the
  /// key's index in the painted (customization-merged) list and its spec —
  /// the keyboard editor opens its per-key sheet from here. Not called for
  /// presses cancelled by a drag/orbit.
  final void Function(int index, KeyboardKeySpec key)? onKeyTap;

  @override
  ConsumerState<KeyboardVisual> createState() => _KeyboardVisualState();
}

class _KeyboardVisualState extends ConsumerState<KeyboardVisual>
    with TickerProviderStateMixin {
  int? _hoveredIndex;
  int? _pressedIndex;

  /// The spec of the currently pressed key, so a pointer-up can notify
  /// [KeyboardVisual.onKeyTap] with it after the key list has been
  /// released.
  KeyboardKeySpec? _pressedKeySpec;

  /// Real-keyboard press levels + reactive flashes, advanced by their own
  /// self-stopping ticker.
  late final KeyboardKeyEffects _effects = KeyboardKeyEffects(
    vsync: this,
    onFrame: () {
      if (mounted) setState(() {});
    },
  );

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

  /// Drives breathing/rainbow lighting; only alive while [KeyboardVisual]
  /// is asked to render an animated RGB effect, so a static board (the
  /// common case) never schedules a ticker.
  AnimationController? _rgbController;

  late Listenable _repaint = _makeRepaint();

  Listenable _makeRepaint() {
    final rgb = _rgbController;
    return Listenable.merge([_pressController, _tiltController, ?rgb]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Idempotent, so it also re-runs when reduced motion / performance
    // mode flips.
    _syncRgbAnimation();
  }

  /// Starts, stops or re-times the RGB ticker to match the current
  /// customization — a no-op for every state it's already in.
  void _syncRgbAnimation() {
    final animated =
        !MediaQuery.disableAnimationsOf(context) &&
        widget.customization.rgbEnabled &&
        widget.customization.rgbEffect != RgbEffect.static;
    if (!animated) {
      if (_rgbController != null) {
        _rgbController!.dispose();
        _rgbController = null;
        _repaint = _makeRepaint();
      }
      return;
    }
    final period = widget.customization.rgbEffect == RgbEffect.rainbow
        ? const Duration(seconds: 8)
        : const Duration(seconds: 4);
    final controller = _rgbController;
    if (controller == null) {
      _rgbController = AnimationController(vsync: this, duration: period)
        ..repeat();
      _repaint = _makeRepaint();
    } else if (controller.duration != period) {
      controller
        ..duration = period
        ..repeat();
    }
  }

  @override
  void didUpdateWidget(KeyboardVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interactiveSuspended && !oldWidget.interactiveSuspended) {
      _release();
    }
    if (widget.customization != oldWidget.customization ||
        widget.model != oldWidget.model) {
      // The painted keys are about to change shape/order; stale index
      // levels would light the wrong caps. Held physical keys re-sync from
      // the new base layout on the next build.
      _effects.reset();
    }
    if (widget.customization != oldWidget.customization) {
      _syncRgbAnimation();
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
    _rgbController?.dispose();
    _effects.dispose();
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

  /// Per-key light colors aligned with the merged keys list: base keys
  /// look up their position id, extra keys their customization id. `null`
  /// when there's nothing per-key to show (no RGB, or no key lights).
  List<int?>? _keyLightColors(List<KeyboardKeySpec> baseKeys, int length) {
    final customization = widget.customization;
    final lights = customization.keyLights;
    if (!customization.rgbEnabled || lights.isEmpty) return null;
    final byId = {for (final light in lights) light.keyId: light.color};
    final extras = customization.extraKeys;
    return [
      for (var i = 0; i < length; i++)
        if (i < baseKeys.length)
          byId[keyboardKeyIdFor(baseKeys[i])]
        else if (i - baseKeys.length < extras.length)
          byId[extras[i - baseKeys.length].id]
        else
          null,
    ];
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
    setState(() {
      _pressedIndex = index;
      _pressedKeySpec = keys[index];
    });
    _effects.pulse(index);
    _pressController.forward();
  }

  void _release({bool notifyTap = false}) {
    final index = _pressedIndex;
    if (index == null) return;
    final key = _pressedKeySpec;
    if (notifyTap && key != null) widget.onKeyTap?.call(index, key);
    setState(() {
      _pressedIndex = null;
      _pressedKeySpec = null;
    });
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final resolved = resolveKeyboardKeySpecs(
      ref,
      widget.model,
      widget.customization,
    );
    if (resolved == null) return const SizedBox.shrink();
    final keys = applyKeyboardCustomization(
      baseKeys: resolved,
      customization: widget.customization,
    );
    if (keys.isEmpty) return const SizedBox.shrink();
    _effects.syncExternal(widget.pressedPhysicalKeys, resolved);

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final shapes = AppShapes.of(context);
    final style = KeyboardKeycapStyle.fromScheme(
      colorScheme,
      keyCornerRadius: shapes.extraSmall,
      caseCornerRadius: shapes.medium,
      customization: widget.customization,
    );
    final semanticModel = (widget.model?.isNotEmpty ?? false)
        ? widget.model!
        : widget.customization.shapeFamily?.label(l10n) ?? '';

    return Semantics(
      label: l10n.profileKeyboardShapePreviewSemanticLabel(semanticModel),
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
                onPointerUp: widget.interactive
                    ? (_) => _release(notifyTap: true)
                    : null,
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
                        rgbPhase: _rgbController?.value ?? 0,
                        keyLightColors: _keyLightColors(resolved, keys.length),
                        keyPressLevels: _effects.levels(keys.length),
                        keyPulses: _effects.pulses(keys.length),
                        rippleAges: _effects.ripples(keys.length),
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
