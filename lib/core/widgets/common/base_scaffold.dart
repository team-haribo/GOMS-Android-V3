import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/widgets/common/appbar/goms_app_bar.dart';

class BaseScaffold extends ConsumerWidget {
  final Widget body;
  final bool showAppBar;
  final bool showAppBarLogo;
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
    this.onBackPressed,
    this.appBarActions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveAppBar = showAppBar
        ? (showAppBarLogo
            ? GomsAppBar.logo(actions: appBarActions)
            : GomsAppBar.back(
                onBackPressed: onBackPressed,
                actions: appBarActions,
              ))
        : null;

    return Scaffold(
      appBar: effectiveAppBar,
      body: SafeArea(
        child: Padding(
          padding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
                vertical: AppSpacing.s24,
              ),
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

