import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/router/route_path.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/domain/enum/gender_enum.dart';
import 'package:project_setting/domain/enum/major_enum.dart';
import 'package:project_setting/presentation/auth/signup/models/signup_state.dart';
import 'package:project_setting/presentation/auth/signup/viewModels/signup_provider.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
import 'package:project_setting/widgets/common/select_field.dart';
import 'package:project_setting/widgets/common/textfield/base_text_field.dart';
import 'package:project_setting/widgets/common/textfield/email_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signupProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final signupState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final isLoading = signupState.status == SignupStatus.loading;

    ref.listen(signupProvider, (previous, next) {
      if (next.status == SignupStatus.success) {
        context.push(RoutePath.verify);
      } else if (next.status == SignupStatus.failure &&
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
                      '회원가입',
                      style: AppTextStyles.title1.withColor(
                        isDark ? AppColors.mainTextDark : AppColors.mainText,
                      ),
                    ),
                    AppGap.v24,

                    // 이름 입력
                    BaseTextField(
                      controller: notifier.nameController,
                      hintText: '이름을 입력해주세요',
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      onChanged: notifier.setName,
                    ),
                    AppGap.v16,

                    // 이메일 입력
                    EmailTextField(
                      controller: notifier.emailController,
                      hintText: '이메일을 입력해주세요',
                      errorText: signupState.emailError,
                      enabled: !isLoading,
                      onChanged: notifier.validateEmail,
                    ),
                    AppGap.v16,

                    // 성별 선택
                    SelectField<GenderEnum>(
                      hintText: '성별을 선택해주세요',
                      value: signupState.gender,
                      items: GenderEnum.values,
                      itemLabel: (g) => g.label,
                      enabled: !isLoading,
                      onChanged: notifier.setGender,
                    ),
                    AppGap.v16,

                    // 과 선택
                    SelectField<MajorEnum>(
                      hintText: '과를 선택해주세요',
                      value: signupState.major,
                      items: MajorEnum.values,
                      itemLabel: (m) => m.label,
                      enabled: !isLoading,
                      onChanged: notifier.setMajor,
                    ),

                    const Spacer(),

                    // 인증번호 받기 버튼
                    ConfirmButton(
                      text: '인증번호 받기',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : (notifier.isFormValid
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
