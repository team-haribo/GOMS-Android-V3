import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

class MyOutingStatusEntity {
  const MyOutingStatusEntity({
    required this.memberId,
    required this.status,
    required this.name,
    required this.grade,
    required this.department,
  });

  final int memberId;
  final OutingStatusType status;
  final String name;
  final int grade;
  final String department;
}
