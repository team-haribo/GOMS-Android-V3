import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/outing/presentation/models/outing_status.dart';
import 'package:goms/features/home/shared/presentation/widgets/time_display.dart';
import 'package:goms/features/profile/presentation/providers/settings_provider.dart';

class ProfileContainer extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final showClock = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value.showClock,
      _ => false,
    };

    return Container(
      height: context.responsive(compact: 76, normal: 84, tablet: 92),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsive(compact: 12, normal: 16)),
        child: Row(
          children: [
            if (!showClock) ...[
              Container(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius:
                      context.responsive(compact: 22, normal: 26, tablet: 28),
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
                          name,
                          style: AppTextStyles.title3.copyWith(
                            color: context.mainTextColor,
                          ),
                        ),
                        AppGap.h8,
                        Text(
                          '$grade기| $major과',
                          style: AppTextStyles.text3.copyWith(
                            color: context.sub2Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '지각 횟수: $lateCount회',
                    style: AppTextStyles.text3.copyWith(
                      color: context.sub1Color,
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
                    status.statusText,
                    style: AppTextStyles.text1.copyWith(
                      color: status.statusColor,
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
