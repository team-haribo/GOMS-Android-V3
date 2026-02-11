import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
import 'package:project_setting/presentation/widget/time_display.dart';

enum OutingStatus { waiting, approved, rejected, admin }

class ProfileContainer extends StatefulWidget {
  final String name;
  final String grade;
  final String major;
  final String lateCount;
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
  String _getStatusText() {
    switch (widget.status) {
      case OutingStatus.waiting:
        return '외출 대기 중';
      case OutingStatus.approved:
        return '외출중';
      case OutingStatus.rejected:
        return '외출 금지';
      case OutingStatus.admin:
        return '학생회';
    }
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case OutingStatus.waiting:
        return AppColors.textSecondaryDark;
      case OutingStatus.approved:
        return AppColors.primary;
      case OutingStatus.rejected:
        return AppColors.negative;
      case OutingStatus.admin:
        return AppColors.admin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: 312,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            widget.onTime
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 26,
                      child: SvgPicture.asset(
                        'assets/icons/profile_circle.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            widget.onTime ? const SizedBox(width: 12) : const SizedBox.shrink(),
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
                            color: AppColors.background,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.grade}기 | ${widget.major}과',
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '지각횟수: ${widget.lateCount}회',
                    style: AppTextStyles.text3.copyWith(
                      color: AppColors.textSecondaryDark,
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
                    _getStatusText(),
                    style: AppTextStyles.text1.copyWith(
                      color: _getStatusColor(),
                    ),
                  ),
                  Flexible(
                    child: widget.onTime
                        ? const SizedBox.shrink()
                        : TimeDisplay(
                            onTime: widget.onTime,
                            style: AppTextStyles.heavy,
                            color: AppColors.textTertiaryDark,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
