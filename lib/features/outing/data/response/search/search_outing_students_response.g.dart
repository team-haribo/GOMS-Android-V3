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
