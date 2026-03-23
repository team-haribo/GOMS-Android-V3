import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
class LateProfileListContainer extends StatefulWidget {
  final String name;
  final int grade;
  final String major;

  const LateProfileListContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
  });

  @override
  State<LateProfileListContainer> createState() => _LateProfileListContainerState();
}

class _LateProfileListContainerState extends State<LateProfileListContainer> {
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      color: isLight ? AppColors.background : AppColors.backgroundDark,
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              radius: 24,
              child: AppIcons.profileCircle(),
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
                  color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    '${widget.grade}기 | ${widget.major}',
                    style: AppTextStyles.caption2.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
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
