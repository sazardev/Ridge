// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => _ProfileDto(
  id: json['id'] as String,
  username: json['username'] as String,
  createdAt: json['createdAt'] as String,
  favoriteLanguages: (json['favoriteLanguages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  keyboardLayout: json['keyboardLayout'] as String?,
  keyboardBrand: json['keyboardBrand'] as String?,
  keyboardModel: json['keyboardModel'] as String?,
  favoriteQuote: json['favoriteQuote'] as String?,
  favoriteProgrammer: json['favoriteProgrammer'] as String?,
  platform: json['platform'] as String?,
  operatingSystemVersion: json['operatingSystemVersion'] as String?,
  deviceModel: json['deviceModel'] as String?,
);

Map<String, dynamic> _$ProfileDtoToJson(_ProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'createdAt': instance.createdAt,
      'favoriteLanguages': instance.favoriteLanguages,
      'keyboardLayout': instance.keyboardLayout,
      'keyboardBrand': instance.keyboardBrand,
      'keyboardModel': instance.keyboardModel,
      'favoriteQuote': instance.favoriteQuote,
      'favoriteProgrammer': instance.favoriteProgrammer,
      'platform': instance.platform,
      'operatingSystemVersion': instance.operatingSystemVersion,
      'deviceModel': instance.deviceModel,
    };
