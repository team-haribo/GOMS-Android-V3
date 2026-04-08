import 'package:flutter/material.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: surfaceColor,
                    child: profileImageUrl.trim().isEmpty
                        ? ClipOval(
                            child:
                                AppIcons.profileCircle(width: 72, height: 72),
                          )
                        : ClipOval(
                            child: Image.network(
                              profileImageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return AppIcons.profileCircle(
                                  width: 72,
                                  height: 72,
                                );
                              },
                            ),
                          ),
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
        AppGap.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.title3.withColor(textColor)),
              AppGap.v4,
              Text(
                _buildStudentInfoText(),
                style: AppTextStyles.caption1.withColor(subColor),
              ),
            ],
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('지각 횟수', style: AppTextStyles.text2.withColor(subColor)),
            AppGap.v4,
            Text(
              lateCount == null ? '-' : '$lateCount번',
              style: AppTextStyles.title3.withColor(AppColors.negative),
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
