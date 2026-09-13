// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_customization_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KeyboardCustomizationDto _$KeyboardCustomizationDtoFromJson(
  Map<String, dynamic> json,
) => _KeyboardCustomizationDto(
  shapeFamily: json['shapeFamily'] as String?,
  keycapShape: json['keycapShape'] as String?,
  keycapTransparency: json['keycapTransparency'] as String?,
  keycapColor: (json['keycapColor'] as num?)?.toInt(),
  caseColor: (json['caseColor'] as num?)?.toInt(),
  rgbEnabled: json['rgbEnabled'] as bool? ?? false,
  rgbEffect: json['rgbEffect'] as String?,
  rgbColor: (json['rgbColor'] as num?)?.toInt(),
  switchType: json['switchType'] as String?,
  keycapMaterial: json['keycapMaterial'] as String?,
  caseMaterial: json['caseMaterial'] as String?,
  physicalLayout: json['physicalLayout'] as String?,
  connection: json['connection'] as String?,
  hotSwappable: json['hotSwappable'] as bool?,
  purchaseYear: (json['purchaseYear'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  keyOverrides:
      (json['keyOverrides'] as List<dynamic>?)
          ?.map(
            (e) => KeyboardKeyOverrideDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <KeyboardKeyOverrideDto>[],
  extraKeys:
      (json['extraKeys'] as List<dynamic>?)
          ?.map((e) => KeyboardExtraKeyDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KeyboardExtraKeyDto>[],
  remaps:
      (json['remaps'] as List<dynamic>?)
          ?.map((e) => KeyboardKeyRemapDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KeyboardKeyRemapDto>[],
  keyLights:
      (json['keyLights'] as List<dynamic>?)
          ?.map((e) => KeyboardKeyLightDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KeyboardKeyLightDto>[],
);

Map<String, dynamic> _$KeyboardCustomizationDtoToJson(
  _KeyboardCustomizationDto instance,
) => <String, dynamic>{
  'shapeFamily': instance.shapeFamily,
  'keycapShape': instance.keycapShape,
  'keycapTransparency': instance.keycapTransparency,
  'keycapColor': instance.keycapColor,
  'caseColor': instance.caseColor,
  'rgbEnabled': instance.rgbEnabled,
  'rgbEffect': instance.rgbEffect,
  'rgbColor': instance.rgbColor,
  'switchType': instance.switchType,
  'keycapMaterial': instance.keycapMaterial,
  'caseMaterial': instance.caseMaterial,
  'physicalLayout': instance.physicalLayout,
  'connection': instance.connection,
  'hotSwappable': instance.hotSwappable,
  'purchaseYear': instance.purchaseYear,
  'notes': instance.notes,
  'keyOverrides': instance.keyOverrides,
  'extraKeys': instance.extraKeys,
  'remaps': instance.remaps,
  'keyLights': instance.keyLights,
};

_KeyboardKeyOverrideDto _$KeyboardKeyOverrideDtoFromJson(
  Map<String, dynamic> json,
) => _KeyboardKeyOverrideDto(
  keyId: json['keyId'] as String,
  label: json['label'] as String?,
  label2: json['label2'] as String?,
);

Map<String, dynamic> _$KeyboardKeyOverrideDtoToJson(
  _KeyboardKeyOverrideDto instance,
) => <String, dynamic>{
  'keyId': instance.keyId,
  'label': instance.label,
  'label2': instance.label2,
};

_KeyboardExtraKeyDto _$KeyboardExtraKeyDtoFromJson(Map<String, dynamic> json) =>
    _KeyboardExtraKeyDto(
      id: json['id'] as String,
      label: json['label'] as String?,
      label2: json['label2'] as String?,
      width: (json['width'] as num?)?.toDouble() ?? 1,
      height: (json['height'] as num?)?.toDouble() ?? 1,
    );

Map<String, dynamic> _$KeyboardExtraKeyDtoToJson(
  _KeyboardExtraKeyDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'label2': instance.label2,
  'width': instance.width,
  'height': instance.height,
};

_KeyboardKeyRemapDto _$KeyboardKeyRemapDtoFromJson(Map<String, dynamic> json) =>
    _KeyboardKeyRemapDto(
      physicalKey: json['physicalKey'] as String,
      character: json['character'] as String,
      shiftedCharacter: json['shiftedCharacter'] as String?,
    );

Map<String, dynamic> _$KeyboardKeyRemapDtoToJson(
  _KeyboardKeyRemapDto instance,
) => <String, dynamic>{
  'physicalKey': instance.physicalKey,
  'character': instance.character,
  'shiftedCharacter': instance.shiftedCharacter,
};

_KeyboardKeyLightDto _$KeyboardKeyLightDtoFromJson(Map<String, dynamic> json) =>
    _KeyboardKeyLightDto(
      keyId: json['keyId'] as String,
      color: (json['color'] as num).toInt(),
    );

Map<String, dynamic> _$KeyboardKeyLightDtoToJson(
  _KeyboardKeyLightDto instance,
) => <String, dynamic>{'keyId': instance.keyId, 'color': instance.color};
