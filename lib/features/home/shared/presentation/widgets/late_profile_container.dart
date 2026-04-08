import 'package:flutter/material.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/common/profile_avatar.dart';

class LateProfileContainer extends StatelessWidget {
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;

  const LateProfileContainer({
    super.key,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 101,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s12,
          horizontal: AppSpacing.s20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              radius: 28,
              imageUrl: profileImageUrl,
              backgroundColor: context.backgroundColor,
            ),

            AppGap.v8, // 12 -> 8
            Text(
              name,
              style: AppTextStyles.title1.copyWith(
                color: context.sub1Color,
                fontSize: 16,
              ),
            ),
            AppGap.v2, // 4 -> 2
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$grade기 | $major',
                style:
                    AppTextStyles.caption1.copyWith(color: context.sub2Color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
