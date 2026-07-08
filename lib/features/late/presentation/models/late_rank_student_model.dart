import 'package:flutter/foundation.dart';

@immutable
class LateRankStudentModel {
  const LateRankStudentModel({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.profileImageUrl,
    required this.comingAt,
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final DateTime comingAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LateRankStudentModel &&
            runtimeType == other.runtimeType &&
            memberId == other.memberId &&
            name == other.name &&
            grade == other.grade &&
            department == other.department &&
            profileImageUrl == other.profileImageUrl &&
            comingAt == other.comingAt;
  }

  @override
  int get hashCode => Object.hash(
    memberId,
    name,
    grade,
    department,
    profileImageUrl,
    comingAt,
  );
}
