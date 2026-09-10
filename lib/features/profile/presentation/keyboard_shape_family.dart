/// A generic physical-keyboard shape/size family — the closest the
/// profile's free-text `keyboardModel` field gets to a "silhouette" the
/// app can actually draw. Deliberately size/shape-based, not brand-based,
/// and deliberately not ANSI/ISO- or character-layout-accurate: brand and
/// model are free text with no guaranteed spec sheet, so per-model
/// pixel-accurate geometry isn't something this app curates or maintains.
/// See `keyboard_shape_lookup.dart` for the curated model → family map.
enum KeyboardShapeFamily {
  /// 104/105-key, includes a numpad (e.g. Cooler Master MK770, Corsair
  /// K95, Royal Kludge RK100).
  fullSize,

  /// Tenkeyless, ~87-key, no numpad (e.g. Keychron K8, Ducky One 3,
  /// Razer BlackWidow V3).
  tkl,

  /// ~84-key, keeps the function row and a tight nav cluster but drops
  /// the numpad (e.g. Keychron Q1/V1, GMMK Pro, NuPhy Halo75).
  seventyFive,

  /// ~68-key, arrow keys and a couple of nav keys but no function row
  /// (e.g. Keychron K6/V6, NuPhy Air60/Air75-class boards).
  sixtyFive,

  /// ~61-key, no function row, no arrows/nav cluster (e.g. Keychron K12,
  /// Vortex POK3R, Anne Pro 2, HHKB).
  sixty,

  /// Physically split into two halves (e.g. ZSA Moonlander/Voyager,
  /// ErgoDox EZ, Kinesis Advantage2/360/Freestyle Edge).
  splitErgo,
}
