import 'package:flutter/material.dart';
import 'package:goms/features/home/domain/enums/student_role_enum.dart';
import 'package:goms/features/outing/ui/widgets/user_role_bottomsheet.dart';

class AdminBottomSheet extends StatelessWidget {
  const AdminBottomSheet({
    super.key,
    required this.memberId,
    required this.studentRole,
    required this.onRoleChanged,
  });

  final int memberId;
  final StudentRole studentRole;
  final ValueChanged<StudentRole> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return UserRoleBottomSheet(
      memberId: memberId,
      studentRole: studentRole,
      onRoleChanged: onRoleChanged,
      maxHeightRatio: 1,
    );
  }
}
