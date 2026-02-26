import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/domain/enum/gender_enum.dart';
import 'package:project_setting/domain/enum/major_enum.dart';
import 'package:project_setting/presentation/auth/signup/models/signup_state.dart';

/// 회원가입 Provider
final signupProvider = NotifierProvider<SignupNotifier, SignupState>(
  SignupNotifier.new,
);

/// 회원가입 Notifier
class SignupNotifier extends Notifier<SignupState> {
  /// 이메일: 학교 이메일만 허용 (s + 숫자)
  static final _emailRegex = RegExp(r'^s\d+$');

  /// 비밀번호: 6자 이상, 대/소문자, 숫자, 특수문자 포함
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&?~])[a-zA-Z\d!@#$%^&?~]{6,}$',
  );

  // ==================== Controllers ====================
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  SignupState build() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();

    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      passwordConfirmController.dispose();
    });

    return SignupState.initial();
  }

  // ==================== 값 설정 ====================

  /// 이름 변경
  void setName(String name) {
    state = state.copyWith(name: name, nameError: null);
  }

  /// 성별 변경
  void setGender(GenderEnum? gender) {
    state = state.copyWith(gender: gender);
  }

  /// 과 변경
  void setMajor(MajorEnum? major) {
    state = state.copyWith(major: major);
  }

  // ==================== 유효성 검사 ====================

  /// 이메일 유효성 검사
  void validateEmail(String email) {
    String? error;
    if (email.isNotEmpty && !_emailRegex.hasMatch(email)) {
      error = '학교에서 제공한 이메일만 사용 가능합니다';
    }
    state = state.copyWith(email: email, emailError: error);
  }

  /// 비밀번호 유효성 검사
  void validatePassword(String password) {
    String? error;
    if (password.isNotEmpty && !_passwordRegex.hasMatch(password)) {
      error = '잘못된 형식의 비밀번호입니다';
    }
    state = state.copyWith(password: password, passwordError: error);

    // 비밀번호 확인도 재검증
    if (state.passwordConfirm.isNotEmpty) {
      _revalidatePasswordConfirm();
    }
  }

  /// 비밀번호 확인 유효성 검사
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

  /// 비밀번호 변경 시 확인 필드 재검증
  void _revalidatePasswordConfirm() {
    String? error;
    if (state.passwordConfirm.isNotEmpty &&
        state.passwordConfirm != state.password) {
      error = '비밀번호가 일치하지 않습니다';
    }
    state = state.copyWith(passwordConfirmError: error);
  }

  // ==================== 버튼 활성화 ====================

  /// 회원가입 화면 폼 유효성 (이름, 이메일, 성별, 과)
  bool get isFormValid =>
      state.name.isNotEmpty &&
      state.email.isNotEmpty &&
      state.emailError == null &&
      state.gender != null &&
      state.major != null;

  /// 비밀번호 설정 폼 유효성
  bool get isPasswordFormValid =>
      state.password.isNotEmpty &&
      state.passwordError == null &&
      state.passwordConfirm.isNotEmpty &&
      state.passwordConfirmError == null;

  // ==================== 회원가입 ====================

  /// 인증번호 받기
  Future<void> submitSignup() async {
    if (!isFormValid) return;

    state = state.copyWith(status: SignupStatus.loading);

    try {
      // TODO: 실제 회원가입 API 호출
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(status: SignupStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: '회원가입에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
    state = SignupState.initial();
  }

  /// 에러 메시지 초기화
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(
        status: SignupStatus.initial,
        errorMessage: null,
      );
    }
  }
}
