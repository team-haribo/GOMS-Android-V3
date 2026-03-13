import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/presentation/auth/auth_base_screen.dart';
import 'package:project_setting/presentation/auth/delete_account/models/delete_account_state.dart';
import 'package:project_setting/presentation/auth/delete_account/viewModels/delete_account_provider.dart';
import 'package:project_setting/widgets/common/goms_dialog.dart';
import 'package:project_setting/widgets/common/text_fields/password_text_field.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deleteAccountProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deleteAccountState = ref.watch(deleteAccountProvider);
    final notifier = ref.read(deleteAccountProvider.notifier);
    final isLoading = deleteAccountState.status == DeleteAccountStatus.loading;

    ref.listen(deleteAccountProvider, (previous, next) async {
      if (!mounted) return;
      if (next.status == DeleteAccountStatus.success) {
        await GomsDialog.single(
          title: '회원 탈퇴 완료',
          content: '그동안 GOMS를 이용해주셔서 감사합니다.\n안녕히 가세요.',
          confirmText: '완료',
          onConfirm: () {
            if (context.mounted) {
              context.go(RoutePath.onboarding);
            }
          },
        ).show(context);
      } else if (next.status == DeleteAccountStatus.failure &&
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
      title: '회원 탈퇴',
      confirmText: '회원 탈퇴하기',
      isConfirmEnabled: notifier.isFormValid,
      isLoading: isLoading,
      onConfirm:
          notifier.isFormValid && !isLoading ? notifier.deleteAccount : null,
      showAppBar: true,
      showAppBarLogo: false,
      children: [
        PasswordTextField(
          controller: notifier.passwordController,
          hintText: '현재 비밀번호를 입력해주세요',
          errorText: deleteAccountState.passwordError,
          enabled: !isLoading,
          onChanged: notifier.validatePassword,
          onSubmitted: (_) {
            if (notifier.isFormValid && !isLoading) {
              notifier.deleteAccount();
            }
          },
        ),
      ],
    );
  }
}
