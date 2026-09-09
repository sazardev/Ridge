import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';
import 'package:just_in_time/features/settings/domain/entities/app_window_border_width.dart';
import 'package:window_manager/window_manager.dart';

final bool _kIsLinux = !kIsWeb && Platform.isLinux;
final bool _kIsWindows = !kIsWeb && Platform.isWindows;

/// The window frame's corner radius for [style] — kept on its own, more
/// modest scale than the component shape tokens, since a rounded corner
/// reads very differently at full-window size than on a button.
double windowFrameRadiusFor(AppCornerStyle style) => switch (style) {
  AppCornerStyle.sharp => 0,
  AppCornerStyle.soft => 6,
  AppCornerStyle.round => 12,
  AppCornerStyle.pill => 20,
};

/// The window frame's border stroke width for [width].
double windowFrameBorderWidthFor(AppWindowBorderWidth width) => switch (width) {
  AppWindowBorderWidth.thin => 1,
  AppWindowBorderWidth.medium => 1.5,
  AppWindowBorderWidth.thick => 3,
};

/// A parameterized alternative to `window_manager`'s `VirtualWindowFrame` —
/// same drag-to-resize + rounded-border-and-shadow treatment for a
/// hidden-titlebar desktop window (needed because `TitleBarStyle.hidden`
/// removes the OS's own resize handles on Linux), but with [radius] and
/// [borderWidth] driven live by the user's settings instead of hardcoded,
/// so picking a new window-border style in Settings applies immediately.
///
/// On Windows the OS frame (and its own resize borders) is still present
/// under a hidden titlebar, so — matching `VirtualWindowFrame` — only the
/// top-corner drag-to-resize wiring is added there and no extra border is
/// drawn on top of the native one. macOS keeps its native frame untouched.
class AppWindowFrame extends StatefulWidget {
  /// Creates the frame around [child].
  const new({
    required this.child,
    required this.radius,
    required this.borderWidth,
    super.key,
  });

  /// The app content the frame wraps.
  final Widget child;

  /// The frame's corner radius when the window is neither maximized nor
  /// fullscreen (both flatten it to 0, matching the screen edge).
  final double radius;

  /// The frame's border stroke width, same flattening rule as [radius].
  final double borderWidth;

  @override
  State<AppWindowFrame> createState() => _AppWindowFrameState();
}

class _AppWindowFrameState extends State<AppWindowFrame> with WindowListener {
  bool _isFocused = true;
  bool _isMaximized = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  bool get _flattened => _isMaximized || _isFullScreen;

  Widget _buildFrame(BuildContext context) {
    final radius = _flattened ? 0.0 : widget.radius;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: _flattened ? 0 : widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (!_flattened)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: Offset(0, _isFocused ? 4 : 2),
              blurRadius: 6,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_kIsLinux) {
      return DragToResizeArea(
        enableResizeEdges: _flattened ? [] : null,
        child: _buildFrame(context),
      );
    }
    if (_kIsWindows) {
      return DragToResizeArea(
        enableResizeEdges: _flattened
            ? []
            : [ResizeEdge.topLeft, ResizeEdge.top, ResizeEdge.topRight],
        child: widget.child,
      );
    }
    return widget.child;
  }

  @override
  void onWindowFocus() => setState(() => _isFocused = true);

  @override
  void onWindowBlur() => setState(() => _isFocused = false);

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  @override
  void onWindowEnterFullScreen() => setState(() => _isFullScreen = true);

  @override
  void onWindowLeaveFullScreen() => setState(() => _isFullScreen = false);
}
