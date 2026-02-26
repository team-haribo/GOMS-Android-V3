import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/auth/signup/models/signup_state.dart';
import 'package:project_setting/presentation/auth/signup/viewModels/signup_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
import 'package:project_setting/widgets/common/goms_dialog.dart';
import 'package:project_setting/widgets/common/textField/password_text_field.dart';

class PasswordScreen extends ConsumerWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final signupState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final isLoading = signupState.status == SignupStatus.loading;

    ref.listen(signupProvider, (previous, next) {
      if (next.status == SignupStatus.success) {
        notifier.clearError();
        GomsDialog.show(
          context: context,
          title: '회원가입 완료',
          content: '회원가입이 성공적으로 완료되었습니다.\n곰스에 오신걸 환영합니다!',
          onConfirm: () {
            // TODO: 로그인 화면으로 이동
          },
        );
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

    return BaseScaffold(
      showAppBar: true,
      showAppBarLogo: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 타이틀
                    Text(
                      '비밀번호 설정',
                      style: AppTextStyles.title1.withColor(
                        isDark ? AppColors.mainTextDark : AppColors.mainText,
                      ),
                    ),
                    AppGap.v24,

                    /// 비밀번호 입력
                    PasswordTextField(
                      controller: notifier.passwordController,
                      hintText: '비밀번호를 입력해주세요',
                      errorText: signupState.passwordError,
                      enabled: !isLoading,
                      onChanged: notifier.validatePassword,
                    ),
                    AppGap.h16,

                    /// 비밀번호 확인
                    PasswordTextField(
                      controller: notifier.passwordConfirmController,
                      hintText: '비밀번호를 다시 입력해주세요',
                      errorText: signupState.passwordConfirmError,
                      enabled: !isLoading,
                      onChanged: notifier.validatePasswordConfirm,
                    ),
                    AppGap.v12,

                    /// 안내 텍스트
                    Text(
                      '비밀번호는 6자 이상, 대/소문자, 숫자, 특수문자를 포함해 주세요',
                      style: AppTextStyles.text3.withColor(
                        isDark ? AppColors.sub2Dark : AppColors.sub2,
                      ),
                    ),

                    const Spacer(),

                    /// 회원가입 완료 버튼
                    ConfirmButton(
                      text: '로그인',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : (notifier.isPasswordFormValid
                              ? notifier.submitSignup
                              : null),
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
