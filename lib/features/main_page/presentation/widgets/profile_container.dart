import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/main_page/presentation/widgets/outing_status.dart';
import 'package:goms/features/main_page/presentation/widgets/time_display.dart';
import 'package:goms/features/my_page/presentation/viewmodels/settings_provider.dart';

class ProfileContainer extends ConsumerStatefulWidget {
  final String name;
  final int grade;
  final String major;
  final int lateCount;
  final OutingStatus status;

  const ProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.lateCount,
    required this.status,
  });

  @override
  ConsumerState<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends ConsumerState<ProfileContainer> {
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final showClock = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value.showClock,
      _ => false,
    };

    return Container(
      height: 84,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isLight ? AppColors.bgSurface : AppColors.bgSurfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Row(
          children: [
            if (!showClock) ...[
              Container(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 26,
                  child: AppIcons.profileCircle(),
                ),
              ),
            ],
            if (!showClock) ...[AppGap.h12],
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
                                ? AppColors.mainText
                                : AppColors.mainTextDark,
                          ),
                        ),
                        AppGap.h8,
                        Text(
                          '${widget.grade}기 | ${widget.major}과',
                          style: AppTextStyles.caption1.copyWith(
                            color:
                                isLight ? AppColors.sub2 : AppColors.sub2Dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '지각 횟수: ${widget.lateCount}회',
                    style: AppTextStyles.text3.copyWith(
                      color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s16),
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
                  if (showClock) ...[
                    AppGap.v2,
                    const Flexible(
                      child: TimeDisplay(),
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



