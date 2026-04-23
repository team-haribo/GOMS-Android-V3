import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/utils/camera_launch_destination_resolver.dart';
import 'package:goms/core/utils/settings_storage.dart';
import 'package:goms/features/auth/shared/ui/screens/auth_base_screen.dart';
import 'package:goms/features/auth/session/ui/providers/session_provider.dart';
import 'package:goms/features/auth/login/ui/models/login_state.dart';
import 'package:goms/features/auth/login/ui/providers/login_provider.dart';
import 'package:goms/features/member/ui/providers/current_member_provider.dart';
import 'package:goms/core/widgets/text_fields/email_text_field.dart';
import 'package:goms/core/widgets/text_fields/password_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final ProviderSubscription<LoginState> _loginSubscription;
  bool _isButtonEnabled = false;

  Future<String> _resolvePostAuthRoute() async {
    final currentMember = await ref.read(currentMemberProvider.future);
    final cameraLaunchRoute = CameraLaunchDestinationResolver.resolve(
      enabled: await SettingsStorage.getCameraLaunch(),
      isCameraPermissionGranted: (await Permission.camera.status).isGranted,
      role: currentMember?.role ?? RoleEnum.user,
    );

    return cameraLaunchRoute ?? RoutePath.home;
  }

  void _onTextChanged() {
    final nextValue =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

    if (_isButtonEnabled == nextValue || !mounted) return;

    setState(() {
      _isButtonEnabled = nextValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
    _onTextChanged();
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
          final destination = await _resolvePostAuthRoute();
          if (!mounted) return;
          context.go(destination);
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

  void _handleLogin() {
    ref
        .read(loginProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }

  void _handleFindPassword() {
    context.go(RoutePath.findPassword);
  }

  void _handleBack() {
    context.go(RoutePath.onboarding);
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
      onBackPressed: _handleBack,
      confirmBottomSpacing: AppSpacing.s24,
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
