import 'package:flutter/material.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms_design_system/goms_design_system.dart';

class ProfileSummarySection extends StatelessWidget {
  const ProfileSummarySection({
    super.key,
    required this.role,
    required this.name,
    required this.profileImageUrl,
    required this.onTapProfileImage,
    required this.isUploadingProfileImage,
    this.grade,
    this.major,
    this.lateCount,
    required this.textColor,
    required this.subColor,
    required this.surfaceColor,
    this.isCompact = false,
  });

  final RoleEnum role;
  final String name;
  final String profileImageUrl;
  final VoidCallback onTapProfileImage;
  final bool isUploadingProfileImage;
  final int? grade;
  final String? major;
  final int? lateCount;
  final Color textColor;
  final Color subColor;
  final Color surfaceColor;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = isCompact ? 30.0 : 36.0;
    final infoSpacing = isCompact ? AppGap.h12 : AppGap.h16;
    final lateCountSpacing = isCompact ? AppGap.h8 : AppGap.h12;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: onTapProfileImage,
              child: Stack(
                children: [
                  ProfileAvatar(
                    radius: avatarRadius,
                    imageUrl: profileImageUrl,
                    backgroundColor: surfaceColor,
                  ),
                  if (isUploadingProfileImage)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: role == RoleEnum.admin
                  ? AppIcons.adminEdit()
                  : AppIcons.edit(),
            ),
          ],
        ),
        infoSpacing,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title3.withColor(textColor),
              ),
              AppGap.v4,
              Text(
                _buildStudentInfoText(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption1.withColor(subColor),
              ),
            ],
          ),
        ),
        lateCountSpacing,
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('지각 횟수', style: AppTextStyles.text2.withColor(subColor)),
            AppGap.v4,
            RichText(
              text: TextSpan(
                style: AppTextStyles.title3,
                children: [
                  TextSpan(
                    text: lateCount == null ? '-' : '$lateCount',
                    style: AppTextStyles.title3.withColor(AppColors.negative),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '번',
                    style: AppTextStyles.title3.withColor(
                      context.mainTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _buildStudentInfoText() {
    final gradeText = grade == null ? '-' : '$grade기';
    final majorText = (major == null || major!.isEmpty) ? '-' : '$major과';
    return '$gradeText | $majorText';
  }
}
