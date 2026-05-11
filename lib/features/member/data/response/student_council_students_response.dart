import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:goms/features/member/presentation/models/student_council_student_model.dart';

part 'student_council_students_response.g.dart';

@JsonSerializable(createToJson: false)
class StudentCouncilStudentsResponse {
  const StudentCouncilStudentsResponse({
    required this.students,
  });

  factory StudentCouncilStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentCouncilStudentsResponseFromJson(json);

  @JsonKey(
    defaultValue: <StudentCouncilStudentResponse>[],
    fromJson: _studentsFromJson,
  )
  final List<StudentCouncilStudentResponse> students;

  List<StudentCouncilStudentModel> toModel() {
    return students.map((student) => student.toModel()).toList();
  }
}

@JsonSerializable(createToJson: false)
class StudentCouncilStudentResponse {
  const StudentCouncilStudentResponse({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.profileImageUrl,
    required this.role,
    required this.status,
    required this.studentRole,
  });

  factory StudentCouncilStudentResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentCouncilStudentResponseFromJson(json);

  @JsonKey(readValue: _readMemberId, fromJson: _asInt)
  final int memberId;

  @JsonKey(defaultValue: '', fromJson: _asString)
  final String name;

  @JsonKey(defaultValue: 0, fromJson: _asInt)
  final int grade;

  @JsonKey(defaultValue: '', fromJson: _asString)
  final String department;

  @JsonKey(
    readValue: _readProfileImageUrl,
    defaultValue: '',
    fromJson: _asString,
  )
  final String profileImageUrl;

  @JsonKey(readValue: _readRole, defaultValue: '', fromJson: _asString)
  final String role;

  @JsonKey(readValue: _readStatus, defaultValue: '', fromJson: _asString)
  final String status;

  @JsonKey(readValue: _readStudentRole, fromJson: _studentRoleFromJson)
  final StudentRole studentRole;

  StudentCouncilStudentModel toModel() {
    return StudentCouncilStudentModel(
      memberId: memberId,
      name: name,
      grade: grade,
      department: department,
      profileImageUrl: profileImageUrl,
      role: role,
      status: status,
      studentRole: studentRole,
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  static String _asString(Object? value) {
    return value as String? ?? '';
  }

  static StudentRole _toStudentRole({
    required String role,
    required String status,
    required Object? outingAllowed,
  }) {
    if (role == 'ROLE_STUDENT_COUNCIL' || role == 'ROLE_ADMIN') {
      return StudentRole.council;
    }

    if (status == 'CANNOT_OUTING' || outingAllowed == false) {
      return StudentRole.outingBanned;
    }

    return StudentRole.student;
  }
}

List<StudentCouncilStudentResponse> _studentsFromJson(List<dynamic>? values) =>
    (values ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(StudentCouncilStudentResponse.fromJson)
        .toList(growable: false);

Object? _readMemberId(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['id'];

Object? _readProfileImageUrl(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['profileUrl'];

Object? _readRole(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['studentRole'];

Object? _readStatus(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['outingStatus'];

Object? _readStudentRole(Map<dynamic, dynamic> json, String key) =>
    <String, Object?>{
      'role': _readRole(json, 'role'),
      'status': _readStatus(json, 'status'),
      'outingAllowed': json['outingAllowed'],
    };

StudentRole _studentRoleFromJson(Object? value) {
  if (value is! Map) {
    return StudentRole.student;
  }

  return StudentCouncilStudentResponse._toStudentRole(
    role: StudentCouncilStudentResponse._asString(value['role']),
    status: StudentCouncilStudentResponse._asString(value['status']),
    outingAllowed: value['outingAllowed'],
  );
}
