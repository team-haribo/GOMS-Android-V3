import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/auth/shared/ui/screens/auth_base_screen.dart';
import 'package:goms/features/auth/signup/ui/models/signup_state.dart';
import 'package:goms/features/auth/signup/ui/providers/signup_provider.dart';
import 'package:goms/features/auth/shared/ui/providers/auth_flow_provider.dart';
import 'package:goms/core/widgets/selects/select_field.dart';
import 'package:goms/core/widgets/text_fields/base_text_field.dart';
import 'package:goms/core/widgets/text_fields/email_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final ProviderSubscription<SignupState> _signupSubscription;

  void _clearSignupState() {
    ref.read(signupProvider.notifier).reset();
  }

  void _handleBack() {
    _clearSignupState();
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    _signupSubscription = ref.listenManual<SignupState>(signupProvider, (
      previous,
      next,
    ) {
      if (next.status == SignupStatus.success) {
        ref.read(signupProvider.notifier).resetStatus();
        final authFlow = ref.read(authFlowProvider);
        final destination = authFlow.verifiedToken != null
            ? RoutePath.password
            : RoutePath.verify;
        context.go(destination);
      } else if (next.status == SignupStatus.failure &&
          next.errorMessage != null) {
        ref.read(signupProvider.notifier).resetStatus();
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
    _signupSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final isLoading = signupState.status == SignupStatus.loading;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _clearSignupState();
        }
      },
      child: AuthBaseScreen(
        title: '회원가입',
        confirmText: '인증번호 받기',
        isConfirmEnabled: notifier.isFormValid,
        onConfirm:
            notifier.isFormValid && !isLoading ? notifier.submitSignup : null,
        onBackPressed: _handleBack,
        showAppBar: true,
        showAppBarLogo: false,
        isLoading: isLoading,
        children: [
          BaseTextField(
            controller: notifier.nameController,
            hintText: '이름을 입력해주세요',
            textInputAction: TextInputAction.next,
            enabled: !isLoading,
            onChanged: notifier.setName,
          ),
          AppGap.v16,
          EmailTextField(
            controller: notifier.emailController,
            hintText: '이메일을 입력해주세요',
            errorText: signupState.emailError,
            enabled: !isLoading,
            onChanged: notifier.validateEmail,
          ),
          AppGap.v16,
          SelectField<int>(
            hintText: '기수를 선택해주세요',
            value: notifier.selectedGrade,
            items: SignupNotifier.availableGrades,
            itemLabel: (grade) => '$grade기',
            enabled: !isLoading,
            onChanged: notifier.setGrade,
          ),
          AppGap.v16,
          SelectField<GenderType>(
            hintText: '성별을 선택해주세요',
            value: signupState.gender,
            items: GenderType.values,
            itemLabel: (g) => g.label,
            enabled: !isLoading,
            onChanged: notifier.setGender,
          ),
          AppGap.v16,
          SelectField<DepartmentType>(
            hintText: '과를 선택해주세요',
            value: signupState.major,
            items: DepartmentType.values,
            itemLabel: (m) => m.label,
            enabled: !isLoading,
            onChanged: notifier.setMajor,
          ),
          AppGap.v16,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final isAgreed =
                  await context.push<bool>(RoutePath.privacyPolicy);
              if (isAgreed == true && mounted) {
                notifier.setPrivacyPolicyAgreed(true);
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '개인정보 수집 및 처리방침',
                      style: AppTextStyles.text1.withColor(AppColors.mainColor),
                    ),
                  ),
                  signupState.isPrivacyPolicyAgreed
                      ? AppIcons.check(color: AppColors.mainColor)
                      : AppIcons.non_check(color: context.sub2Color),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
