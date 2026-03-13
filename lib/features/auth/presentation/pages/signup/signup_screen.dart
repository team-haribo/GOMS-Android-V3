import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/enums/gender_enum.dart';
import 'package:goms/core/enums/major_enum.dart';
import 'package:goms/features/auth/presentation/pages/auth_base_screen.dart';
import 'package:goms/features/auth/presentation/pages/signup/models/signup_state.dart';
import 'package:goms/features/auth/presentation/pages/signup/viewmodels/signup_provider.dart';
import 'package:goms/core/widgets/common/select_field.dart';
import 'package:goms/core/widgets/common/text_fields/base_text_field.dart';
import 'package:goms/core/widgets/common/text_fields/email_text_field.dart';

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
    final signupState = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final isLoading = signupState.status == SignupStatus.loading;

    ref.listen<SignupState>(signupProvider, (previous, next) {
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
        SelectField<GenderEnum>(
          hintText: '성별을 선택해주세요',
          value: signupState.gender,
          items: GenderEnum.values,
          itemLabel: (g) => g.label,
          enabled: !isLoading,
          onChanged: notifier.setGender,
        ),
        AppGap.v16,
        SelectField<MajorEnum>(
          hintText: '과를 선택해주세요',
          value: signupState.major,
          items: MajorEnum.values,
          itemLabel: (m) => m.label,
          enabled: !isLoading,
          onChanged: notifier.setMajor,
        ),
      ],
    );
  }
}




