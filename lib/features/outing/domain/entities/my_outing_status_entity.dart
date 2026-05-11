import 'package:flutter/foundation.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

@immutable
class MyOutingStatusEntity {
  const MyOutingStatusEntity({
    required this.memberId,
    required this.status,
    required this.name,
    required this.grade,
    required this.department,
    this.profileImageUrl = '',
    this.lateCount = 0,
  });

  final int memberId;
  final OutingStatusType status;
  final String name;
  final int grade;
  final String department;
  final String profileImageUrl;
  final int lateCount;
}
