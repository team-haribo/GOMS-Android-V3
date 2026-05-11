import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:goms/features/auth/email_verification/data/models/request/email_verification/send_email_verification_request_dto.dart';
import 'package:goms/features/auth/signup/data/request/signup/signup_request_dto.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';
import 'package:goms/features/auth/signup/data/providers/signup_data_providers.dart';
import 'package:goms/features/auth/email_verification/domain/enums/email_verification_purpose.dart';
import 'package:goms/features/auth/signup/presentation/models/signup_state.dart';
import 'package:goms/features/auth/shared/presentation/viewmodels/auth_flow_viewmodel.dart';

final signupProvider = NotifierProvider<SignupNotifier, SignupState>(
  SignupNotifier.new,
);

class SignupNotifier extends Notifier<SignupState> {
  static const List<int> availableGrades = <int>[8, 9, 10];
  static final _emailRegex = RegExp(r'^s\d+$');
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&?~])[a-zA-Z\d!@#$%^&?~]{6,}$',
  );

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController gradeController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  SignupState build() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    gradeController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();

    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      gradeController.dispose();
      passwordController.dispose();
      passwordConfirmController.dispose();
    });

    return SignupState.initial();
  }

  void setName(String name) {
    state = state.copyWith(name: name, nameError: null);
  }

  void setGender(GenderType? gender) {
    state = state.copyWith(gender: gender);
  }

  void setMajor(DepartmentType? major) {
    state = state.copyWith(major: major);
  }

  void validateGrade(String grade) {
    String? error;
    final parsedGrade = int.tryParse(grade);

    if (grade.isNotEmpty) {
      if (parsedGrade == null) {
        error = '기수는 숫자만 입력 가능합니다';
      } else if (!availableGrades.contains(parsedGrade)) {
        error = '기수는 8기, 9기, 10기만 선택할 수 있습니다';
      }
    }

    state = state.copyWith(grade: grade, gradeError: error);
  }

  void setGrade(int? grade) {
    final nextGrade = grade?.toString() ?? '';
    gradeController.text = nextGrade;
    validateGrade(nextGrade);
  }

  void setPrivacyPolicyAgreed(bool isAgreed) {
    state = state.copyWith(isPrivacyPolicyAgreed: isAgreed);
  }

  int? get selectedGrade => int.tryParse(state.grade);

  void validateEmail(String email) {
    String? error;
    if (email.isNotEmpty && !_emailRegex.hasMatch(email)) {
      error = '학교에서 제공한 이메일만 사용 가능합니다';
    }
    state = state.copyWith(email: email, emailError: error);
  }

  void validatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_passwordRegex.hasMatch(password)) {
      error = '잘못된 형식의 비밀번호입니다';
    }
    state = state.copyWith(password: password, passwordError: error);

    if (state.passwordConfirm.isNotEmpty) {
      _revalidatePasswordConfirm();
    }
  }

  void validatePasswordConfirm(String passwordConfirm) {
    String? error;
    if (passwordConfirm.isNotEmpty && passwordConfirm != state.password) {
      error = '비밀번호가 일치하지 않습니다';
    }
    state = state.copyWith(
      passwordConfirm: passwordConfirm,
      passwordConfirmError: error,
    );
  }

  void _revalidatePasswordConfirm() {
    String? error;
    if (state.passwordConfirm.isNotEmpty &&
        state.passwordConfirm != state.password) {
      error = '비밀번호가 일치하지 않습니다';
    }
    state = state.copyWith(passwordConfirmError: error);
  }

  bool get isFormValid =>
      state.name.isNotEmpty &&
      state.email.isNotEmpty &&
      state.emailError == null &&
      state.grade.isNotEmpty &&
      state.gradeError == null &&
      state.gender != null &&
      state.major != null &&
      state.isPrivacyPolicyAgreed;

  bool get isPasswordFormValid =>
      state.password.isNotEmpty &&
      state.passwordError == null &&
      state.passwordConfirm.isNotEmpty &&
      state.passwordConfirmError == null;

  Future<void> submitSignup() async {
    if (!isFormValid) return;

    final normalizedEmail = normalizeSchoolEmail(state.email);
    final authFlow = ref.read(authFlowProvider);
    final isSameSignupFlow = authFlow.email == normalizedEmail &&
        authFlow.purpose == EmailVerificationPurpose.signup;

    if (isSameSignupFlow) {
      state = state.copyWith(status: SignupStatus.success);
      return;
    }

    state = state.copyWith(status: SignupStatus.loading);

    try {
      await ref.read(signupRemoteDataSourceProvider).sendEmailVerification(
        SendEmailVerificationRequestDto(
          email: normalizedEmail,
          purpose: EmailVerificationPurpose.signup,
        ),
      );
      ref.read(authFlowProvider.notifier).startSignup(normalizedEmail);

      state = state.copyWith(status: SignupStatus.success);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        state = state.copyWith(
          status: SignupStatus.failure,
          emailError: '이미 가입된 이메일입니다.',
          errorMessage: null,
        );
        return;
      }

      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: NetworkException.fromDioException(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> completeSignup() async {
    if (!isPasswordFormValid) return;

    final authFlow = ref.read(authFlowProvider);
    if (authFlow.email.isEmpty || authFlow.verifiedToken == null) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: '이메일 인증 정보를 찾을 수 없습니다. 다시 진행해주세요.',
      );
      return;
    }

    if (state.gender == null || state.major == null) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: '회원가입 정보가 올바르지 않습니다. 다시 진행해주세요.',
      );
      return;
    }

    state = state.copyWith(status: SignupStatus.loading);

    try {
      Logger.d(
        'signup request: email=${authFlow.email}, name=${state.name}, grade=${state.grade}, department=${state.major!.name.toUpperCase()}, gender=${state.gender!.name.toUpperCase()}',
        tag: 'AUTH',
      );
      await ref.read(signupRemoteDataSourceProvider).signUp(
        SignUpRequestDto(
          email: authFlow.email,
          verifiedToken: authFlow.verifiedToken!,
          password: state.password,
          name: state.name,
          grade: int.parse(state.grade),
          department: state.major!,
          gender: state.gender!,
        ),
      );
      ref.read(authFlowProvider.notifier).clear();
      state = state.copyWith(status: SignupStatus.success);
    } on DioException catch (e) {
      Logger.e(
        'signup failed',
        tag: 'AUTH',
        error: e.response?.data ?? e,
        stackTrace: e.stackTrace,
      );
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: NetworkException.fromDioException(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    ref.read(authFlowProvider.notifier).clear();
    nameController.clear();
    emailController.clear();
    gradeController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
    state = SignupState.initial();
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(
        status: SignupStatus.initial,
        errorMessage: null,
      );
    }
  }

  void resetStatus() {
    if (state.status != SignupStatus.initial || state.errorMessage != null) {
      state = state.copyWith(
        status: SignupStatus.initial,
        errorMessage: null,
      );
    }
  }
}