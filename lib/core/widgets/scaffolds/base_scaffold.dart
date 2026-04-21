import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/widgets/appbar/goms_app_bar.dart';

class BaseScaffold extends ConsumerWidget {
  final Widget body;
  final bool showAppBar;
  final bool showAppBarLogo;
  final RoleEnum role;
  final VoidCallback? onBackPressed;
  final List<Widget>? appBarActions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsets? contentPadding;

  const BaseScaffold({
    super.key,
    required this.body,
    this.showAppBar = true,
    this.showAppBarLogo = false,
    this.role = RoleEnum.user,
    this.onBackPressed,
    this.appBarActions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.contentPadding,
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
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final effectivePadding = basePadding.copyWith(
      bottom: basePadding.bottom + bottomInset,
    );

    final effectiveAppBar = showAppBar
        ? (showAppBarLogo
            ? GomsAppBar.logo(
                actions: appBarActions,
                role: role,
              )
            : GomsAppBar.back(
                onBackPressed: onBackPressed,
                actions: appBarActions,
                currentRole: role,
              ))
        : null;

    return Scaffold(
      appBar: effectiveAppBar,
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
