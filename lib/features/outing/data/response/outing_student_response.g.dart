// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outing_student_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OutingStudentResponse _$OutingStudentResponseFromJson(
        Map<String, dynamic> json) =>
    _OutingStudentResponse(
      memberId: (json['memberId'] as num).toInt(),
      name: json['name'] as String,
      grade: (json['grade'] as num).toInt(),
      department: json['department'] as String,
      outingAt: DateTime.parse(json['outingAt'] as String),
    );

Map<String, dynamic> _$OutingStudentResponseToJson(
        _OutingStudentResponse instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'name': instance.name,
      'grade': instance.grade,
      'department': instance.department,
      'outingAt': instance.outingAt.toIso8601String(),
    };
