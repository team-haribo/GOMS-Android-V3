import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class GomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GomsAppBar._back({
    super.key,
    this.onBackPressed,
    this.actions,
  }) : _showLogo = false;

  const GomsAppBar._logo({
    super.key,
    this.actions,
  })  : _showLogo = true,
        onBackPressed = null;

  factory GomsAppBar.logo({Key? key, List<Widget>? actions}) =>
      GomsAppBar._logo(key: key, actions: actions);

  factory GomsAppBar.back({
    Key? key,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
  }) =>
      GomsAppBar._back(
        key: key,
        onBackPressed: onBackPressed,
        actions: actions,
      );

  final bool _showLogo;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: _showLogo
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
      titleSpacing: _showLogo ? 24 : 4,
      title: _showLogo
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
