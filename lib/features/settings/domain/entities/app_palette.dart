/// Domain-level color palette preference. Framework-free like
/// `AppThemeMode`; the presentation layer (`core/theme/app_palette_catalog`)
/// maps each id to an actual `ColorScheme` at the edge of the hexagon.
enum AppPaletteId {
  /// The app's original single-hue brand seed.
  ember,

  /// Solid blue seed.
  ocean,

  /// Solid green seed.
  forest,

  /// Solid violet seed.
  grape,

  /// Solid pink/magenta seed.
  rose,

  /// Solid gold/yellow seed.
  sunflower,

  /// Solid teal seed.
  teal,

  /// Solid red seed.
  crimson,

  /// Desaturated, near-grayscale seed.
  mono,

  /// The Nord palette (arctic, bluish).
  nord,

  /// The Gruvbox palette (warm, retro-groove).
  gruvbox,

  /// The Dracula palette (dark, purple/pink).
  dracula,

  /// The Solarized palette (low-contrast, teal/cream).
  solarized,

  /// The Catppuccin palette (Mocha/Latte, pastel mauve).
  catppuccin,

  /// The Tokyo Night palette (deep blue/purple).
  tokyoNight,

  /// Classic green-phosphor CRT terminal.
  terminal,

  /// Neon "digital rain" green, inspired by The Matrix.
  matrix,

  /// Amber CRT readout, inspired by the Fallout Pip-Boy.
  fallout,

  /// Stark, literally colorless black-on-white / white-on-black.
  blackWhite,

  /// The Monokai palette (Sublime Text/TextMate classic).
  monokai,

  /// The One Dark palette (Atom's signature theme).
  oneDark,

  /// Neon yellow/cyberpunk-noir, inspired by Cyberpunk 2077.
  cyberpunk,

  /// 80s retro-futurist synthwave/outrun neon.
  synthwave,

  /// GitHub's own dark/light UI palette.
  github,

  /// Visual Studio Code's signature Dark+/Light+ palette.
  vscode,
}
