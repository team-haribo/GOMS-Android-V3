// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_coming_by_qr_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProcessComingByQrResponse _$ProcessComingByQrResponseFromJson(
        Map<String, dynamic> json) =>
    _ProcessComingByQrResponse(
      action: $enumDecode(_$OutingActionEnumMap, json['action']),
      outingId: (json['outingId'] as num).toInt(),
      status: $enumDecode(_$OutingStatusTypeEnumMap, json['status']),
      comingAt: DateTime.parse(json['comingAt'] as String),
      lateCreated: json['lateCreated'] as bool,
      lateId: (json['lateId'] as num).toInt(),
    );

Map<String, dynamic> _$ProcessComingByQrResponseToJson(
        _ProcessComingByQrResponse instance) =>
    <String, dynamic>{
      'action': _$OutingActionEnumMap[instance.action]!,
      'outingId': instance.outingId,
      'status': _$OutingStatusTypeEnumMap[instance.status]!,
      'comingAt': instance.comingAt.toIso8601String(),
      'lateCreated': instance.lateCreated,
      'lateId': instance.lateId,
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
