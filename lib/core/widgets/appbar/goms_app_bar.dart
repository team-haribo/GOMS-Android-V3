import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/enums/role_enum.dart';

class GomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GomsAppBar._back({
    super.key,
    this.onBackPressed,
    this.actions,
    this.role = RoleEnum.user,
  })  : _showLogo = false,
        showAdminReportAction = false;

  const GomsAppBar._logo({
    super.key,
    this.actions,
    this.role = RoleEnum.user,
    this.showAdminReportAction = false,
  })  : _showLogo = true,
        onBackPressed = null;
  factory GomsAppBar.logo({
    Key? key,
    List<Widget>? actions,
    RoleEnum role = RoleEnum.user,
    bool showAdminReportAction = false,
  }) =>
      GomsAppBar._logo(
        key: key,
        actions: actions,
        role: role,
        showAdminReportAction: showAdminReportAction,
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
  final bool showAdminReportAction;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final backAction = onBackPressed ?? () => context.pop();

    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: _showLogo ? null : 120,
      leading: _showLogo
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s24),
              child: TextButton(
                onPressed: backAction,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    role == RoleEnum.admin
                        ? AppIcons.back(
                            width: 24,
                            height: 24,
                            color: AppColors.admin,
                          )
                        : AppIcons.back(width: 24, height: 24),
                    AppGap.h4,
                    Text(
                      '돌아가기',
                      style: AppTextStyles.text2.copyWith(
                        color: role == RoleEnum.admin
                            ? AppColors.admin
                            : AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      titleSpacing: _showLogo ? 24 : 0,
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
                if (role == RoleEnum.admin && showAdminReportAction)
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
          : null,
      actions: actions,
    );
  }
}
