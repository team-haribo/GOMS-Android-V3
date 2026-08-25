import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/features/member/domain/entities/current_member_entity.dart';
import 'package:goms/features/member/presentation/providers/current_member_provider.dart';
import 'package:goms/features/outing/presentation/providers/my_outing_status_provider.dart';
import 'package:goms/features/profile/presentation/providers/profile_actions_provider.dart';
import 'package:goms_design_system/goms_design_system.dart';

/// 마이페이지 상단 프로필 카드 (Figma 569-10152)
class ProfileSummarySection extends ConsumerWidget {
  const ProfileSummarySection({super.key, required this.onTapProfileImage});

  final VoidCallback onTapProfileImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final member = switch (ref.watch(currentMemberProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final lateCount = switch (ref.watch(myOutingStatusProvider)) {
      AsyncData(:final value) => value.lateCount,
      _ => null,
    };
    final isUploadingProfileImage = ref.watch(profileActionsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTapProfileImage,
          child: SizedBox(
            width: 64.r,
            height: 64.r,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ProfileAvatar(
                  radius: 32.r,
                  imageUrl: member?.profileImageUrl ?? '',
                  backgroundColor: context.surfaceColor,
                ),
                if (isUploadingProfileImage)
                  Positioned.fill(
                    child: Center(
                      child: SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child:
                            const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: -4.w,
                  child: role == RoleEnum.admin
                      ? AppIcons.adminEdit(width: 24.r, height: 24.r)
                      : AppIcons.edit(width: 24.r, height: 24.r),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member?.name ?? '정보 없음',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title3.withColor(context.mainTextColor),
              ),
              SizedBox(height: 4.h),
              Text(
                _buildStudentInfoText(member),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption1.withColor(context.sub2Color),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('지각 횟수', style: AppTextStyles.text2.withColor(context.sub2Color)),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                style: AppTextStyles.title3,
                children: [
                  TextSpan(
                    text: lateCount == null ? '-' : '$lateCount',
                    style: AppTextStyles.title3.withColor(AppColors.negative),
                  ),
                  WidgetSpan(child: SizedBox(width: 2.w)),
                  TextSpan(
                    text: '번',
                    style:
                        AppTextStyles.title3.withColor(context.mainTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _buildStudentInfoText(CurrentMemberEntity? member) {
    final grade = member?.grade;
    final major = member?.department.name.toUpperCase();
    final gradeText = grade == null ? '-' : '$grade기';
    final majorText = (major == null || major.isEmpty) ? '-' : '$major과';
    return '$gradeText | $majorText';
  }
}
