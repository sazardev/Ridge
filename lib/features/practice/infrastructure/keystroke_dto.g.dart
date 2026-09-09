// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keystroke_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KeystrokeDto _$KeystrokeDtoFromJson(Map<String, dynamic> json) =>
    _KeystrokeDto(
      sessionId: json['sessionId'] as String,
      seq: (json['seq'] as num).toInt(),
      sessionStartedAtUtcMicros: (json['sessionStartedAtUtcMicros'] as num)
          .toInt(),
      result: json['result'] as String,
      isCorrection: json['isCorrection'] as bool,
      physicalKeyId: json['physicalKeyId'] as String,
      finger: json['finger'] as String,
      keyboardRow: json['keyboardRow'] as String,
      thirdIndex: (json['thirdIndex'] as num).toInt(),
      expectedChar: json['expectedChar'] as String?,
      actualChar: json['actualChar'] as String?,
      dwellMicros: (json['dwellMicros'] as num?)?.toInt(),
      flightMicros: (json['flightMicros'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KeystrokeDtoToJson(_KeystrokeDto instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'seq': instance.seq,
      'sessionStartedAtUtcMicros': instance.sessionStartedAtUtcMicros,
      'result': instance.result,
      'isCorrection': instance.isCorrection,
      'physicalKeyId': instance.physicalKeyId,
      'finger': instance.finger,
      'keyboardRow': instance.keyboardRow,
      'thirdIndex': instance.thirdIndex,
      'expectedChar': instance.expectedChar,
      'actualChar': instance.actualChar,
      'dwellMicros': instance.dwellMicros,
      'flightMicros': instance.flightMicros,
    };
