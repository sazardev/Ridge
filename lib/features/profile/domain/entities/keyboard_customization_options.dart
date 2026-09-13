/// The selectable options of a profile's keyboard customization — every
/// enum here is persisted by name inside `keyboard_customization_json`
/// (see `KeyboardCustomization`), so display-only concerns (icons,
/// localized labels) live in presentation, never here.
library;

/// The silhouette of every keycap's top face, applied uniformly to the
/// whole board.
enum KeycapShape {
  /// Softly rounded corners — the app's default look.
  rounded,

  /// Near-square corners, like a classic OEM/beige set.
  square,

  /// Fully circular caps, like a round typewriter/retro set (wide keys
  /// become stadium-shaped).
  round,
}

/// The animated or static behavior of the board's backlight, when
/// `KeyboardCustomization.rgbEnabled` is true — the standard set a
/// mechanical keyboard's firmware offers.
enum RgbEffect {
  /// A fixed glow in `KeyboardCustomization.rgbColor`.
  static,

  /// The fixed color smoothly fading in and out.
  breathing,

  /// The hue cycling across the board, one phase offset per key column.
  rainbow,

  /// The whole board's hue cycling together.
  colorCycle,

  /// A bright band of the light color sweeping across the board.
  wave,

  /// Soft, slow color drifts flowing across the board.
  aurora,

  /// Per-key twinkling points of light.
  stars,

  /// Bright drops falling down the board.
  rain,

  /// A static two-color blend across the board's height.
  gradient,

  /// Backlit keys react to presses: a key flashes on click/keystroke and
  /// fades out — the classic "reactive" keyboard lighting.
  reactive,

  /// A ring of light expands outward from each pressed key — the typewriter
  /// "splash" effect.
  ripple,
}

/// How much of the backlight passes through the keycaps — the difference
/// between stock opaque caps, doubleshot shine-through legends, "pudding"
/// caps with glowing sides, and fully translucent caps.
enum KeycapTransparency {
  /// Opaque caps: light only spills around the keycaps, legend stays dark.
  opaque,

  /// The printed legend glows through, top stays mostly opaque.
  shineThrough,

  /// Sides glow strongly (pudding-style), legend moderately.
  pudding,

  /// The whole cap lets light through.
  translucent,
}

/// What's under the keycaps.
enum SwitchType {
  /// Smooth, no tactile bump.
  linear,

  /// A tactile bump without a click.
  tactile,

  /// A tactile bump with an audible click.
  clicky,

  /// Optical (light-actuated) switches.
  optical,

  /// Magnetic/hall-effect switches (analog, adjustable actuation).
  magnetic,

  /// Topre-style electro-capacitive domes.
  topre,

  /// Rubber-dome (typical membrane boards).
  rubberDome,

  /// Scissor switches (typical low-profile laptop boards).
  scissor,

  /// IBM Model M-style buckling spring.
  bucklingSpring,

  /// Anything not covered above.
  other,
}

/// What the keycaps are made of.
enum KeycapMaterial {
  /// ABS plastic — the common, shiny-over-time default.
  abs,

  /// PBT plastic — textured and shine-resistant.
  pbt,

  /// POM plastic.
  pom,

  /// Metal caps (aluminum, zinc, ...).
  metal,

  /// Ceramic caps.
  ceramic,

  /// Wood caps.
  wood,

  /// Anything not covered above.
  other,
}

/// What the case/body is made of.
enum CaseMaterial {
  /// Plastic (the common mainstream default).
  plastic,

  /// Aluminum (the enthusiast standard).
  aluminum,

  /// Steel or other heavy metal.
  steel,

  /// Wood.
  wood,

  /// Resin/cast.
  resin,

  /// Anything not covered above.
  other,
}

/// The physical key arrangement standard (the *shape* of the board), the
/// same distinction a shop page makes when it says "US-ANSI" vs
/// "Spanish-ISO". Independent of `KeyboardLayout` (the character layout:
/// QWERTY, AZERTY, ...) and of `KeyboardShapeFamily` (the size/silhouette
/// the visual is drawn with).
enum KeyboardPhysicalLayout {
  /// US-ANSI (wide left Shift, no extra key next to `Z`).
  ansi,

  /// ISO (narrow left Shift, extra key next to `Z`).
  iso,

  /// Japanese JIS.
  jis,

  /// Anything not covered above.
  other,
}

/// How the board talks to the machine.
enum KeyboardConnectionType {
  /// USB/PS2 cable only.
  wired,

  /// Bluetooth only.
  bluetooth,

  /// 2.4 GHz dongle only.
  wireless24,

  /// More than one of the above (e.g. wired + Bluetooth + 2.4 GHz).
  multi,
}
