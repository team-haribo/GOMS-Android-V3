import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/network_exception.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/auth/session/data/providers/session_data_providers.dart';
import 'package:goms/features/auth/login/presentation/models/login_state.dart';
import 'package:goms/features/auth/shared/presentation/providers/auth_flow_provider.dart';

/// 로그인 Provider
final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

/// 로그인 Notifier
class LoginNotifier extends Notifier<LoginState> {
  static final _loginEmailRegex = RegExp(r'^s\d+$');

  @override
  LoginState build() {
    return LoginState.initial();
  }

  /// 이메일 유효성 검사
  String? _validateEmailLogic(String email) {
    if (email.trim().isEmpty) {
      return '이메일을 입력해주세요';
    } else if (!_loginEmailRegex.hasMatch(email.trim())) {
      return '잘못된 형식의 이메일입니다.';
    }
    return null;
  }

  /// 비밀번호 유효성 검사
  String? _validatePasswordLogic(String password) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    return null;
  }

  /// 이메일 유효성 검사
  void validateEmail(String email) {
    state = state.copyWith(emailError: _validateEmailLogic(email));
  }

  /// 비밀번호 유효성 검사
  void validatePassword(String password) {
    state = state.copyWith(passwordError: _validatePasswordLogic(password));
  }

  void _setLoginFailure({
    String? errorMessage,
    String? emailError,
    String? passwordError,
  }) {
    state = state.copyWith(
      status: LoginStatus.failure,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  void _handleLoginDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;

    if (statusCode == 404) {
      _setLoginFailure(emailError: '가입되지 않은 이메일입니다.');
      return;
    }

    if (statusCode == 403) {
      _setLoginFailure(passwordError: '비밀번호가 일치하지 않습니다.');
      return;
    }

    _setLoginFailure(
      errorMessage: NetworkException.fromDioException(exception).message,
    );
  }

  /// 로그인
  Future<void> login(String email, String password) async {
    // 유효성 검사
    final emailError = _validateEmailLogic(email);
    final passwordError = _validatePasswordLogic(password);

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    if (emailError != null || passwordError != null) return;

    state = LoginState.loading();

    try {
      final normalizedEmail = normalizeSchoolEmail(email);
      final response = await ref.read(sessionRepositoryProvider).signIn(
            email: normalizedEmail,
            password: password,
          );

      // 토큰 저장
      await TokenStorage.saveAccessToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveAccessTokenExpiry(response.accessTokenExpiresIn);
      await TokenStorage.saveRefreshTokenExpiry(response.refreshTokenExpiresIn);

      // 성공 처리
      state = LoginState.success(normalizedEmail);
    } on DioException catch (e) {
      _handleLoginDioException(e);
    } catch (e) {
      state = LoginState.failure(e.toString());
    }
  }

  /// 상태 초기화
  void reset() {
    state = LoginState.initial();
  }

  /// 에러 메시지 초기화
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(status: LoginStatus.initial, errorMessage: null);
    }
  }
}
