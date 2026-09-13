import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';

/// The profile screen's keyboard hero: a large rendering of the active
/// profile's `keyboardModel`, shown right under the identity header
/// instead of buried inside `ProfileAboutCard` — this app is for people
/// who care about their keyboard, so it earns first-screen visibility
/// rather than living below the stats/achievements cards.
///
/// The board rests centered (top-down) and the whole card is a pointer
/// surface:
/// - Moving the mouse slowly feeds a normalized position into
///   `KeyboardVisual`'s parallax tilt, so the board gently turns to follow
///   the cursor; leaving the card returns it to centered.
/// - Dragging with the mouse orbits it like a product viewer — horizontal
///   drag yaws, vertical drag pitches — and the angle persists after the
///   drag. The first few pixels are a threshold so a plain click still
///   presses keys, and once a drag starts the press feedback is released.
/// - Touch devices just scroll as usual: hover and drag are mouse-only.
///
/// The expand button in the card's top-right corner pushes the fullscreen
/// keyboard inspector (`/profile/keyboard`), where the same board has room
/// to orbit and zoom properly; clicking the board itself stays a key
/// press, here as in the inspector.
///
/// Renders nothing if [GuestProfile.keyboardModel] is unset, or is free
/// text `KeyboardVisual` can't match to a curated layout or generic
/// family — same "nothing to guess at" contract as `KeyboardVisual`
/// itself, so this never shows an empty decorated box.
class ProfileKeyboardHeroCard extends ConsumerStatefulWidget {
  /// Creates the hero for [profile]'s keyboard.
  const new({required this.profile, super.key});

  /// The profile whose keyboard this renders.
  final GuestProfile profile;

  /// The visual's painted height — noticeably larger than the `88`
  /// logical-pixel preview used inline elsewhere, since this is meant to
  /// read as the screen's visual centerpiece.
  static const _visualHeight = 176.0;

  /// How many degrees the hover parallax can add per axis when moving
  /// around the card.
  static const _pointerTiltDegrees = 6.0;

  @override
  ConsumerState<ProfileKeyboardHeroCard> createState() =>
      _ProfileKeyboardHeroCardState();
}

class _ProfileKeyboardHeroCardState
    extends ConsumerState<ProfileKeyboardHeroCard> {
  /// Degrees of drag rotation per logical pixel of pointer travel.
  static const _dragDegreesPerPixel = 0.35;

  /// How far the pointer must travel before a click becomes a drag.
  static const _dragThreshold = 4.0;

  /// Orbit clamps — far enough to inspect the board from an angle, tight
  /// enough that it never turns edge-on or upside down.
  static const _maxDragYawDegrees = 60.0;
  static const _maxDragPitchDegrees = 30.0;

  final GlobalKey _cardKey = GlobalKey();

  /// Pointer position normalized to -1..1 on each axis, origin at the
  /// card's centre; `Offset.zero` whenever the pointer is away.
  Offset _pointer = Offset.zero;

  /// Drag-owned yaw/pitch (degrees), persisted after the pointer is
  /// released so the user keeps the angle they set.
  Offset _rotation = Offset.zero;

  Offset? _dragStart;
  Offset? _lastDragPosition;
  bool _dragging = false;

  @override
  void didUpdateWidget(ProfileKeyboardHeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile.keyboardModel != oldWidget.profile.keyboardModel) {
      _rotation = Offset.zero;
      _pointer = Offset.zero;
    }
  }

  void _trackPointer(Offset globalPosition) {
    if (_dragging) return;
    final box = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final local = box.globalToLocal(globalPosition);
    final size = box.size;
    if (size.isEmpty) return;
    final next = Offset(
      ((local.dx / size.width) * 2 - 1).clamp(-1.0, 1.0),
      ((local.dy / size.height) * 2 - 1).clamp(-1.0, 1.0),
    );
    if (next != _pointer) setState(() => _pointer = next);
  }

  void _resetPointer() {
    if (_pointer != Offset.zero) setState(() => _pointer = Offset.zero);
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
      if ((event.localPosition - start).distance < _dragThreshold) return;
      // Past the threshold this is an orbit, not a click: yield the
      // parallax so the drag has 1:1 control, and swallow the travel
      // that got us here.
      setState(() {
        _dragging = true;
        _pointer = Offset.zero;
      });
      _lastDragPosition = event.localPosition;
      return;
    }

    final delta = event.localPosition - last;
    _lastDragPosition = event.localPosition;
    setState(() {
      _rotation = Offset(
        (_rotation.dx + delta.dx * _dragDegreesPerPixel).clamp(
          -_maxDragYawDegrees,
          _maxDragYawDegrees,
        ),
        (_rotation.dy - delta.dy * _dragDegreesPerPixel).clamp(
          -_maxDragPitchDegrees,
          _maxDragPitchDegrees,
        ),
      );
    });
  }

  void _onPointerEnd(PointerEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    _dragStart = null;
    _lastDragPosition = null;
    if (_dragging) setState(() => _dragging = false);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.profile.keyboardModel;
    if (model == null || model.isEmpty) return const SizedBox.shrink();

    final keys = resolveKeyboardKeySpecs(ref, model);
    if (keys == null || keys.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final brand = widget.profile.keyboardBrand;
    final caption = (brand?.isNotEmpty ?? false) ? '$brand $model' : model;

    return MouseRegion(
      key: _cardKey,
      cursor: _dragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      onHover: (event) => _trackPointer(event.position),
      onExit: (_) => _resetPointer(),
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerEnd,
        onPointerCancel: _onPointerEnd,
        child: Stack(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: colorScheme.surfaceContainerLow,
                shape: AppShapes.of(context).largeShape,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  children: [
                    KeyboardVisual(
                      model: model,
                      height: ProfileKeyboardHeroCard._visualHeight,
                      pointerTilt: _pointer,
                      pointerTiltDegrees:
                          ProfileKeyboardHeroCard._pointerTiltDegrees,
                      rotation: _rotation,
                      interactiveSuspended: _dragging,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.keyboard300,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Sits above the board's pointer surface, so tapping it opens
            // the viewer instead of pressing the key underneath.
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () =>
                    context.push('/profile/keyboard', extra: widget.profile),
                tooltip: l10n.profileKeyboardViewFullscreenAction,
                iconSize: 18,
                icon: const Icon(LucideIcons.maximize2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
