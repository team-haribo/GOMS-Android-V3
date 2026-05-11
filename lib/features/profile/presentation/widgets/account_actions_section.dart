import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({
    super.key,
    required this.textColor,
    required this.rowVerticalPadding,
    required this.onTapResetPassword,
    required this.onTapLogout,
    required this.onTapDeleteAccount,
  });

  final Color textColor;
  final double rowVerticalPadding;
  final VoidCallback onTapResetPassword;
  final VoidCallback onTapLogout;
  final VoidCallback onTapDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AccountActionRow(
          icon: AppIcons.setting(color: textColor),
          title: '비밀번호 재설정',
          textColor: textColor,
          verticalPadding: rowVerticalPadding,
          onTap: onTapResetPassword,
        ),
        _AccountActionRow(
          icon: AppIcons.forcedOuting(color: AppColors.negative),
          title: '로그아웃',
          textColor: AppColors.negative,
          chevronColor: textColor,
          verticalPadding: rowVerticalPadding,
          onTap: onTapLogout,
        ),
        _AccountActionRow(
          icon: AppIcons.logout(color: AppColors.negative),
          title: '회원탈퇴',
          textColor: AppColors.negative,
          chevronColor: textColor,
          verticalPadding: rowVerticalPadding,
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
    required this.textColor,
    required this.verticalPadding,
    required this.onTap,
    this.chevronColor,
  });

  final Widget icon;
  final String title;
  final Color textColor;
  final double verticalPadding;
  final VoidCallback onTap;
  final Color? chevronColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          children: [
            icon is Icon
                ? Icon(
                    (icon as Icon).icon,
                    size: 24,
                    color: textColor,
                  )
                : icon,
            AppGap.h8,
            Expanded(
              child:
                  Text(title, style: AppTextStyles.text2.withColor(textColor)),
            ),
            AppIcons.arrow(color: chevronColor ?? textColor),
          ],
        ),
      ),
    );
  }
}
