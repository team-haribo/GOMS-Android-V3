// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_outing_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyOutingStatusResponse _$MyOutingStatusResponseFromJson(
        Map<String, dynamic> json) =>
    _MyOutingStatusResponse(
      memberId: (json['memberId'] as num).toInt(),
      status: $enumDecode(_$OutingStatusTypeEnumMap, json['status']),
      name: json['name'] as String,
      grade: (json['grade'] as num).toInt(),
      department: json['department'] as String,
      lateCount: (json['lateCount'] as num).toInt(),
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      profileUrl: json['profileUrl'] as String? ?? '',
    );

Map<String, dynamic> _$MyOutingStatusResponseToJson(
        _MyOutingStatusResponse instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'status': _$OutingStatusTypeEnumMap[instance.status]!,
      'name': instance.name,
      'grade': instance.grade,
      'department': instance.department,
      'lateCount': instance.lateCount,
      'profileImageUrl': instance.profileImageUrl,
      'profileUrl': instance.profileUrl,
    };

const _$OutingStatusTypeEnumMap = {
  OutingStatusType.outing: 'OUTING',
  OutingStatusType.coming: 'COMING',
  OutingStatusType.cannotOuting: 'CANNOT_OUTING',
};
