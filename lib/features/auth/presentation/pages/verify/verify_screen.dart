import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/presentation/pages/auth_base_screen.dart';
import 'package:goms/features/auth/presentation/pages/verify/states/verify_state.dart';
import 'package:goms/features/auth/presentation/pages/verify/viewmodels/verify_provider.dart';
import 'package:goms/core/widgets/common/goms_dialog.dart';
import 'package:goms/core/widgets/common/text_fields/base_text_field.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String? redirectPath;

  const VerifyScreen({super.key, this.redirectPath});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(verifyProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verifyState = ref.watch(verifyProvider);
    final notifier = ref.read(verifyProvider.notifier);
    final isLoading = verifyState.status == VerifyStatus.loading;

    ref.listen(verifyProvider, (previous, next) async {
      if (next.status == VerifyStatus.success) {
        notifier.resetStatus();
        final isResetFlow = widget.redirectPath == RoutePath.resetPassword;
        await GomsDialog.single(
          title: '인증 확인',
          content: isResetFlow
              ? '인증이 완료되었습니다.\n비밀번호 재설정 페이지로 이동합니다.'
              : '인증이 완료되었습니다.\n회원가입 페이지로 돌아갑니다.',
          onConfirm: () {
            context.push(widget.redirectPath ?? RoutePath.password);
          },
        ).show(context);
        notifier.reset();
      } else if (next.status == VerifyStatus.failure &&
          next.errorMessage != null) {
        notifier.resetStatus();
        // 에러 호출
      }
    });

    return AuthBaseScreen(
      title: '인증번호',
      confirmText: '인증',
      isConfirmEnabled: notifier.isFormValid,
      onConfirm: notifier.isFormValid && !isLoading ? notifier.verify : null,
      showAppBar: true,
      showAppBarLogo: false,
      isLoading: isLoading,
      children: [
        BaseTextField(
          controller: notifier.codeController,
          hintText: '인증번호를 입력해주세요',
          errorText: verifyState.codeError,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
          onChanged: (value) {
            if (value.length <= 6) {
              notifier.setCode(value);
            } else {
              notifier.codeController.text = value.substring(0, 6);
              notifier.codeController.selection =
                  const TextSelection.collapsed(offset: 6);
            }
          },
          onSubmitted: (_) => notifier.verify(),
        ),
        AppGap.h12,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              notifier.formattedTime,
              style: AppTextStyles.text3.withColor(
                isDark ? AppColors.sub2Dark : AppColors.sub2,
              ),
            ),
            GestureDetector(
              onTap: isLoading ? null : notifier.resend,
              child: Text(
                '재발송',
                style: AppTextStyles.text3.withColor(
                  AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



