import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/buttons/confirm_button.dart';

/// Auth 스크린 공통 베이스
class AuthBaseScreen extends ConsumerWidget {
  final String title;
  final List<Widget> children;
  final String confirmText;
  final VoidCallback? onConfirm;
  final bool isConfirmEnabled;
  final bool isLoading;
  final bool showAppBar;
  final bool showAppBarLogo;
  final List<Widget>? appBarActions;
  final VoidCallback? onBackPressed;

  const AuthBaseScreen({
    super.key,
    required this.title,
    required this.children,
    required this.confirmText,
    required this.onConfirm,
    required this.isConfirmEnabled,
    this.isLoading = false,
    this.showAppBar = true,
    this.showAppBarLogo = false,
    this.appBarActions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BaseScaffold(
      showAppBar: showAppBar,
      showAppBarLogo: showAppBarLogo,
      onBackPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      appBarActions: appBarActions,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.appTypography.title1.copyWith(
                        color: context.mainTextColor,
                      ),
                    ),
                    context.vSpace(24),
                    ...children,
                    const Spacer(),
                    ConfirmButton(
                      text: confirmText,
                      isLoading: isLoading,
                      onPressed:
                          isConfirmEnabled && !isLoading ? onConfirm : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
