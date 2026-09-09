import 'package:shared_preferences/shared_preferences.dart';

const _keyX = 'window_geometry_x';
const _keyY = 'window_geometry_y';
const _keyWidth = 'window_geometry_width';
const _keyHeight = 'window_geometry_height';
const _keyIsMaximized = 'window_geometry_is_maximized';

/// The window's last-known bounds + maximized state.
class WindowGeometry {
  /// Creates a geometry snapshot.
  const new({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.isMaximized,
  });

  /// Left edge, in logical pixels from the primary display's origin.
  final double x;

  /// Top edge, in logical pixels from the primary display's origin.
  final double y;

  /// Window width in logical pixels (the restored, non-maximized size).
  final double width;

  /// Window height in logical pixels (the restored, non-maximized size).
  final double height;

  /// Whether the window was maximized when last saved.
  final bool isMaximized;
}

/// Reads/writes [WindowGeometry] directly through `SharedPreferencesAsync`
/// — deliberately not through Riverpod: this is read in `main()`, before a
/// `ProviderContainer` exists.
class WindowGeometryStore {
  final _prefs = SharedPreferencesAsync();

  /// The last-saved geometry, or `null` on first launch (or if a previous
  /// save was interrupted, leaving only some of the values set).
  Future<WindowGeometry?> load() async {
    final x = await _prefs.getDouble(_keyX);
    final y = await _prefs.getDouble(_keyY);
    final width = await _prefs.getDouble(_keyWidth);
    final height = await _prefs.getDouble(_keyHeight);
    if (x == null || y == null || width == null || height == null) {
      return null;
    }
    return WindowGeometry(
      x: x,
      y: y,
      width: width,
      height: height,
      isMaximized: await _prefs.getBool(_keyIsMaximized) ?? false,
    );
  }

  /// Persists the window's current, non-maximized bounds.
  Future<void> saveBounds({
    required double x,
    required double y,
    required double width,
    required double height,
  }) => Future.wait([
    _prefs.setDouble(_keyX, x),
    _prefs.setDouble(_keyY, y),
    _prefs.setDouble(_keyWidth, width),
    _prefs.setDouble(_keyHeight, height),
  ]);

  /// Persists whether the window is currently maximized.
  Future<void> saveIsMaximized({required bool isMaximized}) =>
      _prefs.setBool(_keyIsMaximized, isMaximized);
}
