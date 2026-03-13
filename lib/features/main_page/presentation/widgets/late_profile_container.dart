import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

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
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 140,
      width: 101,
      decoration: BoxDecoration(
        color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12, horizontal: AppSpacing.s20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                CircleAvatar(radius: 28, child: AppIcons.profileCircle()),

            AppGap.v8, // 12 -> 8
            Text(
              name,
              style: AppTextStyles.title1.copyWith(
                color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                fontSize: 16,
              ),
            ),
            AppGap.v2, // 4 -> 2
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$grade기 | $major',
                style: AppTextStyles.caption1.copyWith(color: isLight ? AppColors.sub2 : AppColors.sub2Dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
