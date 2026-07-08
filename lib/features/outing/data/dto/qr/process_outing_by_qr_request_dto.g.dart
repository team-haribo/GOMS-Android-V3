// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_outing_by_qr_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcessOutingByQrRequestDto _$ProcessOutingByQrRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _ProcessOutingByQrRequestDto(
      uuid: json['uuid'] as String,
      exp: (json['exp'] as num).toInt(),
    );

Map<String, dynamic> _$ProcessOutingByQrRequestDtoToJson(
        _ProcessOutingByQrRequestDto instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'exp': instance.exp,
    };
