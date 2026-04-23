import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/utils/student_info_formatter.dart';
import 'package:goms/features/outing/domain/enums/outing_status.dart';
import 'package:goms/features/outing/ui/widgets/time_display.dart';
import 'package:goms/features/profile/ui/providers/settings_provider.dart';
import 'package:goms/core/widgets/avatars/profile_avatar.dart';

class ProfileContainer extends ConsumerWidget {
  final String name;
  final int grade;
  final String major;
  final int lateCount;
  final OutingStatus status;
  final String profileImageUrl;
  final bool showProfileImageErrorMessage;
  final String profileImageErrorMessage;
  final bool showLateCount;
  final bool showInfoBelowName;

  const ProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.lateCount,
    required this.status,
    required this.profileImageUrl,
    this.showProfileImageErrorMessage = false,
    this.profileImageErrorMessage = '프로필 이미지를 불러오지 못했어요.',
    this.showLateCount = true,
    this.showInfoBelowName = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showClock = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value.showClock,
      _ => false,
    };
    final height = showClock
        ? context.responsive(compact: 88, normal: 96, tablet: 104)
        : context.responsive(compact: 76, normal: 84, tablet: 92);

    return Container(
      height: height,
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
              ProfileAvatar(
                radius: context.responsive(compact: 22, normal: 26, tablet: 28),
                imageUrl: profileImageUrl,
                backgroundColor: context.backgroundColor,
                showErrorMessage: showProfileImageErrorMessage,
                errorMessage: profileImageErrorMessage,
              ),
              AppGap.h12,
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIdentity(context, showClock),
                  if (showLateCount)
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

  Widget _buildIdentity(BuildContext context, bool showClock) {
    if (showClock && !showInfoBelowName) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          _buildNameText(context),
          AppGap.h8,
          _buildInfoText(context),
        ],
      );
    }

    if (showInfoBelowName) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameText(context),
          AppGap.v2,
          _buildInfoText(context),
        ],
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          _buildNameText(context),
          AppGap.h8,
          _buildInfoText(context),
        ],
      ),
    );
  }

  Widget _buildNameText(BuildContext context) {
    return Text(
      name,
      style: AppTextStyles.title3.copyWith(
        color: context.mainTextColor,
      ),
    );
  }

  Widget _buildInfoText(BuildContext context) {
    return Text(
      StudentInfoFormatter.formatCohortDepartment(
        grade: grade,
        department: major,
      ),
      style: AppTextStyles.text3.copyWith(
        color: context.sub2Color,
      ),
    );
  }
}
