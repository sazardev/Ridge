// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_visual_layout_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KeyboardKeySpecDto _$KeyboardKeySpecDtoFromJson(Map<String, dynamic> json) =>
    _KeyboardKeySpecDto(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      w: (json['w'] as num?)?.toDouble() ?? 1,
      h: (json['h'] as num?)?.toDouble() ?? 1,
      x2: (json['x2'] as num?)?.toDouble(),
      y2: (json['y2'] as num?)?.toDouble(),
      w2: (json['w2'] as num?)?.toDouble(),
      h2: (json['h2'] as num?)?.toDouble(),
      rotationAngle: (json['r'] as num?)?.toDouble() ?? 0,
      rotationX: (json['rx'] as num?)?.toDouble(),
      rotationY: (json['ry'] as num?)?.toDouble(),
      label: json['label'] as String?,
      label2: json['label2'] as String?,
    );

Map<String, dynamic> _$KeyboardKeySpecDtoToJson(_KeyboardKeySpecDto instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'x2': instance.x2,
      'y2': instance.y2,
      'w2': instance.w2,
      'h2': instance.h2,
      'r': instance.rotationAngle,
      'rx': instance.rotationX,
      'ry': instance.rotationY,
      'label': instance.label,
      'label2': instance.label2,
    };

_KeyboardVisualLayoutDto _$KeyboardVisualLayoutDtoFromJson(
  Map<String, dynamic> json,
) => _KeyboardVisualLayoutDto(
  model: json['model'] as String,
  keys: (json['keys'] as List<dynamic>)
      .map((e) => KeyboardKeySpecDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KeyboardVisualLayoutDtoToJson(
  _KeyboardVisualLayoutDto instance,
) => <String, dynamic>{'model': instance.model, 'keys': instance.keys};
