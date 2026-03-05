import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';

class GomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GomsAppBar({
    super.key,
    this.showLogo = false,
    this.onBackPressed,
    this.actions,
  });

  /// GOMS 로고 표시 여부
  final bool showLogo;

  /// 뒤로가기 버튼 콜백
  final VoidCallback? onBackPressed;

  /// 우측 액션 버튼들
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: showLogo
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s24),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: AppIcons.back(width: 24, height: 24),
                onPressed: onBackPressed ?? () => context.pop(),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
            ),
      titleSpacing: showLogo ? 24 : 4,
      title: showLogo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcons.logoSmall(
                  color: isDark ? AppColors.sub2Dark : AppColors.button,
                ),
                AppGap.h8,
                Text(
                  'GOMS',
                  style: TextStyle(
                    fontFamily: 'gmarketSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.sub2Dark : AppColors.button,
                  ),
                ),
              ],
            )
          : Text(
              '돌아가기',
              style: AppTextStyles.text2.copyWith(color: AppColors.mainColor),
            ),
      actions: actions,
    );
  }
}
