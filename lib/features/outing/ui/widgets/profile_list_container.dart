import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/utils/student_info_formatter.dart';

class ProfileListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const ProfileListContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.backgroundColor,
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ProfileAvatar(
                radius: 14,
                imageUrl: profileImageUrl,
                backgroundColor: context.surfaceColor,
              ),
              AppGap.h8,
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
            ],
          ),
          Text(
            StudentInfoFormatter.formatCohortDepartment(
              grade: grade,
              department: major,
            ),
            style: AppTextStyles.caption2.copyWith(
              color: context.sub2Color,
            ),
          ),
        ],
      ),
    );
  }
}
