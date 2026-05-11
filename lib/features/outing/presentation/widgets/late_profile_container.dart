import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/utils/student_info_formatter.dart';

class LateProfileContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const LateProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 101,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s12,
          horizontal: AppSpacing.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              radius: 28,
              imageUrl: profileImageUrl,
              backgroundColor: context.backgroundColor,
            ),

            AppGap.v8, // 12 -> 8
            Text(
              name,
              style: AppTextStyles.title1.copyWith(
                color: context.sub1Color,
                fontSize: 16,
              ),
            ),
            AppGap.v2, // 4 -> 2
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                StudentInfoFormatter.formatCohortDepartment(
                  grade: grade,
                  department: major,
                ),
                style:
                    AppTextStyles.caption1.copyWith(color: context.sub2Color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
