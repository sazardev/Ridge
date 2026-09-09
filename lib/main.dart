import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_in_time/app.dart';
import 'package:just_in_time/core/window/desktop_platform.dart';
import 'package:just_in_time/core/window/window_geometry_listener.dart';
import 'package:just_in_time/core/window/window_geometry_store.dart';
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
      minimumSize: const Size(960, 640),
      center: savedGeometry == null,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
      title: 'Just In Time',
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

  runApp(const ProviderScope(child: JustInTimeApp()));
}
