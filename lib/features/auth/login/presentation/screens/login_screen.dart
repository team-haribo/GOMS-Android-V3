import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/shared/presentation/screens/auth_base_screen.dart';
import 'package:goms/features/auth/session/presentation/providers/session_provider.dart';
import 'package:goms/features/auth/login/presentation/models/login_state.dart';
import 'package:goms/features/auth/login/presentation/providers/login_provider.dart';
import 'package:goms/core/widgets/text_fields/email_text_field.dart';
import 'package:goms/core/widgets/text_fields/password_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final ProviderSubscription<LoginState> _loginSubscription;

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).reset();
    });
    _loginSubscription = ref.listenManual<LoginState>(loginProvider, (
      previous,
      next,
    ) async {
      if (next.status == LoginStatus.success) {
        try {
          await ref.read(authProvider.notifier).setAuthenticated();
          if (!mounted) return;
          context.go(RoutePath.home);
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('권한 정보를 불러오지 못했습니다. 다시 로그인해주세요.'),
              backgroundColor: AppColors.negative,
            ),
          );
        }
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
  }

  @override
  void dispose() {
    _loginSubscription.close();
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
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
    context.push(RoutePath.findPassword);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.status == LoginStatus.loading;

    return AuthBaseScreen(
      title: '로그인',
      confirmText: '로그인',
      isConfirmEnabled: _isButtonEnabled,
      isLoading: isLoading,
      onConfirm: _handleLogin,
      children: [
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
          onChanged: ref.read(loginProvider.notifier).validatePassword,
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
      ],
    );
  }
}
