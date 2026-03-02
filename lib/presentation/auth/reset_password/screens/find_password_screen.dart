import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/presentation/auth/auth_base_screen.dart';
import 'package:project_setting/presentation/auth/reset_password/models/find_password_state.dart';
import 'package:project_setting/presentation/auth/reset_password/viewModels/find_password_provider.dart';
import 'package:project_setting/widgets/common/text_fields/email_text_field.dart';

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

    return AuthBaseScreen(
      title: '비밀번호 찾기',
      confirmText: '인증번호 받기',
      isConfirmEnabled: notifier.isFormValid,
      onConfirm: notifier.isFormValid && !isLoading
          ? notifier.findPassword
          : null,
      showAppBar: true,
      showAppBarLogo: false,
      provider: findPasswordProvider,
      isLoading: isLoading,
      listen: (context, provider, ref) {
        ref.listen(findPasswordProvider, (previous, next) {
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
      },
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
