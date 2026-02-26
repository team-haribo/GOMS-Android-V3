import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/auth/verify/states/verify_state.dart';
import 'package:project_setting/presentation/auth/verify/viewModel/verify_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
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

    ref.listen(verifyProvider, (previous, next) {
      if (next.status == VerifyStatus.success) {
        notifier.resetStatus();
        GomsDialog.show(
          context: context,
          title: '인증 확인',
          content: '인증이 완료되었습니다.\n회원가입 페이지로 돌아갑니다.',
          onConfirm: () {
            context.push(RoutePath.password);
          },
        );
      } else if (next.status == VerifyStatus.failure &&
          next.errorMessage != null) {
        notifier.resetStatus();
        // 에러 호출
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
                      '인증번호',
                      style: AppTextStyles.title1.withColor(
                        isDark ? AppColors.mainTextDark : AppColors.mainText,
                      ),
                    ),
                    AppGap.v24,

                    /// 인증번호 입력 필드
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

                    /// 타이머 & 재발송 버튼
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

                    const Spacer(),

                    /// 인증 버튼
                    ConfirmButton(
                      text: '인증',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : (notifier.isFormValid ? notifier.verify : null),
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
