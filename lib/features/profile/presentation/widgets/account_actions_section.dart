import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goms_design_system/goms_design_system.dart';

/// 마이페이지 계정 관련 액션 묶음 (Figma 569-10190)
class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({
    super.key,
    required this.onTapResetPassword,
    required this.onTapLogout,
    required this.onTapDeleteAccount,
  });

  final VoidCallback onTapResetPassword;
  final VoidCallback onTapLogout;
  final VoidCallback onTapDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final mainText = context.mainTextColor;
    return Column(
      children: [
        _AccountActionRow(
          icon: AppIcons.setting(width: 24.r, height: 24.r, color: mainText),
          title: '비밀번호 재설정',
          titleColor: mainText,
          onTap: onTapResetPassword,
        ),
        SizedBox(height: 16.h),
        _AccountActionRow(
          icon: AppIcons.logout(
            width: 24.r,
            height: 24.r,
            color: AppColors.negative,
          ),
          title: '로그아웃',
          titleColor: AppColors.negative,
          onTap: onTapLogout,
        ),
        SizedBox(height: 16.h),
        _AccountActionRow(
          icon: AppIcons.user(
            width: 24.r,
            height: 24.r,
            color: AppColors.negative,
          ),
          title: '회원탈퇴',
          titleColor: AppColors.negative,
          onTap: onTapDeleteAccount,
        ),
      ],
    );
  }
}

class _AccountActionRow extends StatelessWidget {
  const _AccountActionRow({
    required this.icon,
    required this.title,
    required this.titleColor,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final Color titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            icon,
            SizedBox(width: 4.w),
            Expanded(
              child:
                  Text(title, style: AppTextStyles.text2.withColor(titleColor)),
            ),
            AppIcons.arrow(width: 24.r, height: 24.r, color: context.mainTextColor),
          ],
        ),
      ),
    );
  }
}
