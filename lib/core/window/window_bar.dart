import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/window/desktop_platform.dart';
import 'package:just_in_time/core/window/window_bar_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:window_manager/window_manager.dart';

/// A fully custom, OS-decoration-free title bar for desktop windows —
/// drag-to-move, double-click-to-maximize, and its own minimize/maximize/
/// close buttons themed with the app's primary color instead of the host
/// OS's chrome. Renders nothing on Android/iOS/web; safe to mount
/// unconditionally anywhere in the widget tree.
class WindowBar extends StatefulWidget {
  /// Creates the window bar, optionally driven by a shake [controller].
  const new({super.key, this.controller});

  /// Lets external code trigger the attention-shake animation.
  final WindowBarController? controller;

  /// The bar's fixed height, for callers that need to reserve space.
  static const height = 34.0;

  @override
  State<WindowBar> createState() => _WindowBarState();
}

class _WindowBarState extends State<WindowBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    if (!isDesktopPlatform) return;
    windowManager.addListener(this);
    unawaited(_syncMaximizedState());
  }

  @override
  void dispose() {
    if (isDesktopPlatform) windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _syncMaximizedState() async {
    final maximized = await windowManager.isMaximized();
    if (mounted) setState(() => _isMaximized = maximized);
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  Future<void> _toggleMaximize() =>
      _isMaximized ? windowManager.unmaximize() : windowManager.maximize();

  @override
  Widget build(BuildContext context) {
    if (!isDesktopPlatform) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final bar = Container(
      height: WindowBar.height,
      color: colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => windowManager.startDragging(),
              onDoubleTap: _toggleMaximize,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      'assets/icons/keycap_mark.svg',
                      colorFilter: ColorFilter.mode(
                        colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _WindowButton(
            icon: LucideIcons.minus,
            tooltip: l10n.windowMinimize,
            onPressed: windowManager.minimize,
          ),
          _WindowButton(
            icon: _isMaximized ? LucideIcons.copy : LucideIcons.maximize,
            tooltip: _isMaximized ? l10n.windowRestore : l10n.windowMaximize,
            onPressed: _toggleMaximize,
          ),
          _WindowButton(
            icon: LucideIcons.x,
            tooltip: l10n.windowClose,
            onPressed: windowManager.close,
            isClose: true,
          ),
        ],
      ),
    );

    final shakeController = widget.controller;
    if (shakeController == null) return bar;

    return ListenableBuilder(
      listenable: shakeController,
      builder: (context, child) {
        if (shakeController.value == 0) return child!;
        return child!
            .animate(key: ValueKey(shakeController.value))
            .shakeX(amount: 6, hz: 8, duration: 320.ms);
      },
      child: bar,
    );
  }
}

class _WindowButton extends StatefulWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isClose = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isClose;

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hoverColor = widget.isClose
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final iconColor = widget.isClose && _hovered
        ? colorScheme.onErrorContainer
        : colorScheme.onSurfaceVariant;

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: SizedBox(
          width: 40,
          height: WindowBar.height,
          child: Material(
            color: _hovered ? hoverColor : Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              child: Icon(widget.icon, size: 16, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
