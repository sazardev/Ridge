import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridge/app.dart';
import 'package:ridge/core/window/desktop_platform.dart';
import 'package:ridge/core/window/window_geometry_listener.dart';
import 'package:ridge/core/window/window_geometry_store.dart';
import 'package:ridge/features/settings/infrastructure/settings_repository_impl.dart';
import 'package:ridge/features/settings/presentation/providers/settings_providers.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Reads persisted `AppSettings` (theme/palette/corner style/...) before
  // `runApp` ever paints a frame, using one `ProviderContainer` that then
  // gets handed straight to the widget tree below (`UncontrolledProviderScope`)
  // instead of letting a plain `ProviderScope` create its own lazily.
  // Without this, `RidgeApp`'s first frame — this includes
  // `AppStartupSplash`'s `WindowBar`, which is on-screen for exactly this
  // window — briefly renders with `AppSettings.initial`'s hardcoded
  // defaults (Ember palette, system theme) instead of whatever the user
  // actually picked, until the async `shared_preferences` read resolves a
  // frame or two later and repaints with the real value.
  //
  // `settingsRepositoryProvider` is typed as the abstract
  // `SettingsRepository` port everywhere else (so tests can swap in a
  // fake), but `main.dart` is the composition root — the one place
  // already wired to the concrete adapter — so it reads `.hydrated`
  // directly off it rather than through `watch()`, whose broadcast
  // stream deliberately still replays `AppSettings.initial` to every
  // *other* new subscriber (`SettingsController`, at app startup)
  // immediately, matching the un-warmed-up case tests rely on.
  final container = ProviderContainer();
  final settingsRepository = container.read(settingsRepositoryProvider);
  if (settingsRepository is SettingsRepositoryImpl) {
    await settingsRepository.hydrated;
  }

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
      // `show()`/`focus()` run first, then bounds are (re-)applied — on
      // Linux (GTK/Wayland), sizing an unmapped window is unreliable: the
      // compositor's first `configure` can hand back a smaller size than
      // requested (observed under WSLg/Weston, ~50px lost on both axes),
      // and every subsequent launch would persist that already-shrunk
      // size and lose a bit more, shrinking the window on every restart.
      // Setting bounds again once the window is mapped applies exactly,
      // with no loss — `windowOptions.size` above is still passed so the
      // pre-show frame is already close to the restored size instead of
      // flashing the 1280x800 default.
      await windowManager.show();
      await windowManager.focus();
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
    });
    windowManager.addListener(WindowGeometryListener(geometryStore));
  }

  runApp(
    UncontrolledProviderScope(container: container, child: const RidgeApp()),
  );
}
