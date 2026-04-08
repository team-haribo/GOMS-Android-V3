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
    required this.profileImageUrl,
    required this.role,
    required this.status,
    required this.studentRole,
  });

  factory StudentCouncilStudentResponse.fromJson(Map<String, dynamic> json) {
    final role = _asString(json['role'] ?? json['studentRole']);
    final status = _asString(json['status'] ?? json['outingStatus']);

    return StudentCouncilStudentResponse(
      memberId: _asInt(json['memberId'] ?? json['id']),
      name: _asString(json['name']),
      grade: _asInt(json['grade']),
      department: _asString(json['department']),
      profileImageUrl: _asString(json['profileImageUrl'] ?? json['profileUrl']),
      role: role,
      status: status,
      studentRole: _toStudentRole(
        role: role,
        status: status,
        outingAllowed: json['outingAllowed'],
      ),
    );
  }

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final String role;
  final String status;
  final StudentRole studentRole;

  StudentCouncilStudentEntity toEntity() {
    return StudentCouncilStudentEntity(
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
