// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_council_students_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCouncilStudentsResponse _$StudentCouncilStudentsResponseFromJson(
        Map<String, dynamic> json) =>
    StudentCouncilStudentsResponse(
      students: json['students'] == null
          ? []
          : _studentsFromJson(json['students'] as List?),
    );

StudentCouncilStudentResponse _$StudentCouncilStudentResponseFromJson(
        Map<String, dynamic> json) =>
    StudentCouncilStudentResponse(
      memberId:
          StudentCouncilStudentResponse._asInt(_readMemberId(json, 'memberId')),
      name: json['name'] == null
          ? ''
          : StudentCouncilStudentResponse._asString(json['name']),
      grade: json['grade'] == null
          ? 0
          : StudentCouncilStudentResponse._asInt(json['grade']),
      department: json['department'] == null
          ? ''
          : StudentCouncilStudentResponse._asString(json['department']),
      profileImageUrl: _readProfileImageUrl(json, 'profileImageUrl') == null
          ? ''
          : StudentCouncilStudentResponse._asString(
              _readProfileImageUrl(json, 'profileImageUrl')),
      role: _readRole(json, 'role') == null
          ? ''
          : StudentCouncilStudentResponse._asString(_readRole(json, 'role')),
      status: _readStatus(json, 'status') == null
          ? ''
          : StudentCouncilStudentResponse._asString(
              _readStatus(json, 'status')),
      studentRole: _studentRoleFromJson(_readStudentRole(json, 'studentRole')),
    );
