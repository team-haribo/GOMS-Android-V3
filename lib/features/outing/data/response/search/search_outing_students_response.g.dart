// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_outing_students_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchOutingStudentsResponse _$SearchOutingStudentsResponseFromJson(
        Map<String, dynamic> json) =>
    _SearchOutingStudentsResponse(
      students: (json['students'] as List<dynamic>)
          .map((e) => OutingStudentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchOutingStudentsResponseToJson(
        _SearchOutingStudentsResponse instance) =>
    <String, dynamic>{
      'students': instance.students,
    };

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
