// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_outing_by_qr_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcessOutingByQrResponse _$ProcessOutingByQrResponseFromJson(
        Map<String, dynamic> json) =>
    _ProcessOutingByQrResponse(
      action: $enumDecode(_$OutingActionEnumMap, json['action']),
      outingId: (json['outingId'] as num).toInt(),
      status: $enumDecode(_$OutingStatusTypeEnumMap, json['status']),
      outingAt: DateTime.parse(json['outingAt'] as String),
    );

Map<String, dynamic> _$ProcessOutingByQrResponseToJson(
        _ProcessOutingByQrResponse instance) =>
    <String, dynamic>{
      'action': _$OutingActionEnumMap[instance.action]!,
      'outingId': instance.outingId,
      'status': _$OutingStatusTypeEnumMap[instance.status]!,
      'outingAt': instance.outingAt.toIso8601String(),
    };

const _$OutingActionEnumMap = {
  OutingAction.out: 'OUT',
  OutingAction.inAction: 'IN',
};

const _$OutingStatusTypeEnumMap = {
  OutingStatusType.outing: 'OUTING',
  OutingStatusType.coming: 'COMING',
  OutingStatusType.cannotOuting: 'CANNOT_OUTING',
};
