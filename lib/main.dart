import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridge/app.dart';
import 'package:ridge/core/window/desktop_platform.dart';
import 'package:ridge/core/window/window_geometry_listener.dart';
import 'package:ridge/core/window/window_geometry_store.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktopPlatform) {
    await windowManager.ensureInitialized();
    final geometryStore = WindowGeometryStore();
    final savedGeometry = await geometryStore.load();
    final windowOptions = WindowOptions(
      size: savedGeometry == null
          ? const Size(1280, 800)
          : Size(savedGeometry.width, savedGeometry.height),
      // Must sit below `app_shell.dart`'s `_wideBreakpoint` (640) so a
      // Linux/Windows window can actually be shrunk into the mobile
      // bottom-nav layout instead of the window manager clamping it at a
      // width that forces the desktop rail forever.
      minimumSize: const Size(320, 480),
      center: savedGeometry == null,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      title: 'Ridge',
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (savedGeometry != null) {
        await windowManager.setBounds(
          Rect.fromLTWH(
            savedGeometry.x,
            savedGeometry.y,
            savedGeometry.width,
            savedGeometry.height,
          ),
        );
        if (savedGeometry.isMaximized) await windowManager.maximize();
      }
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.addListener(WindowGeometryListener(geometryStore));
  }

  runApp(const ProviderScope(child: RidgeApp()));
}
