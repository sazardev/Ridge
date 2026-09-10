import 'dart:async';

import 'package:ridge/core/window/window_geometry_store.dart';
import 'package:window_manager/window_manager.dart';

/// Persists the window's bounds + maximized state on every resize/move so
/// the next launch restores them (desktop only — Android has no floating
/// window to remember, see `desktop_platform.dart`).
///
/// Debounced on `onWindowResize`/`onWindowMove`, which fire continuously
/// mid-drag on every platform — unlike `onWindowResized`/`onWindowMoved`,
/// which the package itself documents as macOS/Windows-only and which
/// Linux never emits — so this waits for a short quiet period before
/// writing instead of hammering storage on every frame of a drag.
class WindowGeometryListener with WindowListener {
  /// Creates the listener, persisting through [_store].
  new(this._store);

  final WindowGeometryStore _store;
  Timer? _debounce;

  @override
  void onWindowResize() => _scheduleSaveBounds();

  @override
  void onWindowMove() => _scheduleSaveBounds();

  @override
  void onWindowMaximize() =>
      unawaited(_store.saveIsMaximized(isMaximized: true));

  @override
  void onWindowUnmaximize() {
    unawaited(_store.saveIsMaximized(isMaximized: false));
    _scheduleSaveBounds();
  }

  void _scheduleSaveBounds() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => unawaited(_saveBoundsNow()),
    );
  }

  Future<void> _saveBoundsNow() async {
    // Bounds reported while maximized are the full-screen rect, not the
    // restorable size the user actually chose — skip them so unmaximizing
    // later still lands back on the real remembered size.
    if (await windowManager.isMaximized()) return;
    final bounds = await windowManager.getBounds();
    await _store.saveBounds(
      x: bounds.left,
      y: bounds.top,
      width: bounds.width,
      height: bounds.height,
    );
  }
}
