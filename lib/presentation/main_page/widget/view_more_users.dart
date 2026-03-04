import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';

class ViewMoreUsers extends StatelessWidget {
  const ViewMoreUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return SizedBox(
      width: 51,
      height: 24,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight ? AppColors.bgSurface : AppColors.bgSurface,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Text(
          "더보기",
          style: AppTextStyles.caption2.copyWith(
            fontWeight: FontWeight.w300,
            color: isLight ? AppColors.sub2 : AppColors.sub1,
          ),
        ),
      ),
    );
  }
}
