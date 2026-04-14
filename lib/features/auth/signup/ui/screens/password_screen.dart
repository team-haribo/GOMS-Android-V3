import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/shared/ui/screens/auth_base_screen.dart';
import 'package:goms/features/auth/signup/ui/models/signup_state.dart';
import 'package:goms/features/auth/signup/ui/providers/signup_provider.dart';
import 'package:goms/core/widgets/dialogs/goms_dialog.dart';
import 'package:goms/core/widgets/text_fields/password_text_field.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  late final ProviderSubscription<SignupState> _signupSubscription;

  @override
  void initState() {
    super.initState();
    _signupSubscription = ref.listenManual<SignupState>(signupProvider, (
      previous,
      next,
    ) {
      if (next.status == SignupStatus.success) {
        ref.read(signupProvider.notifier).resetStatus();
        GomsDialog.single(
          title: '회원가입 완료',
          content: '회원가입이 성공적으로 완료되었습니다.\n곰스에 오신걸 환영합니다!',
          onConfirm: () {
            ref.read(signupProvider.notifier).reset();
            context.go(RoutePath.onboarding);
          },
        ).show(context);
      } else if (next.status == SignupStatus.failure &&
          next.errorMessage != null) {
        ref.read(signupProvider.notifier).resetStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _signupSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final isLoading = signupState.status == SignupStatus.loading;

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
