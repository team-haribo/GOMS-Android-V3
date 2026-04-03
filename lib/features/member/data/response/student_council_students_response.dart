import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/member/domain/entities/student_council_student_entity.dart';

class StudentCouncilStudentsResponse {
  const StudentCouncilStudentsResponse({
    required this.students,
  });

  factory StudentCouncilStudentsResponse.fromJson(Map<String, dynamic> json) {
    final students = json['students'] as List<dynamic>? ?? const [];

    return StudentCouncilStudentsResponse(
      students: students
          .whereType<Map<String, dynamic>>()
          .map(StudentCouncilStudentResponse.fromJson)
          .toList(),
    );
  }

  final List<StudentCouncilStudentResponse> students;

  List<StudentCouncilStudentEntity> toEntity() {
    return students.map((student) => student.toEntity()).toList();
  }
}

class StudentCouncilStudentResponse {
  const StudentCouncilStudentResponse({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.studentRole,
  });

  factory StudentCouncilStudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentCouncilStudentResponse(
      memberId: _asInt(json['memberId'] ?? json['id']),
      name: json['name'] as String? ?? '',
      grade: _asInt(json['grade']),
      department: json['department'] as String? ?? '',
      studentRole: _toStudentRole(json),
    );
  }

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final StudentRole studentRole;

  StudentCouncilStudentEntity toEntity() {
    return StudentCouncilStudentEntity(
      memberId: memberId,
      name: name,
      grade: grade,
      department: department,
      studentRole: studentRole,
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static StudentRole _toStudentRole(Map<String, dynamic> json) {
    final role = (json['role'] ?? json['studentRole']) as String?;
    final status = (json['status'] ?? json['outingStatus']) as String?;
    final outingAllowed = json['outingAllowed'];

    if (role == 'ROLE_STUDENT_COUNCIL' || role == 'ROLE_ADMIN') {
      return StudentRole.council;
    }

    if (status == 'CANNOT_OUTING' || outingAllowed == false) {
      return StudentRole.outingBanned;
    }

    return StudentRole.student;
  }
}
