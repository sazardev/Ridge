import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';

part 'keyboard_customization.freezed.dart';

/// The user's full description of their own physical keyboard — every
/// piece of metadata the profile editor asks about, layered on top of the
/// free-text brand/model and the character `KeyboardLayout` (which stay
/// separate fields on `GuestProfile`). Pure domain: no JSON, no Flutter,
/// no drift.
///
/// Everything is optional-with-a-default so an untouched `GuestProfile`
/// can carry `null` and every renderer falls back to the curated layout
/// or generic family silhouette as before — customizing is purely
/// additive. Colors are stored as ARGB `int`s (not `Color`, which is a
/// Flutter type) so the domain stays framework-free; presentation
/// converts them at the edge.
///
/// `keyOverrides`/`extraKeys` compose with whatever geometry the model
/// resolves to: overrides are keyed by physical position (see
/// `keyboardKeyIdFor`), never by list index, so they survive asset
/// updates; extra keys are drawn in an auto-placed column to the right of
/// the board. `remaps` is the one genuinely functional piece: it tells
/// `practice` that a given physical key should count as a different
/// character than the OS layout produces.
@freezed
abstract class KeyboardCustomization with _$KeyboardCustomization {
  /// Creates an immutable keyboard-customization snapshot.
  const factory({
    KeyboardShapeFamily? shapeFamily,
    @Default(KeycapShape.rounded) KeycapShape keycapShape,
    @Default(KeycapTransparency.translucent)
    KeycapTransparency keycapTransparency,
    int? keycapColor,
    int? caseColor,
    @Default(false) bool rgbEnabled,
    @Default(RgbEffect.static) RgbEffect rgbEffect,
    int? rgbColor,
    SwitchType? switchType,
    KeycapMaterial? keycapMaterial,
    CaseMaterial? caseMaterial,
    KeyboardPhysicalLayout? physicalLayout,
    KeyboardConnectionType? connection,
    bool? hotSwappable,
    int? purchaseYear,
    String? notes,
    @Default(<KeyboardKeyLegendOverride>[])
    List<KeyboardKeyLegendOverride> keyOverrides,
    @Default(<KeyboardExtraKey>[]) List<KeyboardExtraKey> extraKeys,
    @Default(<KeyboardKeyRemap>[]) List<KeyboardKeyRemap> remaps,
    @Default(<KeyboardKeyLight>[]) List<KeyboardKeyLight> keyLights,
  }) = _KeyboardCustomization;

  /// No keyboard customization beyond the model's own curated defaults.
  static const empty = KeyboardCustomization();
}

/// A user-edited legend printed on one existing keycap, addressed by its
/// physical position (`keyboardKeyIdFor`) — `null`/empty means "keep the
/// curated legend for this key".
@freezed
abstract class KeyboardKeyLegendOverride with _$KeyboardKeyLegendOverride {
  /// Creates an override for the key at [keyId].
  const factory({required String keyId, String? label, String? label2}) =
      _KeyboardKeyLegendOverride;
}

/// A key the user added because their board has more keys than the
/// resolved layout draws (macro columns, knobs, a dedicated media row,
/// ...). Placement is derived at render time from the board's bounding
/// box, so only the key's own size and legends are persisted. [id] is a
/// locally unique handle for editing/removing the row, never rendered.
@freezed
abstract class KeyboardExtraKey with _$KeyboardExtraKey {
  /// Creates an extra key with an explicit [id].
  const factory({
    required String id,
    String? label,
    String? label2,
    @Default(1) double width,
    @Default(1) double height,
  }) = _KeyboardExtraKey;
}

/// A functional remap: the physical key named after a `practice`'s
/// `PhysicalKeyId` (`physicalKey`, e.g. `"keyA"`) should count as
/// [character] (and [shiftedCharacter] with Shift held, when set) instead
/// of whatever the OS layout produces. The `physicalKey` string is kept
/// untyped here on purpose — `profile`'s domain must not import
/// `practice`'s; the capture engine resolves the name and silently
/// ignores names it doesn't model.
@freezed
abstract class KeyboardKeyRemap with _$KeyboardKeyRemap {
  /// Creates a remap for [physicalKey].
  const factory({
    required String physicalKey,
    required String character,
    String? shiftedCharacter,
  }) = _KeyboardKeyRemap;
}

/// A per-key backlight color: the key named by [keyId] (a base key's
/// `keyboardKeyIdFor` position string, or a `KeyboardExtraKey.id`) glows
/// in [color] (ARGB) instead of the board-wide RGB color. Only meaningful
/// while `KeyboardCustomization.rgbEnabled` is true; absent means "use the
/// global light color for this key".
@freezed
abstract class KeyboardKeyLight with _$KeyboardKeyLight {
  /// Creates a per-key light for [keyId].
  const factory({required String keyId, required int color}) =
      _KeyboardKeyLight;
}
