import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyboard_key_spec.freezed.dart';

/// A single physical keycap's geometry, in key-units (1.0 == a standard
/// 1u keycap footprint) — the same shape vocabulary
/// keyboard-layout-editor.com/QMK's `info.json` use, so curated JSON
/// sourced from those tools maps onto this 1:1 (see
/// `keyboard_visual_layout_dto.dart`).
///
/// [x]/[y] place the primary rectangle's top-left corner; [x2]/[y2]/[w2]/
/// [h2] describe an optional second rectangle offset from the primary
/// one (e.g. an ISO Enter's L-shape) — always fully resolved to concrete
/// values by `KeyboardKeySpecDtoMapper.toDomain()` (defaulting to the
/// primary rectangle when the source omits them), never left ambiguous
/// on this entity. [rotationAngle] (degrees) rotates the key around
/// ([rotationX], [rotationY]) — both default to ([x], [y]), the key's
/// own corner, when the source doesn't specify a different pivot.
///
/// [label]/[label2] are the cap's printed legends: [label] is the primary
/// one (centered, or lower when [label2] exists) and [label2] the shifted
/// symbol drawn above it (e.g. `!` over `1`). Both are optional — a key
/// with no legend renders as a blank cap, exactly like the geometry-only
/// data bank did before legends existed.
@freezed
abstract class KeyboardKeySpec with _$KeyboardKeySpec {
  /// Creates a fully-resolved key geometry snapshot.
  const factory({
    required double x,
    required double y,
    required double w,
    required double h,
    required double x2,
    required double y2,
    required double w2,
    required double h2,
    required double rotationAngle,
    required double rotationX,
    required double rotationY,
    String? label,
    String? label2,
  }) = _KeyboardKeySpec;
}

/// Stable identifier for a key's physical position, used to attach
/// per-key customization (`KeyboardCustomization.keyOverrides`) to a
/// curated or generic-family layout without depending on list order —
/// the same position always formats to the same id, whatever the source
/// asset. Three decimals is far beyond key-unit granularity, so the id
/// only needs to absorb floating-point noise, nothing else.
String keyboardKeyIdFor(KeyboardKeySpec key) =>
    '${key.x.toStringAsFixed(3)},${key.y.toStringAsFixed(3)}';
