import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/practice/presentation/physical_key_id_mapper.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// The keyboard editor's pinned 3D preview: a three-quarter product-shot
/// of the board that updates live with every option, hosts its own
/// mouse-drag orbit, taps straight through to the per-key editor, and
/// opens the fullscreen inspector over the same (unsaved) state. Factored
/// out of `KeyboardCustomizeScreen` so the screen stays a form and this
/// stays the one place the preview's gesture state lives.
class KeyboardCustomizePreview extends ConsumerStatefulWidget {
  /// Creates the preview for the live editor state.
  const new({
    required this.model,
    required this.customization,
    required this.canRender,
    required this.emptyHint,
    required this.onKeyTap,
    required this.onExpand,
    super.key,
  });

  /// The profile's free-text model (may be `null`).
  final String? model;

  /// The live, unsaved customization.
  final KeyboardCustomization customization;

  /// Whether the board resolves to something paintable; when false the
  /// preview shows [emptyHint] instead.
  final bool canRender;

  /// Copy shown when [canRender] is false.
  final String emptyHint;

  /// Called with the merged key list's index + spec when a key is tapped.
  final void Function(int index, KeyboardKeySpec key) onKeyTap;

  /// Called when the expand button is pressed.
  final VoidCallback onExpand;

  /// Painted height of the board.
  static const previewHeight = 220.0;

  /// Resting pitch — a three-quarter product-shot angle instead of the
  /// hero card's straight-down default.
  static const _tiltDegrees = 20.0;

  /// Degrees of orbit rotation per logical pixel of drag travel.
  static const _dragDegreesPerPixel = 0.35;

  /// How far the pointer must travel before a tap becomes an orbit.
  static const _dragThreshold = 4.0;

  /// Orbit clamps for the preview.
  static const _maxYawDegrees = 70.0;
  static const _maxPitchDegrees = 40.0;

  @override
  ConsumerState<KeyboardCustomizePreview> createState() =>
      _KeyboardCustomizePreviewState();
}

class _KeyboardCustomizePreviewState
    extends ConsumerState<KeyboardCustomizePreview> {
  /// Drag-owned yaw/pitch, persisted between gestures.
  Offset _rotation = Offset.zero;

  Offset? _dragStart;
  Offset? _lastDragPosition;
  bool _dragging = false;

  /// Physical keys held on the real keyboard, by `PhysicalKeyId.name` —
  /// the preview doubles as a "try your own board" playground.
  final Set<String> _heldPhysicalKeys = {};

  /// Tracks real key down/up events; always returns `ignored` so typing
  /// only lights the board and never blocks shortcuts/text fields. Each
  /// real keystroke also plays the app's typing click, so the board feels
  /// like the real thing.
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final id = physicalKeyIdFor(event.physicalKey);
    if (id == null) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      if (_heldPhysicalKeys.add(id.name)) {
        unawaited(ref.read(keystrokeSoundPlayerProvider).playClick());
        setState(() {});
      }
    } else if (event is KeyUpEvent) {
      if (_heldPhysicalKeys.remove(id.name)) setState(() {});
    }
    return KeyEventResult.ignored;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    _dragStart = event.localPosition;
    _lastDragPosition = event.localPosition;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    final start = _dragStart;
    final last = _lastDragPosition;
    if (start == null || last == null) return;

    if (!_dragging) {
      if ((event.localPosition - start).distance <
          KeyboardCustomizePreview._dragThreshold) {
        return;
      }
      setState(() => _dragging = true);
      _lastDragPosition = event.localPosition;
      return;
    }

    final delta = event.localPosition - last;
    _lastDragPosition = event.localPosition;
    setState(() {
      _rotation = Offset(
        (_rotation.dx +
                delta.dx * KeyboardCustomizePreview._dragDegreesPerPixel)
            .clamp(
              -KeyboardCustomizePreview._maxYawDegrees,
              KeyboardCustomizePreview._maxYawDegrees,
            ),
        (_rotation.dy -
                delta.dy * KeyboardCustomizePreview._dragDegreesPerPixel)
            .clamp(
              -KeyboardCustomizePreview._maxPitchDegrees,
              KeyboardCustomizePreview._maxPitchDegrees,
            ),
      );
    });
  }

  void _onPointerEnd(PointerEvent event) {
    _dragStart = null;
    _lastDragPosition = null;
    if (_dragging) setState(() => _dragging = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shapes = AppShapes.of(context);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colorScheme.surfaceContainerLow,
        shape: shapes.largeShape,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              children: [
                if (widget.canRender)
                  Focus(
                    autofocus: true,
                    onKeyEvent: _onKeyEvent,
                    child: MouseRegion(
                      cursor: _dragging
                          ? SystemMouseCursors.grabbing
                          : SystemMouseCursors.grab,
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: _onPointerDown,
                        onPointerMove: _onPointerMove,
                        onPointerUp: _onPointerEnd,
                        onPointerCancel: _onPointerEnd,
                        child: KeyboardVisual(
                          model: widget.model,
                          customization: widget.customization,
                          height: KeyboardCustomizePreview.previewHeight,
                          tiltDegrees: KeyboardCustomizePreview._tiltDegrees,
                          rotation: _rotation,
                          interactiveSuspended: _dragging,
                          pressedPhysicalKeys: _heldPhysicalKeys,
                          onKeyTap: widget.onKeyTap,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: KeyboardCustomizePreview.previewHeight,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          widget.emptyHint,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  l10n.keyboardCustomizePreviewHint,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: widget.onExpand,
              tooltip: l10n.profileKeyboardViewFullscreenAction,
              iconSize: 18,
              icon: const Icon(LucideIcons.maximize2),
            ),
          ),
        ],
      ),
    );
  }
}
