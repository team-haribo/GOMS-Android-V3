import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/widgets/common/appbar/goms_app_bar.dart';

class BaseScaffold extends ConsumerWidget {
  final Widget body;
  final bool showAppBar;
  final bool showAppBarLogo;
  final VoidCallback? onBackPressed;
  final List<Widget>? appBarActions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const BaseScaffold({
    super.key,
    required this.body,
    this.showAppBar = true,
    this.showAppBarLogo = false,
    this.onBackPressed,
    this.appBarActions,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // showAppBar가 true면 GomsAppBar 사용
    final effectiveAppBar = showAppBar
        ? GomsAppBar(
            showLogo: showAppBarLogo,
            onBackPressed: onBackPressed,
            actions: appBarActions,
          )
        : null;

    return Scaffold(
      appBar: effectiveAppBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
