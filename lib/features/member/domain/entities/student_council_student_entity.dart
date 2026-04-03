import 'package:goms/features/home/domain/enums/student_role_enum.dart';

class StudentCouncilStudentEntity {
  const StudentCouncilStudentEntity({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.studentRole,
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final StudentRole studentRole;
}
