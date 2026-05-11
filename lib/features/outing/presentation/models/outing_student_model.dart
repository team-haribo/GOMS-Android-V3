import 'package:flutter/foundation.dart';

@immutable
class OutingStudentModel {
  const OutingStudentModel({
    required this.memberId,
    required this.name,
    required this.grade,
    required this.department,
    required this.outingAt,
    this.profileImageUrl = '',
  });

  final int memberId;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final DateTime outingAt;
}
