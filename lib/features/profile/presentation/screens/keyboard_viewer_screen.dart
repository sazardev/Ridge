import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/escape_to_pop.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// The fullscreen keyboard inspector reached from Profile's keyboard hero
/// card (`ProfileKeyboardHeroCard`'s expand action, `/profile/keyboard`) —
/// the same `KeyboardVisual` at full screen size, with the manipulation
/// scaled up to match: drag orbits the board, wheel/pinch zoom in on the
/// keycaps, and clicking a key sinks it like a VIA configurator.
///
/// Pushed as a non-shell route (same shape as `/profile/edit`), so the
/// nav rail/bottom bar disappears and the board owns the screen; the
/// `AppBar` keeps the model caption and the platform back affordance,
/// and `EscapeToPop` gives desktop users the usual Escape-to-close.
class KeyboardViewerScreen extends StatefulWidget {
  /// Creates the viewer for [profile]'s keyboard model.
  const new({required this.profile, super.key});

  /// The profile whose keyboard is inspected. Only the brand and model
  /// are read; the caller hands the whole profile over for the same
  /// reason `/profile/edit` does — it already has it in hand.
  final GuestProfile profile;

  @override
  State<KeyboardViewerScreen> createState() => _KeyboardViewerScreenState();
}

class _KeyboardViewerScreenState extends State<KeyboardViewerScreen> {
  /// Degrees of orbit rotation per logical pixel of drag travel — the
  /// same feel as the hero card, so the small preview and the fullscreen
  /// inspector never disagree.
  static const _dragDegreesPerPixel = 0.35;

  /// How far a single pointer must travel before a press becomes an
  /// orbit. The scale recognizer wins its arena the moment it's alone
  /// (which it is here), so `onScaleStart` fires on press-down already —
  /// this threshold is what keeps a plain click a key press.
  static const _dragThreshold = 4.0;

  /// Orbit clamps, deliberately looser than the hero card's: inspecting
  /// the board from steeper angles is the reason this screen exists.
  static const _maxYawDegrees = 75.0;
  static const _maxPitchDegrees = 45.0;

  /// Zoom range, relative to the board fitted edge-to-edge. Below 1 pulls
  /// back for the whole silhouette; above 1 closes in on the keycaps.
  static const _minZoom = 0.5;
  static const _maxZoom = 3.0;

  /// How much one tap on the zoom buttons moves.
  static const _zoomStep = 1.25;

  /// Drag-owned yaw/pitch in degrees (dx = yaw, dy = pitch), persisted
  /// between gestures.
  Offset _rotation = Offset.zero;

  /// Current zoom, where 1 fits the board edge-to-edge.
  double _zoom = 1;

  /// Zoom when the current scale gesture started — `ScaleUpdateDetails
  /// .scale` is cumulative since the gesture (or its last pointer-count
  /// change) began, not since the last event, so a pinch has to multiply
  /// from that baseline.
  double _zoomAtScaleStart = 1;

  /// Where the current single-pointer gesture began, for [_dragThreshold].
  /// A second finger landing re-fires `onScaleStart`, re-baselining both
  /// this and the zoom above.
  Offset? _gestureOrigin;

  /// Whether the board is being orbited/pinched, which yields the press
  /// feedback so a held key doesn't look stuck while the board moves.
  bool _dragging = false;

  void _onScaleStart(ScaleStartDetails details) {
    _zoomAtScaleStart = _zoom;
    _gestureOrigin = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount > 1) {
      if (!_dragging) setState(() => _dragging = true);
      _setZoom(_zoomAtScaleStart * details.scale);
      return;
    }
    final origin = _gestureOrigin;
    if (origin == null) return;
    if (!_dragging &&
        (details.localFocalPoint - origin).distance < _dragThreshold) {
      return;
    }
    final delta = details.focalPointDelta;
    setState(() {
      _dragging = true;
      _rotation = Offset(
        (_rotation.dx + delta.dx * _dragDegreesPerPixel).clamp(
          -_maxYawDegrees,
          _maxYawDegrees,
        ),
        (_rotation.dy - delta.dy * _dragDegreesPerPixel).clamp(
          -_maxPitchDegrees,
          _maxPitchDegrees,
        ),
      );
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _gestureOrigin = null;
    if (_dragging) setState(() => _dragging = false);
  }

  void _setZoom(double zoom) {
    final next = zoom.clamp(_minZoom, _maxZoom);
    if (next == _zoom) return;
    setState(() => _zoom = next);
  }

  void _resetView() {
    setState(() {
      _rotation = Offset.zero;
      _zoom = 1;
    });
  }

  /// Wheel zoom on desktop, plus trackpad pinch on platforms that report
  /// it as a pointer signal. A wheel notch moves by ~100 units and
  /// scrolling up is negative, so `exp` turns every notch into the same
  /// multiplicative step in the right direction.
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      _setZoom(_zoom * math.exp(-event.scrollDelta.dy / 500));
    } else if (event is PointerScaleEvent) {
      _setZoom(_zoom * event.scale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.profile.keyboardModel;
    if (model == null || model.isEmpty) return const SizedBox.shrink();

    final brand = widget.profile.keyboardBrand;
    final caption = (brand?.isNotEmpty ?? false) ? '$brand $model' : model;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shapes = AppShapes.of(context);

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(title: Text(caption)),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                // The board can paint past the viewport once zoomed in;
                // clipping keeps it from spilling over the controls.
                child: ClipRect(
                  child: Listener(
                    onPointerSignal: _onPointerSignal,
                    child: MouseRegion(
                      cursor: _dragging
                          ? SystemMouseCursors.grabbing
                          : SystemMouseCursors.grab,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: _onScaleUpdate,
                        onScaleEnd: _onScaleEnd,
                        child: LayoutBuilder(
                          builder: (context, constraints) => Transform.scale(
                            scale: _zoom,
                            child: KeyboardVisual(
                              model: model,
                              height: constraints.maxHeight,
                              rotation: _rotation,
                              interactiveSuspended: _dragging,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  shape: shapes.fullShape,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _zoom > _minZoom
                            ? () => _setZoom(_zoom / _zoomStep)
                            : null,
                        tooltip: l10n.profileKeyboardZoomOutTooltip,
                        icon: const Icon(LucideIcons.zoomOut),
                      ),
                      IconButton(
                        onPressed: _zoom != 1 || _rotation != Offset.zero
                            ? _resetView
                            : null,
                        tooltip: l10n.profileKeyboardResetViewTooltip,
                        icon: const Icon(LucideIcons.rotateCcw),
                      ),
                      IconButton(
                        onPressed: _zoom < _maxZoom
                            ? () => _setZoom(_zoom * _zoomStep)
                            : null,
                        tooltip: l10n.profileKeyboardZoomInTooltip,
                        icon: const Icon(LucideIcons.zoomIn),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.profileKeyboardViewerHint,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
