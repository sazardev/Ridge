import 'package:freezed_annotation/freezed_annotation.dart';

part 'keyboard_customization_dto.freezed.dart';
part 'keyboard_customization_dto.g.dart';

/// Wire/storage shape for a `KeyboardCustomization`, serialized to the
/// `guest_profiles.keyboard_customization_json` column. Enums travel as
/// their `.name`; the mapper reparses them tolerantly, so a future version
/// that adds a value (or a downgrade that doesn't know one) degrades that
/// single field instead of losing the whole blob. Kept separate from the
/// domain entity so a storage-format change never leaks into business
/// logic — only the mapper needs to change.
@freezed
abstract class KeyboardCustomizationDto with _$KeyboardCustomizationDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    String? shapeFamily,
    String? keycapShape,
    String? keycapTransparency,
    int? keycapColor,
    int? caseColor,
    @Default(false) bool rgbEnabled,
    String? rgbEffect,
    int? rgbColor,
    String? switchType,
    String? keycapMaterial,
    String? caseMaterial,
    String? physicalLayout,
    String? connection,
    bool? hotSwappable,
    int? purchaseYear,
    String? notes,
    @Default(<KeyboardKeyOverrideDto>[])
    List<KeyboardKeyOverrideDto> keyOverrides,
    @Default(<KeyboardExtraKeyDto>[]) List<KeyboardExtraKeyDto> extraKeys,
    @Default(<KeyboardKeyRemapDto>[]) List<KeyboardKeyRemapDto> remaps,
    @Default(<KeyboardKeyLightDto>[]) List<KeyboardKeyLightDto> keyLights,
  }) = _KeyboardCustomizationDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardCustomizationDtoFromJson(json);
}

/// Wire shape for one `KeyboardKeyLegendOverride`.
@freezed
abstract class KeyboardKeyOverrideDto with _$KeyboardKeyOverrideDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({required String keyId, String? label, String? label2}) =
      _KeyboardKeyOverrideDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardKeyOverrideDtoFromJson(json);
}

/// Wire shape for one user-added `KeyboardExtraKey`.
@freezed
abstract class KeyboardExtraKeyDto with _$KeyboardExtraKeyDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String id,
    String? label,
    String? label2,
    @Default(1) double width,
    @Default(1) double height,
  }) = _KeyboardExtraKeyDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardExtraKeyDtoFromJson(json);
}

/// Wire shape for one functional `KeyboardKeyRemap`.
@freezed
abstract class KeyboardKeyRemapDto with _$KeyboardKeyRemapDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String physicalKey,
    required String character,
    String? shiftedCharacter,
  }) = _KeyboardKeyRemapDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardKeyRemapDtoFromJson(json);
}

/// Wire shape for one `KeyboardKeyLight`.
@freezed
abstract class KeyboardKeyLightDto with _$KeyboardKeyLightDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({required String keyId, required int color}) =
      _KeyboardKeyLightDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$KeyboardKeyLightDtoFromJson(json);
}
