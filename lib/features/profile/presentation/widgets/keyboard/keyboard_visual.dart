import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/providers/keyboard_visual_layout_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_geometry.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_layout_painter.dart';
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

/// A pseudo-3D keyboard visual for a profile's free-text `keyboardModel` —
/// the single integration point deciding *what* to draw, so callers (the
/// hero card, the edit screen's live preview) never need to know about
/// curated layouts or family fallbacks:
/// 1. A curated, real layout from the data bank
///    (`assets/content/keyboard_layouts/`), when [model] has one.
/// 2. Otherwise, `keyboard_shape_lookup.dart`'s generic family
///    silhouette, when [model] is a recognized `kKeyboardModelSuggestions`
///    entry.
/// 3. Otherwise nothing — an unrecognized free-text model has no shape
///    to guess at.
///
/// When [interactive] (the default), each key responds to the pointer the
/// way a VIA-style configurator would: hover tints it, pressing sinks it,
/// using the same [KeyboardLayoutTransform] the painter draws with.
/// [tiltDegrees] applies a light product-shot perspective to the whole
/// board, [pointerTilt]/[pointerTiltDegrees] add a slow parallax rotation
/// that follows a pointer tracked by the caller (the profile hero feeds
/// the whole card's pointer position through it), and [rotation] adds
/// caller-owned yaw/pitch degrees on top — the hero uses it for
/// drag-to-orbit, which must not animate, so it is applied directly.
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
  /// hero visual) without retuning the painter.
  final double height;

  /// Light isometric tilt of the whole board, in degrees (0 = top-down,
  /// the centered default).
  final double tiltDegrees;

  /// Normalized pointer position (-1..1 on each axis, origin at the
  /// board's centre) blended into [tiltDegrees] as a parallax rotation —
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
    with SingleTickerProviderStateMixin {
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

  @override
  void didUpdateWidget(KeyboardVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interactiveSuspended && !oldWidget.interactiveSuspended) {
      _release();
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _updateHover(KeyboardLayoutTransform transform, Offset position) {
    final index = transform.keyIndexAt(position);
    if (index != _hoveredIndex) setState(() => _hoveredIndex = index);
  }

  void _clearHover() {
    if (_hoveredIndex != null) setState(() => _hoveredIndex = null);
  }

  void _press(KeyboardLayoutTransform transform, Offset position) {
    if (widget.interactiveSuspended) return;
    final index = transform.keyIndexAt(position);
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
            final transform = KeyboardLayoutTransform.fit(
              keys: keys,
              size: size,
              depthFraction: style.caseDepthFraction,
            );
            final board = MouseRegion(
              onHover: widget.interactive
                  ? (event) => _updateHover(transform, event.localPosition)
                  : null,
              onExit: widget.interactive ? (_) => _clearHover() : null,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: widget.interactive
                    ? (event) => _press(transform, event.localPosition)
                    : null,
                onPointerUp: widget.interactive ? (_) => _release() : null,
                onPointerCancel: widget.interactive ? (_) => _release() : null,
                child: ListenableBuilder(
                  listenable: _pressController,
                  builder: (context, _) => CustomPaint(
                    size: size,
                    painter: KeyboardLayoutPainter(
                      keys: keys,
                      style: style,
                      hoveredIndex: _hoveredIndex,
                      pressedIndex: _pressedIndex,
                      pressProgress: _pressProgress.value,
                    ),
                  ),
                ),
              ),
            );

            if (widget.tiltDegrees == 0 &&
                widget.pointerTiltDegrees == 0 &&
                widget.rotation == Offset.zero) {
              return board;
            }
            // A perspective transform *outside* the pointer regions:
            // Flutter inverts it for hit-testing automatically, so the
            // mouse math keeps operating in the painter's flat space.
            // `TweenAnimationBuilder` smooths the parallax slowly — every
            // new pointer sample animates from the currently rendered
            // tilt instead of snapping to it.
            return TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(begin: Offset.zero, end: widget.pointerTilt),
              duration: AppMotion.spatialDefault,
              curve: AppMotion.spatial,
              builder: (context, pointerTilt, child) => Transform(
                alignment: Alignment.center,
                transform: _tiltMatrix(
                  baseDegrees: widget.tiltDegrees,
                  pointer: pointerTilt,
                  pointerDegrees: widget.pointerTiltDegrees,
                  rotation: widget.rotation,
                ),
                child: child,
              ),
              child: board,
            );
          },
        ),
      ),
    );
  }

  /// The board's orientation: a [baseDegrees] backward lean, up to
  /// [pointerDegrees] per axis of parallax from the normalized [pointer]
  /// position, and the caller-owned drag [rotation] (degrees) on top.
  /// Moving the pointer up or right turns the board slightly to "look at"
  /// it.
  ///
  /// The perspective strength is deliberately angle-dependent: full
  /// strength for the shallow product-shot tilt, easing off as the board
  /// turns, because a fixed perspective factor makes the near edge blow
  /// up once drag-to-orbit reaches large angles (it scales with the
  /// rotated z depth, so 40°+ would project the case clean out of its
  /// card). The weakening keeps the projected size bounded at every
  /// angle while preserving the trapezoid where it matters.
  static Matrix4 _tiltMatrix({
    required double baseDegrees,
    required Offset pointer,
    required double pointerDegrees,
    required Offset rotation,
  }) {
    const basePerspective = 0.006;
    const kneeDegrees = 8.0;
    const toRadians = math.pi / 180;
    final dx = pointer.dx.clamp(-1.0, 1.0);
    final dy = pointer.dy.clamp(-1.0, 1.0);
    final pitch = baseDegrees - dy * pointerDegrees + rotation.dy;
    final yaw = dx * pointerDegrees + rotation.dx;
    final magnitude = math.sqrt(pitch * pitch + yaw * yaw);
    final perspective = magnitude <= kneeDegrees
        ? basePerspective
        : basePerspective * kneeDegrees / magnitude;
    return Matrix4.identity()
      ..setEntry(3, 2, perspective)
      ..rotateX(pitch * toRadians)
      ..rotateY(yaw * toRadians);
  }
}
