import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/auth/auth_provider.dart';
import 'package:project_setting/presentation/auth/login/model/login_state.dart';
import 'package:project_setting/presentation/auth/login/viewModel/login_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
import 'package:project_setting/widgets/common/text_fields/email_text_field.dart';
import 'package:project_setting/widgets/common/text_fields/password_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isButtonEnabled =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  void _handleLogin() {
    ref
        .read(loginProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }

  void _handleFindPassword() {
    // TODO: 비밀번호 찾기 구현
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.status == LoginStatus.loading;

    ref.listen(loginProvider, (previous, next) {
      if (next.status == LoginStatus.success) {
        ref.read(authProvider.notifier).setAuthenticated();
        context.go(RoutePath.home);
      } else if (next.status == LoginStatus.failure &&
          next.errorMessage != null) {
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
                    Text(
                      '로그인',
                      style: AppTextStyles.title1.withColor(
                        isDark ? AppColors.mainTextDark : AppColors.mainText,
                      ),
                    ),
                    AppGap.v24,
                    EmailTextField(
                      controller: _emailController,
                      hintText: '이메일을 입력해주세요',
                      errorText: loginState.emailError,
                      enabled: !isLoading,
                      onChanged: ref.read(loginProvider.notifier).validateEmail,
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    AppGap.v16,
                    PasswordTextField(
                      controller: _passwordController,
                      hintText: '비밀번호를 입력해주세요',
                      errorText: loginState.passwordError,
                      enabled: !isLoading,
                      onChanged:
                          ref.read(loginProvider.notifier).validatePassword,
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    AppGap.v12,
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _handleFindPassword,
                        child: Text(
                          '비밀번호 찾기',
                          style: AppTextStyles.text3.withColor(
                            AppColors.mainColor,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ConfirmButton(
                      text: '로그인',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : (_isButtonEnabled ? _handleLogin : null),
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
