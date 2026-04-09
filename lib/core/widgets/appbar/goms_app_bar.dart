import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/enums/role_enum.dart';

class GomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GomsAppBar._back({
    super.key,
    this.onBackPressed,
    this.actions,
    this.role = RoleEnum.user,
  }) : _showLogo = false;

  const GomsAppBar._logo({
    super.key,
    this.actions,
    this.role = RoleEnum.user,
  })  : _showLogo = true,
        onBackPressed = null;
  factory GomsAppBar.logo({
    Key? key,
    List<Widget>? actions,
    RoleEnum role = RoleEnum.user,
  }) =>
      GomsAppBar._logo(
        key: key,
        actions: actions,
        role: role,
      );

  factory GomsAppBar.back({
    Key? key,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    RoleEnum currentRole = RoleEnum.user,
  }) =>
      GomsAppBar._back(
        key: key,
        onBackPressed: onBackPressed,
        actions: actions,
        role: currentRole,
      );

  final bool _showLogo;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final RoleEnum role;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: _showLogo
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s24),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: role == RoleEnum.admin
                    ? AppIcons.back(
                        width: 24,
                        height: 24,
                        color: AppColors.admin,
                      )
                    : AppIcons.back(width: 24, height: 24),
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
                  color:
                      context.isDarkMode ? context.sub2Color : AppColors.button,
                ),
                AppGap.h8,
                Text(
                  'GOMS',
                  style: TextStyle(
                    fontFamily: 'gmarketSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.isDarkMode
                        ? context.sub2Color
                        : AppColors.button,
                  ),
                ),
                const Spacer(),
                if (role == RoleEnum.admin)
                  IconButton(
                    onPressed: () =>
                        context.push(RoutePath.studentCouncilReports),
                    icon: AppIcons.report(
                      width: 24,
                      height: 24,
                      color: context.sub2Color,
                    ),
                  ),
              ],
            )
          : Text(
              '돌아가기',
              style: AppTextStyles.text2.copyWith(
                color: role == RoleEnum.admin
                    ? AppColors.admin
                    : AppColors.mainColor,
              ),
            ),
      actions: actions,
    );
  }
}
