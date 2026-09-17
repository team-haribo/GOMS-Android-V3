import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/enums/role_enum.dart';

/// 홈 화면으로 되돌아갈 back stack이 없을 때(예: 카메라 바로 켜기로 진입)의 폴백 경로.
///
/// outing 기능의 실제 라우트 상수에 대한 의존을 피하기 위해 리터럴로 둔다.
const String _homeFallbackRoute = '/home';

class GomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GomsAppBar._back({
    super.key,
    this.onBackPressed,
    this.actions,
    this.role = RoleEnum.user,
  })  : _showLogo = false,
        showAdminReportAction = false,
        onAdminReportsTap = null;

  const GomsAppBar._logo({
    super.key,
    this.actions,
    this.role = RoleEnum.user,
    this.showAdminReportAction = false,
    this.onAdminReportsTap,
  })  : _showLogo = true,
        onBackPressed = null;
  factory GomsAppBar.logo({
    Key? key,
    List<Widget>? actions,
    RoleEnum role = RoleEnum.user,
    bool showAdminReportAction = false,
    VoidCallback? onAdminReportsTap,
  }) =>
      GomsAppBar._logo(
        key: key,
        actions: actions,
        role: role,
        showAdminReportAction: showAdminReportAction,
        onAdminReportsTap: onAdminReportsTap,
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
  final VoidCallback? onAdminReportsTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // context.go 진입(예: 카메라 바로 켜기)으로 back stack이 없을 때 pop이
    // 무동작이 되므로 홈으로 폴백한다.
    final backAction = onBackPressed ??
        () => context.canPop() ? context.pop() : context.go(_homeFallbackRoute);

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
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
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
                    onPressed: onAdminReportsTap,
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
