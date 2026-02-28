import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/auth/auth_base_screen.dart';
import 'package:project_setting/presentation/auth/verify/states/verify_state.dart';
import 'package:project_setting/presentation/auth/verify/viewModel/verify_provider.dart';
import 'package:project_setting/widgets/common/goms_dialog.dart';
import 'package:project_setting/widgets/common/text_fields/base_text_field.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(verifyProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verifyState = ref.watch(verifyProvider);
    final notifier = ref.read(verifyProvider.notifier);
    final isLoading = verifyState.status == VerifyStatus.loading;

    return AuthBaseScreen(
      title: '인증번호',
      confirmText: '인증',
      isConfirmEnabled: notifier.isFormValid,
      onConfirm: notifier.isFormValid && !isLoading ? notifier.verify : null,
      showAppBar: true,
      showAppBarLogo: false,
      provider: verifyProvider,
      isLoading: isLoading,
      listen: (context, provider, ref) {
        ref.listen(verifyProvider, (previous, next) async {
          if (next.status == VerifyStatus.success) {
            notifier.resetStatus();
            await GomsDialog.show(
              context: context,
              title: '인증 확인',
              content: '인증이 완료되었습니다.\n회원가입 페이지로 돌아갑니다.',
              onConfirm: () {
                context.push(RoutePath.password);
              },
            );
            notifier.reset();
          } else if (next.status == VerifyStatus.failure &&
              next.errorMessage != null) {
            notifier.resetStatus();
            // 에러 호출
          }
        });
      },
      children: [
        BaseTextField(
          controller: notifier.codeController,
          hintText: '인증번호를 입력해주세요',
          errorText: verifyState.codeError,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
          onChanged: (value) {
            if (value.length <= 6) {
              notifier.setCode(value);
            } else {
              notifier.codeController.text = value.substring(0, 6);
              notifier.codeController.selection =
                  const TextSelection.collapsed(offset: 6);
            }
          },
          onSubmitted: (_) => notifier.verify(),
        ),
        AppGap.h12,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              notifier.formattedTime,
              style: AppTextStyles.text3.withColor(
                isDark ? AppColors.sub2Dark : AppColors.sub2,
              ),
            ),
            GestureDetector(
              onTap: isLoading ? null : notifier.resend,
              child: Text(
                '재발송',
                style: AppTextStyles.text3.withColor(
                  AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
