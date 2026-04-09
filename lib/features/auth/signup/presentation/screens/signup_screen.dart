import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/auth/shared/presentation/screens/auth_base_screen.dart';
import 'package:goms/features/auth/signup/presentation/models/signup_state.dart';
import 'package:goms/features/auth/signup/presentation/providers/signup_provider.dart';
import 'package:goms/features/auth/shared/presentation/providers/auth_flow_provider.dart';
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

    return AuthBaseScreen(
      title: '회원가입',
      confirmText: '인증번호 받기',
      isConfirmEnabled: notifier.isFormValid,
      onConfirm:
          notifier.isFormValid && !isLoading ? notifier.submitSignup : null,
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
        BaseTextField(
          controller: notifier.gradeController,
          hintText: '기수를 입력해주세요',
          errorText: signupState.gradeError,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
          onChanged: notifier.validateGrade,
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
      ],
    );
  }
}
