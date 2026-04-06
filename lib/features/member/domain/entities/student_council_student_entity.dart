import 'package:goms/features/home/domain/enums/student_role_enum.dart';

class StudentCouncilStudentEntity {
  const StudentCouncilStudentEntity({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.studentRole,
    this.role = '',
    this.status = '',
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final StudentRole studentRole;
  final String role;
  final String status;

  StudentCouncilStudentEntity copyWith({
    int? memberId,
    String? name,
    int? grade,
    String? department,
    StudentRole? studentRole,
    String? role,
    String? status,
  }) {
    return StudentCouncilStudentEntity(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      department: department ?? this.department,
      studentRole: studentRole ?? this.studentRole,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}
