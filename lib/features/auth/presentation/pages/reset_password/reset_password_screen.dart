import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/presentation/pages/auth_base_screen.dart';
import 'package:goms/features/auth/presentation/pages/reset_password/models/reset_password_state.dart';
import 'package:goms/features/auth/presentation/pages/reset_password/viewmodels/reset_password_provider.dart';
import 'package:goms/core/widgets/common/goms_dialog.dart';
import 'package:goms/core/widgets/common/text_fields/password_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(resetPasswordProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resetPasswordState = ref.watch(resetPasswordProvider);
    final notifier = ref.read(resetPasswordProvider.notifier);
    final isLoading = resetPasswordState.status == ResetPasswordStatus.loading;

    ref.listen<ResetPasswordState>(resetPasswordProvider, (previous, next) async {
      if (next.status == ResetPasswordStatus.success) {
        notifier.clearError();
        await GomsDialog.single(
          title: '재설정 완료',
          content: '비밀번호가 성공적으로 재설정되었습니다.\n로그인 화면으로 돌아갑니다.',
          onConfirm: () {
            context.go(RoutePath.login);
          },
        ).show(context);
      } else if (next.status == ResetPasswordStatus.failure &&
          next.errorMessage != null) {
        notifier.clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    });

    return AuthBaseScreen(
      title: '비밀번호 재설정',
      confirmText: '로그인',
      isConfirmEnabled: notifier.isFormValid,
      onConfirm:
          notifier.isFormValid && !isLoading ? notifier.resetPassword : null,
      showAppBar: true,
      showAppBarLogo: false,
      isLoading: isLoading,
      children: [
        PasswordTextField(
          controller: notifier.passwordController,
          hintText: '비밀번호를 입력해주세요',
          errorText: resetPasswordState.passwordError,
          enabled: !isLoading,
          onChanged: notifier.validatePassword,
        ),
        AppGap.v16,
        PasswordTextField(
          controller: notifier.passwordConfirmController,
          hintText: '비밀번호를 다시 입력해주세요',
          errorText: resetPasswordState.passwordConfirmError,
          enabled: !isLoading,
          onChanged: notifier.validatePasswordConfirm,
        ),
        AppGap.v12,
        Text(
          '비밀번호는 6자 이상, 대/소문자, 숫자, 특수문자를 포함해 주세요',
          style: AppTextStyles.text3.withColor(
            isDark ? AppColors.sub2Dark : AppColors.sub2,
          ),
        ),
      ],
    );
  }
}




