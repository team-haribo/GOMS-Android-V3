import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/widgets/common/base_scaffold.dart';
import 'package:goms/widgets/common/buttons/confirm_button.dart';

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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      showAppBar: showAppBar,
      showAppBarLogo: showAppBarLogo,
      onBackPressed: () => Navigator.of(context).maybePop(),
      appBarActions: appBarActions,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title1.withColor(
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.mainTextDark
                  : AppColors.mainText,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
          const Spacer(),
          ConfirmButton(
            text: confirmText,
            isLoading: isLoading,
            onPressed: isConfirmEnabled && !isLoading ? onConfirm : null,
          ),
        ],
      ),
    );
  }
}
