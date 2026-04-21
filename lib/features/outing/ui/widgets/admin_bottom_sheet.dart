import 'package:flutter/material.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/outing/ui/widgets/user_role_bottomsheet.dart';

class AdminBottomSheet extends StatelessWidget {
  const AdminBottomSheet({
    super.key,
    required this.memberId,
    required this.studentRole,
    required this.status,
    required this.onRoleChanged,
    required this.onStatusChanged,
  });

  final int memberId;
  final StudentRole studentRole;
  final String status;
  final ValueChanged<StudentRole> onRoleChanged;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return UserRoleBottomSheet(
      memberId: memberId,
      studentRole: studentRole,
      status: status,
      onRoleChanged: onRoleChanged,
      onStatusChanged: onStatusChanged,
      maxHeightRatio: 1,
    );
  }
}
