// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_outing_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyOutingStatusResponse _$MyOutingStatusResponseFromJson(
        Map<String, dynamic> json) =>
    _MyOutingStatusResponse(
      memberId: (json['memberId'] as num).toInt(),
      status: json['status'] as String,
      name: json['name'] as String,
      grade: (json['grade'] as num).toInt(),
      department: json['department'] as String,
    );

Map<String, dynamic> _$MyOutingStatusResponseToJson(
        _MyOutingStatusResponse instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'status': instance.status,
      'name': instance.name,
      'grade': instance.grade,
      'department': instance.department,
    };
