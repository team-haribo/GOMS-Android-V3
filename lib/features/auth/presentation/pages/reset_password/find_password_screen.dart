import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/features/auth/presentation/pages/auth_base_screen.dart';
import 'package:goms/features/auth/presentation/pages/reset_password/models/find_password_state.dart';
import 'package:goms/features/auth/presentation/pages/reset_password/viewModels/find_password_provider.dart';
import 'package:goms/core/widgets/common/text_fields/email_text_field.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(findPasswordProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final findPasswordState = ref.watch(findPasswordProvider);
    final notifier = ref.read(findPasswordProvider.notifier);
    final isLoading = findPasswordState.status == FindPasswordStatus.loading;

    ref.listen<FindPasswordState>(findPasswordProvider, (previous, next) {
      if (next.status == FindPasswordStatus.success) {
        notifier.clearError();
        context.push(RoutePath.verify, extra: RoutePath.resetPassword);
      } else if (next.status == FindPasswordStatus.failure &&
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
      title: '비밀번호 찾기',
      confirmText: '인증번호 받기',
      isConfirmEnabled: notifier.isFormValid,
      onConfirm:
          notifier.isFormValid && !isLoading ? notifier.findPassword : null,
      showAppBar: true,
      showAppBarLogo: false,
      isLoading: isLoading,
      children: [
        EmailTextField(
          controller: notifier.emailController,
          hintText: '이메일을 입력해주세요',
          errorText: findPasswordState.emailError,
          enabled: !isLoading,
          onChanged: notifier.validateEmail,
        ),
      ],
    );
  }
}
