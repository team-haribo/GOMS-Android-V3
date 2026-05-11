import 'package:flutter/foundation.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';

@immutable
class StudentCouncilStudentModel {
  const StudentCouncilStudentModel({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.studentRole,
    this.profileImageUrl = '',
    this.role = '',
    this.status = '',
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final StudentRole studentRole;
  final String profileImageUrl;
  final String role;
  final String status;

  StudentCouncilStudentModel copyWith({
    int? memberId,
    String? name,
    int? grade,
    String? department,
    StudentRole? studentRole,
    String? profileImageUrl,
    String? role,
    String? status,
  }) {
    return StudentCouncilStudentModel(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      department: department ?? this.department,
      studentRole: studentRole ?? this.studentRole,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StudentCouncilStudentModel &&
            runtimeType == other.runtimeType &&
            memberId == other.memberId &&
            name == other.name &&
            grade == other.grade &&
            department == other.department &&
            studentRole == other.studentRole &&
            profileImageUrl == other.profileImageUrl &&
            role == other.role &&
            status == other.status;
  }

  @override
  int get hashCode => Object.hash(
    memberId,
    name,
    grade,
    department,
    studentRole,
    profileImageUrl,
    role,
    status,
  );
}
