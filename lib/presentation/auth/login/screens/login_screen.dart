import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/app_colors.dart';
import 'package:project_setting/core/theme/app_text_styles.dart';
import 'package:project_setting/presentation/auth/login/state/login_provider.dart';
import 'package:project_setting/presentation/auth/login/state/login_state.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
import 'package:project_setting/widgets/common/textField/email_textField.dart';
import 'package:project_setting/widgets/common/textField/password_textField.dart';

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

  void _onEmailChanged(String value) {
    setState(() {});
    ref.read(loginProvider.notifier).validateEmail(value);
  }

  void _onPasswordChanged(String value) {
    setState(() {});
    ref.read(loginProvider.notifier).validatePassword(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.status == LoginStatus.loading;

    ref.listen(loginProvider, (previous, next) {
      if (next.status == LoginStatus.success) {
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
                    const SizedBox(height: 24),
                    EmailTextField(
                      controller: _emailController,
                      hintText: '이메일을 입력해주세요',
                      errorText: loginState.emailError,
                      enabled: !isLoading,
                      onChanged: _onEmailChanged,
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 16),
                    PasswordTextField(
                      controller: _passwordController,
                      hintText: '비밀번호를 입력해주세요',
                      errorText: loginState.passwordError,
                      enabled: !isLoading,
                      onChanged: _onPasswordChanged,
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: isLoading ? null : _handleFindPassword,
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
