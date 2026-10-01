import 'package:flutter/material.dart';
import 'package:goms/core/utils/student_info_formatter.dart';
import 'package:goms/core/enums/student_role_enum.dart';
import 'package:goms/features/outing/presentation/widgets/user_role_bottom_sheet.dart';
import 'package:goms_design_system/goms_design_system.dart';

// AdminBottomSheet eliminated — inlined as UserRoleBottomSheet(maxHeightRatio: 1)

class AdminOutingStateContainer extends StatefulWidget {
  final int memberId;
  final String name;
  final int grade;
  final String major;
  final StudentRole studentRole;
  final String profileImageUrl;
  final String status;

  const AdminOutingStateContainer({
    super.key,
    required this.memberId,
    required this.name,
    required this.grade,
    required this.major,
    required this.studentRole,
    required this.profileImageUrl,
    required this.status,
  });

  @override
  State<AdminOutingStateContainer> createState() =>
      _AdminOutingStateContainerState();
}

class _AdminOutingStateContainerState extends State<AdminOutingStateContainer> {
  late StudentRole _studentRole;
  late String _status;

  @override
  void initState() {
    super.initState();
    _studentRole = widget.studentRole;
    _status = widget.status;
  }

  // 목록이 갱신돼 상위에서 새 값이 내려오면 로컬 편집 상태를 버리고 따라간다.
  @override
  void didUpdateWidget(covariant AdminOutingStateContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentRole != widget.studentRole) {
      _studentRole = widget.studentRole;
    }
    if (oldWidget.status != widget.status) {
      _status = widget.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentRole = _studentRole;

    return Container(
      color: context.backgroundColor,
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: studentRole == StudentRole.council
                      ? AppColors.admin
                      : studentRole == StudentRole.outingBanned
                          ? AppColors.negative
                          : Colors.transparent,
                  width: 4,
                ),
              ),
              child: ProfileAvatar(
                radius: studentRole == StudentRole.outingBanned ||
                        studentRole == StudentRole.council
                    ? 22
                    : 24,
                imageUrl: widget.profileImageUrl,
                backgroundColor: context.surfaceColor,
              ),
            ),
          ),
          AppGap.v4,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: AppTextStyles.text1.copyWith(
                  color: studentRole == StudentRole.outingBanned
                      ? AppColors.negative
                      : studentRole == StudentRole.council
                          ? AppColors.admin
                          : context.sub1Color,
                ),
              ),
              AppGap.h4,
              Text(
                StudentInfoFormatter.formatCohortDepartment(
                  grade: widget.grade,
                  department: widget.major,
                ),
                style: AppTextStyles.caption2.copyWith(
                  color: context.sub2Color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  backgroundColor: context.surfaceColor,
                  builder: (context) => UserRoleBottomSheet(
                    memberId: widget.memberId,
                    studentRole: studentRole,
                    status: _status,
                    maxHeightRatio: 1,
                    onRoleChanged: (newRole) =>
                        setState(() => _studentRole = newRole),
                    onStatusChanged: (newStatus) =>
                        setState(() => _status = newStatus),
                  ),
                );
              },
              icon: AppIcons.tablerEdit(
                color: context.sub2Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
