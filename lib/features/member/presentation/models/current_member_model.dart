import 'package:flutter/foundation.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

@immutable
class CurrentMemberModel {
  const CurrentMemberModel({
    required this.memberId,
    required this.email,
    required this.name,
    required this.role,
    this.grade = 0,
    this.department = DepartmentType.sw,
    this.gender = GenderType.male,
    this.status = OutingStatusType.coming,
    this.profileImageUrl = '',
  });

  final int memberId;
  final String email;
  final String name;
  final RoleEnum role;
  final int grade;
  final DepartmentType department;
  final GenderType gender;
  final OutingStatusType status;
  final String profileImageUrl;

  CurrentMemberModel copyWith({
    int? memberId,
    String? email,
    String? name,
    RoleEnum? role,
    int? grade,
    DepartmentType? department,
    GenderType? gender,
    OutingStatusType? status,
    String? profileImageUrl,
  }) {
    return CurrentMemberModel(
      memberId: memberId ?? this.memberId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      grade: grade ?? this.grade,
      department: department ?? this.department,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CurrentMemberModel &&
            runtimeType == other.runtimeType &&
            memberId == other.memberId &&
            email == other.email &&
            name == other.name &&
            role == other.role &&
            grade == other.grade &&
            department == other.department &&
            gender == other.gender &&
            status == other.status &&
            profileImageUrl == other.profileImageUrl;
  }

  @override
  int get hashCode => Object.hash(
    memberId,
    email,
    name,
    role,
    grade,
    department,
    gender,
    status,
    profileImageUrl,
  );
}
