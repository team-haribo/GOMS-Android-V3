import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_layout.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';

class ProfileListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;

  const ProfileListContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      color: isLight ? AppColors.background : AppColors.backgroundDark,
      height: 44,
      width: 327,
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 14, child: AppIcons.profileCircle()),
              AppGap.h8,
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                ),
              ),
            ],
          ),
          Text(
            '$grade기 | $major',
            style: AppTextStyles.caption2
                .copyWith(color: isLight ? AppColors.sub2 : AppColors.sub2Dark),
          ),
        ],
      ),
    );
  }
}
