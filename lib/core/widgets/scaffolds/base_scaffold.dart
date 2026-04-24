import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/widgets/appbar/goms_app_bar.dart';

class BaseScaffold extends ConsumerWidget {
  final Widget body;
  final bool showAppBar;
  final bool showAppBarLogo;
  final bool showAdminReportAction;
  final RoleEnum role;
  final VoidCallback? onBackPressed;
  final List<Widget>? appBarActions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsets? contentPadding;
  final bool resizeToAvoidBottomInset;

  const BaseScaffold({
    super.key,
    required this.body,
    this.showAppBar = true,
    this.showAppBarLogo = false,
    this.showAdminReportAction = false,
    this.role = RoleEnum.user,
    this.onBackPressed,
    this.appBarActions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.contentPadding,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const defaultPadding = EdgeInsets.fromLTRB(
      AppSpacing.s24,
      AppSpacing.s16,
      AppSpacing.s24,
      AppSpacing.s24,
    );
    final basePadding = contentPadding ?? defaultPadding;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final effectivePadding = basePadding.copyWith(
      bottom: basePadding.bottom + bottomInset,
    );

    final effectiveAppBar = showAppBar
        ? (showAppBarLogo
            ? GomsAppBar.logo(
                actions: appBarActions,
                role: role,
                showAdminReportAction: showAdminReportAction,
              )
            : GomsAppBar.back(
                onBackPressed: onBackPressed,
                actions: appBarActions,
                currentRole: role,
              ))
        : null;

    return Scaffold(
      appBar: effectiveAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Padding(
        padding: effectivePadding,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
