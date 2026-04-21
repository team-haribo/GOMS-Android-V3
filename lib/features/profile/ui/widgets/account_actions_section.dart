import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({
    super.key,
    required this.textColor,
    required this.onTapResetPassword,
    required this.onTapLogout,
    required this.onTapDeleteAccount,
  });

  final Color textColor;
  final VoidCallback onTapResetPassword;
  final VoidCallback onTapLogout;
  final VoidCallback onTapDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AccountActionRow(
          icon: AppIcons.setting(),
          title: '비밀번호 재설정',
          textColor: textColor,
          onTap: onTapResetPassword,
        ),
        _AccountActionRow(
          icon: AppIcons.forcedOuting(),
          title: '로그아웃',
          textColor: AppColors.negative,
          chevronColor: textColor,
          onTap: onTapLogout,
        ),
        _AccountActionRow(
          icon: AppIcons.logout(),
          title: '회원탈퇴',
          textColor: AppColors.negative,
          chevronColor: textColor,
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
    required this.onTap,
    this.chevronColor,
  });

  final Widget icon;
  final String title;
  final Color textColor;
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
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
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
            AppIcons.arrow(),
          ],
        ),
      ),
    );
  }
}
