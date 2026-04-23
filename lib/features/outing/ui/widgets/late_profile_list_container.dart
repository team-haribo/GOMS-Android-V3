import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/utils/student_info_formatter.dart';
import 'package:goms/core/widgets/avatars/profile_avatar.dart';

class LateProfileListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const LateProfileListContainer({
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
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ProfileAvatar(
              radius: 24,
              imageUrl: profileImageUrl,
              backgroundColor: context.surfaceColor,
            ),
          ),
          AppGap.v4,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
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
            ],
          ),
        ],
      ),
    );
  }
}
