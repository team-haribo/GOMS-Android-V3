import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_layout.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';

class LateProfileContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;

  const LateProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 133,
      width: 101,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 28, child: AppIcons.profileCircle()),
              ],
            ),
            AppGap.v8, // 12 -> 8
            Text(
              name,
              style: AppTextStyles.title1.copyWith(
                color: AppColors.sub1,
                fontSize: 16,
              ),
            ),
            AppGap.v2, // 4 -> 2
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$grade기 | $major',
                style: AppTextStyles.caption1.copyWith(color: AppColors.sub2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
