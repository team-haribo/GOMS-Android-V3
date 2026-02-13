import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_icons.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
import 'package:project_setting/presentation/widget/outing_status.dart';
import 'package:project_setting/presentation/widget/time_display.dart';

bool isLight = true;

class ProfileContainer extends StatefulWidget {
  final String name;
  final int grade;
  final String major;
  final int lateCount;
  final OutingStatus status;
  final bool onTime;

  const ProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.lateCount,
    required this.status,
    required this.onTime,
  });

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (widget.onTime) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 26,
                  child: AppIcons.profileCircle(),
                ),
              ),
            ],
            if (widget.onTime) ...[const SizedBox(width: 12)],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Text(
                          widget.name,
                          style: AppTextStyles.title3.copyWith(
                            color: isLight
                                ? AppColors.mainColor
                                : AppColors.background,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.grade}기 | ${widget.major}과',
                          style: AppTextStyles.caption1.copyWith(
                            color: isLight
                                ? AppColors.button
                                : AppColors.sub2Dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '지각횟수: ${widget.lateCount}회',
                    style: AppTextStyles.text3.copyWith(
                      color: isLight ? AppColors.sub2 : AppColors.sub1Dark,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.status.statusText,
                    style: AppTextStyles.text1.copyWith(
                      color: widget.status.statusColor,
                    ),
                  ),
                  if (!widget.onTime) ...[
                    Flexible(
                      child: TimeDisplay(
                        style: AppTextStyles.heavy,
                        color: isLight ? AppColors.button : AppColors.sub2Dark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
