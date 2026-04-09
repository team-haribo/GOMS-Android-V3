import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/avatars/profile_avatar.dart';

class ProfileListContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const ProfileListContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.backgroundColor,
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ProfileAvatar(
                radius: 14,
                imageUrl: profileImageUrl,
                backgroundColor: context.surfaceColor,
              ),
              AppGap.h8,
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
            ],
          ),
          Text(
            '$grade기 | $major',
            style: AppTextStyles.caption2.copyWith(
              color: context.sub2Color,
            ),
          ),
        ],
      ),
    );
  }
}
