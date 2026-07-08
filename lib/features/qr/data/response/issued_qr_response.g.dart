// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issued_qr_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IssuedQrResponse _$IssuedQrResponseFromJson(Map<String, dynamic> json) =>
    _IssuedQrResponse(
      uuid: json['uuid'] as String,
      exp: (json['exp'] as num).toInt(),
    );

Map<String, dynamic> _$IssuedQrResponseToJson(_IssuedQrResponse instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'exp': instance.exp,
    };
