import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/presentation/pages/auth_base_screen.dart';
import 'package:goms/features/auth/presentation/pages/signup/models/signup_state.dart';
import 'package:goms/features/auth/presentation/pages/signup/viewModels/signup_provider.dart';
import 'package:goms/core/widgets/common/dialogs/goms_dialog.dart';
import 'package:goms/core/widgets/common/text_fields/password_text_field.dart';

class PasswordScreen extends ConsumerWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final isLoading = signupState.status == SignupStatus.loading;

    ref.listen<SignupState>(signupProvider, (previous, next) {
      if (next.status == SignupStatus.success) {
        notifier.clearError();
        GomsDialog.single(
          title: '회원가입 완료',
          content: '회원가입이 성공적으로 완료되었습니다.\n곰스에 오신걸 환영합니다!',
          onConfirm: () {
            context.go(RoutePath.login);
          },
        ).show(context);
      } else if (next.status == SignupStatus.failure &&
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
      title: '비밀번호 설정',
      confirmText: '로그인',
      isConfirmEnabled: notifier.isPasswordFormValid,
      onConfirm: notifier.isPasswordFormValid && !isLoading
          ? notifier.completeSignup
          : null,
      showAppBar: true,
      showAppBarLogo: false,
      isLoading: isLoading,
      children: [
        PasswordTextField(
          controller: notifier.passwordController,
          hintText: '비밀번호를 입력해주세요',
          errorText: signupState.passwordError,
          enabled: !isLoading,
          onChanged: notifier.validatePassword,
        ),
        AppGap.h16,
        PasswordTextField(
          controller: notifier.passwordConfirmController,
          hintText: '비밀번호를 다시 입력해주세요',
          errorText: signupState.passwordConfirmError,
          enabled: !isLoading,
          onChanged: notifier.validatePasswordConfirm,
        ),
        AppGap.v12,
        Text(
          '비밀번호는 6자 이상, 대/소문자, 숫자, 특수문자를 포함해 주세요',
          style: AppTextStyles.text3.withColor(context.sub2Color),
        ),
      ],
    );
  }
}
