import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';

/// Auth 스크린 공통 베이스
class AuthBaseScreen<T> extends ConsumerStatefulWidget {
  final String title;
  final List<Widget> children;
  final String confirmText;
  final VoidCallback? onConfirm;
  final bool isConfirmEnabled;
  final bool isLoading;
  final T provider;
  final void Function(BuildContext, T, WidgetRef)? listen;
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
    required this.provider,
    this.listen,
    this.isLoading = false,
    this.showAppBar = true,
    this.showAppBarLogo = false,
    this.appBarActions,
  });

  @override
  ConsumerState<AuthBaseScreen<T>> createState() => _AuthBaseScreenState<T>();
}

class _AuthBaseScreenState<T> extends ConsumerState<AuthBaseScreen<T>> {
  @override
  void initState() {
    super.initState();
    // provider 초기화 등 필요시 추가
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final provider = widget.provider;

    if (widget.listen != null) {
      widget.listen!(context, provider, ref);
    }

    return BaseScaffold(
      showAppBar: widget.showAppBar,
      showAppBarLogo: widget.showAppBarLogo,
      onBackPressed: () => Navigator.of(context).maybePop(),
      appBarActions: widget.appBarActions,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextStyles.title1.withColor(
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.mainTextDark
                  : AppColors.mainText,
            ),
          ),
          const SizedBox(height: 24),
          ...widget.children,
          const Spacer(),
          ConfirmButton(
            text: widget.confirmText,
            isLoading: widget.isLoading,
            onPressed: widget.isConfirmEnabled && !widget.isLoading
                ? widget.onConfirm
                : null,
          ),
        ],
      ),
    );
  }
}
