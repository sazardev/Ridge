import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyboard_visual_layout_dto.freezed.dart';
part 'keyboard_visual_layout_dto.g.dart';

/// Wire shape for one key in a curated `assets/content/keyboard_layouts/
/// *.json` file. Field names (`x, y, w, h, x2, y2, w2, h2, r, rx, ry`)
/// deliberately match keyboard-layout-editor.com/QMK `info.json`
/// conventions verbatim, so curation only ever has to copy values across,
/// never rename them. Every field but [x]/[y] is optional in the JSON —
/// `KeyboardKeySpecDtoMapper.toDomain()` resolves the KLE defaults (`w`/
/// `h` default to 1; `x2`/`y2` default to 0; `w2`/`h2` default to `w`/`h`;
/// `rotationAngle` defaults to 0; `rotationX`/`rotationY` default to
/// `x`/`y`) into a fully-concrete `KeyboardKeySpec`.
@freezed
abstract class KeyboardKeySpecDto with _$KeyboardKeySpecDto {
  /// Creates a DTO snapshot ready for JSON deserialization.
  const factory({
    required double x,
    required double y,
    @Default(1) double w,
    @Default(1) double h,
    double? x2,
    double? y2,
    double? w2,
    double? h2,
    @JsonKey(name: 'r') @Default(0) double rotationAngle,
    @JsonKey(name: 'rx') double? rotationX,
    @JsonKey(name: 'ry') double? rotationY,
  }) = _KeyboardKeySpecDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardKeySpecDtoFromJson(json);
}

/// Wire shape for a curated `assets/content/keyboard_layouts/*.json`
/// file. Mirrors the file's shape exactly; the file's `source` field
/// (attribution/traceability metadata) is intentionally left unmapped —
/// see `THIRD_PARTY_SOURCES.md` alongside the assets for that.
@freezed
abstract class KeyboardVisualLayoutDto with _$KeyboardVisualLayoutDto {
  /// Creates a DTO snapshot ready for JSON deserialization.
  const factory({
    required String model,
    required List<KeyboardKeySpecDto> keys,
  }) = _KeyboardVisualLayoutDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardVisualLayoutDtoFromJson(json);
}
