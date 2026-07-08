// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_outing_students_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CurrentOutingStudentsResponse _$CurrentOutingStudentsResponseFromJson(
        Map<String, dynamic> json) =>
    _CurrentOutingStudentsResponse(
      students: (json['students'] as List<dynamic>)
          .map((e) => OutingStudentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrentOutingStudentsResponseToJson(
        _CurrentOutingStudentsResponse instance) =>
    <String, dynamic>{
      'students': instance.students,
    };
