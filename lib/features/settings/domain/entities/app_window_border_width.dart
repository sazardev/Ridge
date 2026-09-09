/// How thick the desktop window's custom frame border is drawn. Only
/// meaningful together with `windowBorderEnabled`; framework-free like
/// `AppThemeMode`.
enum AppWindowBorderWidth {
  /// A hairline 1px frame.
  thin,

  /// The app's original 1.5px frame.
  medium,

  /// A bolder 3px frame.
  thick,
}
