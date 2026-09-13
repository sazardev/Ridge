import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;

import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_customization_dto.dart';

/// Converts a [KeyboardCustomizationDto] into its domain
/// [KeyboardCustomization] — every enum is resolved by name and an
/// unrecognized/missing one degrades to that field's default (`null`, or
/// `KeycapShape.rounded`), never failing the whole blob. Entries with the
/// minimum identity missing (no key position, no extra-key id, no remap
/// character) are dropped rather than stored half-formed.
extension KeyboardCustomizationDtoMapper on KeyboardCustomizationDto {
  /// Maps this DTO to the domain entity.
  KeyboardCustomization toDomain() {
    return KeyboardCustomization(
      shapeFamily: _enumByName(KeyboardShapeFamily.values, shapeFamily),
      keycapShape:
          _enumByName(KeycapShape.values, keycapShape) ?? KeycapShape.rounded,
      keycapTransparency:
          _enumByName(KeycapTransparency.values, keycapTransparency) ??
          KeycapTransparency.translucent,
      keycapColor: keycapColor,
      caseColor: caseColor,
      rgbEnabled: rgbEnabled,
      rgbEffect: _enumByName(RgbEffect.values, rgbEffect) ?? RgbEffect.static,
      rgbColor: rgbColor,
      switchType: _enumByName(SwitchType.values, switchType),
      keycapMaterial: _enumByName(KeycapMaterial.values, keycapMaterial),
      caseMaterial: _enumByName(CaseMaterial.values, caseMaterial),
      physicalLayout: _enumByName(
        KeyboardPhysicalLayout.values,
        physicalLayout,
      ),
      connection: _enumByName(KeyboardConnectionType.values, connection),
      hotSwappable: hotSwappable,
      purchaseYear: purchaseYear,
      notes: notes,
      keyOverrides: [
        for (final o in keyOverrides)
          if (o.keyId.isNotEmpty)
            KeyboardKeyLegendOverride(
              keyId: o.keyId,
              label: o.label,
              label2: o.label2,
            ),
      ],
      extraKeys: [
        for (final e in extraKeys)
          if (e.id.isNotEmpty)
            KeyboardExtraKey(
              id: e.id,
              label: e.label,
              label2: e.label2,
              width: e.width,
              height: e.height,
            ),
      ],
      remaps: [
        for (final r in remaps)
          if (r.physicalKey.isNotEmpty && r.character.isNotEmpty)
            KeyboardKeyRemap(
              physicalKey: r.physicalKey,
              character: r.character,
              shiftedCharacter: r.shiftedCharacter,
            ),
      ],
      keyLights: [
        for (final l in keyLights)
          if (l.keyId.isNotEmpty)
            KeyboardKeyLight(keyId: l.keyId, color: l.color),
      ],
    );
  }
}

/// Converts a [KeyboardCustomization] entity into its storage DTO.
extension KeyboardCustomizationMapper on KeyboardCustomization {
  /// Maps this entity to its wire/storage shape.
  KeyboardCustomizationDto toDto() {
    return KeyboardCustomizationDto(
      shapeFamily: shapeFamily?.name,
      keycapShape: keycapShape.name,
      keycapTransparency: keycapTransparency.name,
      keycapColor: keycapColor,
      caseColor: caseColor,
      rgbEnabled: rgbEnabled,
      rgbEffect: rgbEffect.name,
      rgbColor: rgbColor,
      switchType: switchType?.name,
      keycapMaterial: keycapMaterial?.name,
      caseMaterial: caseMaterial?.name,
      physicalLayout: physicalLayout?.name,
      connection: connection?.name,
      hotSwappable: hotSwappable,
      purchaseYear: purchaseYear,
      notes: notes,
      keyOverrides: [
        for (final o in keyOverrides)
          KeyboardKeyOverrideDto(
            keyId: o.keyId,
            label: o.label,
            label2: o.label2,
          ),
      ],
      extraKeys: [
        for (final e in extraKeys)
          KeyboardExtraKeyDto(
            id: e.id,
            label: e.label,
            label2: e.label2,
            width: e.width,
            height: e.height,
          ),
      ],
      remaps: [
        for (final r in remaps)
          KeyboardKeyRemapDto(
            physicalKey: r.physicalKey,
            character: r.character,
            shiftedCharacter: r.shiftedCharacter,
          ),
      ],
      keyLights: [
        for (final l in keyLights)
          KeyboardKeyLightDto(keyId: l.keyId, color: l.color),
      ],
    );
  }
}

/// Serializes [customization] to the TEXT stored in
/// `guest_profiles.keyboard_customization_json`.
String encodeKeyboardCustomization(KeyboardCustomization customization) {
  return jsonEncode(customization.toDto().toJson());
}

/// Parses the raw `keyboard_customization_json` column back into a
/// [KeyboardCustomization], or `null` when the column is empty/`null` or
/// holds anything this app version can't parse — a corrupt blob is
/// decoration, never worth crashing profile rendering over.
KeyboardCustomization? decodeKeyboardCustomization(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return KeyboardCustomizationDto.fromJson(
      jsonDecode(raw) as Map<String, Object?>,
    ).toDomain();
    // A shape/type mismatch throws an `Error` (not an `Exception`), so
    // `on Exception` wouldn't catch it — a corrupt blob is decoration,
    // never worth crashing profile rendering over.
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    debugPrint('decodeKeyboardCustomization: dropped a blob — $e');
    return null;
  }
}

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  if (name == null) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
