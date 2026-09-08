/// Domain-level theme preference. Deliberately not `dart:ui`'s `ThemeMode`
/// so the domain layer stays framework-free; the presentation layer maps
/// this to Flutter's `ThemeMode` at the edge of the hexagon.
enum AppThemeMode { system, light, dark }
